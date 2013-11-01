//
//  WNCDatabase+Redis.m
//  Snippets
//
//  Created by Cédric Deltheil on 01/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "WNCDatabase+Redis.h"

// Mantle models
#import "RDSCommand.h"
#import "RDSGroup.h"

#define CMDS   @"rds:cmds"
#define DOCS   @"rds:docs"
#define GROUPS @"rds:groups"
#define DEFOPT @(kWNCSyncDefault)

@implementation WNCDatabase (Redis)

- (BOOL)rds_syncWithBlock:(WNCResultBlock)block
            progressBlock:(WNCProgressBlock)progressBlock
                    error:(NSError **)error
{
    return [self sync:@{CMDS: DEFOPT, DOCS: DEFOPT, GROUPS: DEFOPT}
                block:block
        progressBlock:progressBlock
                error:error];
}

- (NSArray *)fetchCommands:(NSError **)error
{
    return [self fetchModelOfClass:RDSCommand.class error:error];
}

- (NSArray *)fetchGroups:(NSError **)error
{
    return [self fetchModelOfClass:RDSGroup.class error:error];
}

- (NSArray *)fetchModelOfClass:(Class)modelClass
                         error:(NSError **)error
{
    WNCNamespace *ns = nil;
    if (modelClass == RDSCommand.class) {
        ns = [self getNamespace:CMDS];
    }
    else if (modelClass == RDSGroup.class) {
        ns = [self getNamespace:GROUPS];
    }
    
    NSMutableArray *models = [NSMutableArray array];
    
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
        id model = [MTLJSONAdapter modelOfClass:modelClass
                              fromJSONDictionary:jsonDict
                                           error:&parseError];
        if (parseError) {
            dataError = YES;
            *option = kWNCIterStop;
            return;
        }
        
        if ([model isKindOfClass:[RDSCommand class]]) {
            RDSCommand *cmd = (RDSCommand *) model;
            cmd.uid = key;
        }
        
        [models addObject:model];
    } error:&iterError];
    
    if (iterError || dataError) {
        if (error) {
            *error = [NSError errorWithDomain:@"WNCDatabase+Redis" code:1 userInfo:nil];
        }
        
        return nil;
    }
    
    if (modelClass == RDSGroup.class) {
        // Prepend a special group that contains *all* the commands
        [models insertObject:[RDSGroup groupsUnion:models] atIndex:0];
    }
    
    return models;
}

- (NSString *)getHTMLForCommand:(RDSCommand *)cmd
{
    WNCNamespace *ns = [self getNamespace:DOCS];
    NSData *data = [ns getDataForKey:cmd.uid];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
