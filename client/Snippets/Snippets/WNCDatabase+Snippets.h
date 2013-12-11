//
//  WNCDatabase+Redis.h
//  Snippets
//
//  Created by Cédric Deltheil on 01/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Winch/Winch.h>

@class RDSCommand;

@interface WNCDatabase (Snippets)

- (BOOL)sn_syncForTopic:(NSString *)topic
            resultBlock:(WNCResultBlock)block
          progressBlock:(WNCProgressBlock)progressBlock
                  error:(NSError **)error;

- (NSInteger)sn_countCommandsForTopicForTopic:(NSString *)topic;

- (NSArray *)sn_fetchCommandsForTopic:(NSString *)topic error:(NSError **)error;

- (NSArray *)sn_fetchGroupsForTopic:(NSString *)topic error:(NSError **)error;

- (NSArray *)sn_fetchModelOfClass:(Class)modelClass
                         forTopic:(NSString *)topic
                            error:(NSError **)error;

- (NSString *)sn_getHTMLForCommand:(RDSCommand *)cmd forTopic:(NSString *)topic;

@end
