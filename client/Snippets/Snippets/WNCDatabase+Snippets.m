//
//  WNCDatabase+Redis.m
//  Snippets
//
//  Created by Cédric Deltheil on 01/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "WNCDatabase+Snippets.h"
#import "WNCSnippetsDefines.h"

// Mantle models
#import "Command.h"
#import "RDSGroup.h"

@implementation WNCDatabase (Snippets)

- (BOOL)sn_syncForTopic:(NSString *)topic
            resultBlock:(WNCResultBlock)resultBlock
          progressBlock:(WNCProgressBlock)progressBlock
                  error:(NSError **)error
{
    return [self sync:@{SN_CMDS_TOPIC(topic): DEF_OPT,
                        SN_DOCS_TOPIC(topic): DEF_OPT,
                        SN_GROUPS_TOPIC(topic): DEF_OPT}
            
                block:resultBlock
        progressBlock:progressBlock
                error:error];
}

- (NSInteger)sn_countCommandsForTopicForTopic:(NSString *)topic
{
    return [[self getNamespace:SN_CMDS_TOPIC(topic)] count];
}

- (NSArray *)sn_fetchCommandsForTopic:(NSString *)topic error:(NSError **)error
{
    return [self sn_fetchModelOfClass:Command.class forTopic:topic error:error];
}

- (NSArray *)sn_fetchGroupsForTopic:(NSString *)topic error:(NSError **)error
{
    return [self sn_fetchModelOfClass:RDSGroup.class forTopic:topic error:error];
}

- (NSArray *)sn_fetchModelOfClass:(Class)modelClass
                          forTopic:(NSString *)topic
                             error:(NSError **)error
{
    NSError *err = nil;
    __block NSError *parseErr = nil; // JSON or Mantle error
    
    WNCNamespace *ns = nil;
    if (modelClass == Command.class) {
        ns = [self getNamespace:SN_CMDS_TOPIC(topic)];
    }
    else if (modelClass == RDSGroup.class) {
        ns = [self getNamespace:SN_GROUPS_TOPIC(topic)];
    }
    
    NSMutableArray *models = [NSMutableArray array];
    
    void (^recordBlock)(NSString *, NSMutableData *, int *) = ^(NSString *key, NSMutableData *data, int *option) {
        id jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                      options:0
                                                        error:&parseErr];
        if (parseErr) {
            *option = kWNCIterStop;
            return;
        }
        
        id model = [MTLJSONAdapter modelOfClass:modelClass
                             fromJSONDictionary:jsonDict
                                          error:&parseErr];
        if (parseErr) {
            *option = kWNCIterStop;
            return;
        }
        
        if ([model isKindOfClass:[Command class]]) {
            Command *cmd = (Command *) model;
            cmd.uid = key;
        }
        
        [models addObject:model];
    };
    
    if (![ns enumerateRecordsUsingBlock:recordBlock
                                  error:&err]) {
        goto fail;
    }
    
    if (parseErr) {
        err = parseErr;
        goto fail;
    }
    
    if (modelClass == RDSGroup.class) {
        // Prepend a special group that contains *all* the commands
        [models insertObject:[RDSGroup groupsUnion:models] atIndex:0];
    }
    
    return models;
    
fail:
    if (error) {
        *error = err;
    }
    
    return nil;
}

- (NSString *)sn_getHTMLForCommand:(Command *)cmd forTopic:(NSString *)topic
{
    WNCNamespace *ns = [self getNamespace:SN_DOCS_TOPIC(topic)];
    NSData *data = [ns getDataForKey:cmd.uid];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
