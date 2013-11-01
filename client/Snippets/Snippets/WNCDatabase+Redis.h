//
//  WNCDatabase+Redis.h
//  Snippets
//
//  Created by Cédric Deltheil on 01/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Winch/Winch.h>

@class RDSCommand;

@interface WNCDatabase (Redis)

- (BOOL)rds_syncWithBlock:(WNCResultBlock)block
            progressBlock:(WNCProgressBlock)progressBlock
                    error:(NSError **)error;

- (NSArray *)fetchCommands:(NSError **)error;

- (NSArray *)fetchGroups:(NSError **)error;

- (NSString *)getHTMLForCommand:(RDSCommand *)cmd;

@end
