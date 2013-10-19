//
//  Redis.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "Redis.h"
#import "NSError+Redis.h"

#include "vedis.h"

@implementation Redis {
    vedis *_store;
}

- (id)init
{
    self = [super init];
    if (self) {
        _store = NULL;
        int rc = vedis_open(&_store, NULL /* in memory */);
        if (rc != VEDIS_OK) {
            NSError *error = [NSError rds_errorWithCode:rc store:_store];
            NSLog(@"[Redis] fatal: open error (%@)", [error rds_message]);
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    [self close:nil];
}

- (BOOL)close
{
    return [self close:nil];
}

- (BOOL)close:(NSError **)error
{
    int rc = vedis_close(_store);
    if (rc != VEDIS_OK) goto err;

    _store = NULL;
    return YES;
err:
    if (error) {
        *error = [NSError rds_errorWithCode:rc store:_store];
    }

    return NO;
}

- (NSString *)exec:(NSString *)command
{
    return [self exec:command error:nil];
}
- (NSString *)exec:(NSString *)command error:(NSError **)error
{
    int rc = vedis_exec(_store, [command UTF8String], -1);
    if (rc != VEDIS_OK) goto err;

    vedis_value *res;

    rc = vedis_exec_result(_store, &res);
    if (rc != VEDIS_OK) goto err;

    return [[NSString alloc] initWithCString:vedis_value_to_string(res, 0)
                                    encoding:NSUTF8StringEncoding];
err:
    if (error) {
        *error = [NSError rds_errorWithCode:rc store:_store];
    }

    return nil;
}

@end
