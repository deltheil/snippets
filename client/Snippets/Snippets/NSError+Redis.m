//
//  NSError+Redis.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "NSError+Redis.h"

NSString *const RedisErrorDomain = @"net.symisc.Vedis.error";

@implementation NSError (Redis)

+ (NSError *)rds_errorWithCode:(NSInteger)code store:(vedis *)store
{
    if (code == RDS_OK)
        return nil;

    NSDictionary *userInfo = nil;

    if (store) {
        const char *err;
        int len = 0;
        vedis_config(store, VEDIS_CONFIG_ERR_LOG, &err, &len);
        if (len > 0) {
            NSString *msg = [[NSString alloc] initWithBytes:err length:len encoding:NSUTF8StringEncoding];
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
