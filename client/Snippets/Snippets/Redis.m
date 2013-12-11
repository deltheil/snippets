//
//  Redis.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "Redis.h"
#import "NSError+Redis.h"

#include "fkredis.h"

@implementation Redis {
    void *_store;
}

- (id)init
{
    self = [super init];
    if (self) {
        _store = NULL;
        int rc = fkredis_open(&_store);
        if (rc != FK_REDIS_OK) {
            NSError *error = [NSError rds_errorWithCode:rc store:_store];
            fkredis_close(_store);
            NSLog(@"[Redis] fatal: open error (%@)", [error rds_message]);
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    [self close];
}

- (void)close
{
    fkredis_close(_store);
    _store = NULL;
}

- (NSString *)exec:(NSString *)command
{
    return [self exec:command error:nil];
}
- (NSString *)exec:(NSString *)command error:(NSError **)error
{
    int rc;
    char *resp = NULL;
    
    rc = fkredis_exec(_store, [command UTF8String], &resp);
    
    if (rc != FK_REDIS_OK) {
        goto err;
    }
    
    return [[NSString alloc] initWithBytesNoCopy:resp
                                   length:strlen(resp)
                                 encoding:NSUTF8StringEncoding
                             freeWhenDone:YES];

err:
    if (error) {
        *error = [NSError rds_errorWithCode:rc store:_store];
    }

    return nil;
}

@end
