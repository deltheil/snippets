//
//  NSError+Redis.h
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "fkredis.h"

typedef NS_ENUM(NSInteger, RDSErrorCode) {
    RDS_OK = FK_REDIS_OK,
    RDS_ERROR = FK_REDIS_ERROR
};

extern NSString *const RedisErrorDomain;

@interface NSError (Redis)

+ (NSError *)rds_errorWithCode:(NSInteger)code store:(void *)store;
- (NSString *)rds_message;

@end
