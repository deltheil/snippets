//
//  NSError+Redis.h
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "vedis.h"

typedef NS_ENUM(NSInteger, RDSErrorCode) {
    RDS_OK = SXRET_OK,
    RDS_NOMEM = SXERR_MEM,
    RDS_ABORT = SXERR_ABORT,
    RDS_IOERR = SXERR_IO,
    RDS_CORRUPT = SXERR_CORRUPT,
    RDS_LOCKED = SXERR_LOCKED,
    RDS_BUSY = SXERR_BUSY,
    RDS_DONE = SXERR_DONE,
    RDS_PERM = SXERR_PERM,
    RDS_NOTIMPLEMENTED = SXERR_NOTIMPLEMENTED,
    RDS_NOTFOUND = SXERR_NOTFOUND,
    RDS_NOOP = SXERR_NOOP,
    RDS_INVALID = SXERR_INVALID,
    RDS_EOF = SXERR_EOF,
    RDS_UNKNOWN = SXERR_UNKNOWN,
    RDS_LIMIT = SXERR_LIMIT,
    RDS_EXISTS = SXERR_EXISTS,
    RDS_EMPTY = SXERR_EMPTY,
    RDS_FULL = (-73),
    RDS_CANTOPEN = (-74),
    RDS_READ = (-75),
    RDS_LOCKERR = (-76)
};

extern NSString *const RedisErrorDomain;

@interface NSError (Redis)

+ (NSError *)rds_errorWithCode:(NSInteger)code store:(vedis *)store;
- (NSString *)rds_message;

@end
