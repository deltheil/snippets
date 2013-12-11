//
//  NSError+Redis.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "NSError+Redis.h"

NSString *const RedisErrorDomain = @"fakeredis";

@implementation NSError (Redis)

+ (NSError *)rds_errorWithCode:(NSInteger)code store:(void *)store
{
    if (code == FK_REDIS_OK)
        return nil;

    NSDictionary *userInfo = nil;

    if (store) {
        const char *err = fkredis_error(store);
        if (err) {
            NSString *msg = [[NSString alloc] initWithBytes:err length:strlen(err) encoding:NSUTF8StringEncoding];
            userInfo = @{ @"msg": msg };
        }
    }

    return [NSError errorWithDomain:RedisErrorDomain
                               code:code
                           userInfo:userInfo];
}

- (NSString *)rds_message
{
    return [self.userInfo objectForKey:@"msg"];
}

@end
