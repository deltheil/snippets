//
//  RDSCommand.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "RDSCommand.h"

#import <Winch/Winch.h>

static __weak WNCDatabase *_wnc_database;

NSString * const kRDSCommandsNS = @"rds:cmds";

@implementation RDSCommand

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"name",
             @"summary": @"summary"
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

@end
