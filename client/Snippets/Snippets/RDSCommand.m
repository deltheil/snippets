//
//  RDSCommand.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "RDSCommand.h"

#import <Winch/Winch.h>

#import "RDSType.h" // for the extra namespace (kRDSTypesNS)

static __weak WNCDatabase *_wnc_database;

NSString * const kRDSCommandsNS = @"rds:cmds";
NSString * const kRDSCommandsHTMLNS = @"rds:cmds_html";

@implementation RDSCommand

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"name",
             @"summary": @"summary",
             @"cli": @"cli"
    };
}

+ (NSArray *)fetch
{
    return [self fetch:nil];
}

+ (void)setDatabase:(WNCDatabase *)database
{
    _wnc_database = database;
}

+ (NSArray *)fetch:(NSError **)error
{
    WNCNamespace *ns = [_wnc_database getNamespace:kRDSCommandsNS];
    NSMutableArray *cmds = [NSMutableArray array];
    NSError *iterError = nil;
    __block BOOL dataError = NO;
    
    [ns enumerateRecordsUsingBlock:^(NSString *key, NSMutableData *data, int *option) {
        NSError *jsonError = nil;
        id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            dataError = YES;
            *option = kWNCIterStop;
            return;
        }
        
        NSError *parseError = nil;
        RDSCommand *cmd = [MTLJSONAdapter modelOfClass:RDSCommand.class
                                    fromJSONDictionary:jsonDict
                                                 error:&parseError];
        if (parseError) {
            dataError = YES;
            *option = kWNCIterStop;
            return;
        }
        
        cmd.uid = key;
        
        [cmds addObject:cmd];
    } error:&iterError];
    
    if (iterError || dataError) {
        if (error) {
            *error = [NSError errorWithDomain:@"RDSCommand" code:1 userInfo:nil];
            return nil;
        }
    }
    
    return cmds;
}

+ (RDSCommand *)getCommand:(NSString *)uid
{
    WNCNamespace *ns = [_wnc_database getNamespace:kRDSCommandsNS];
    NSData *data = [ns getDataForKey:uid];
    
    if (!data) {
        // This should never happen with a consistent datastore
        return nil;
    }
    
    // TODO: check errors
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    RDSCommand *cmd = [MTLJSONAdapter modelOfClass:RDSCommand.class
                                fromJSONDictionary:jsonDict
                                             error:nil];
    
    [cmd setUid:uid];
    
    return cmd;
}

- (NSString *)getHTMLString
{
    WNCNamespace *ns = [_wnc_database getNamespace:kRDSCommandsHTMLNS];
    NSData *data = [ns getDataForKey:self.uid];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (void)sync:(void (^)(NSArray *cmds, NSArray *types, NSError *error))block
{
    return [self sync:block progress:nil];
}

+ (void)sync:(void (^)(NSArray *cmds, NSArray *types, NSError *error))block
    progress:(void (^)(NSInteger percentDone))progressBlock
{
    NSError *err = nil;
    NSDictionary *params = @{
                             kRDSCommandsNS: @(kWNCSyncDefault),
                             kRDSCommandsHTMLNS: @(kWNCSyncDefault),
                             kRDSTypesNS: @(kWNCSyncDefault)
                             };
    
    [_wnc_database sync:params block:^(id object, NSError *error) {
        if (error)
            return block(nil, nil, error);
        
        NSError *loadError = nil;
        NSArray *cmds = [self fetch:&loadError];
        NSArray *types = nil;
        if (!loadError) {
            types = [RDSType fetch:&loadError];
        }
        
        
        block(cmds, types, loadError);
    }
    progressBlock:progressBlock error:&err];
    
    if (err) {
        block(nil, nil, err);
    }
}

@end
