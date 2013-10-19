//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Enumeration for error codes.
 */
typedef NS_ENUM(NSInteger, WNCErrorCode) {
    /** @abstract 0:  success. */
    WNCSuccess = 0,
    /** @abstract 1:  unspecified error. */
    WNCError,
    /** @abstract 2:  invalid use of the library. */
    WNCErrorMisuse,
    /** @abstract 3:  invalid database file. */
    WNCErrorInvalid,
    /** @abstract 4:  database version mismatch. */
    WNCErrorVersion,
    /** @abstract 5:  database file corrupted. */
    WNCErrorCorrupt,
    /** @abstract 6:  database file not found. */
    WNCErrorNoFile,
    /** @abstract 7:  database file locked. */
    WNCErrorBusy,
    /** @abstract 8:  bad credentials or no such namespace. */
    WNCErrorBadInput,
    /** @abstract 9:  access permission denied. */
    WNCErrorNoPerm,
    /** @abstract 10: no internet connection. */
    WNCErrorNoConn,
    /** @abstract 11: operation timeout. */
    WNCErrorTimeout,
    /** @abstract 12: internet connection too slow; */
    WNCErrorSlowConn,
    /** @abstract 13: record not found. */
    WNCErrorNoRec,
    /** @abstract 14: out of memory. */
    WNCErrorNoMem,
    /** @abstract 15: nothing to do. */
    WNCErrorNoOp,
    /** @abstract 16: weak value; please load first. */
    WNCErrorWeakVal,
    /** @abstract 17: operation cancelled. */
    WNCErrorCancel,
    /** @abstract 18: operation already pending. */
    WNCErrorPending,
    /** @abstract 19: operation forbidden. */
    WNCErrorForbid,
    /** @abstract 20: datastore credentials mismatch. */
    WNCErrorCred,
};

/** The error domain for Winch errors.
 */
extern NSString *const WinchErrorDomain;

/** `NSError` extensions dedicated to represent Winch errors.
 */
@interface NSError (Winch)

/** Create an error object configured with the Winch error domain.
 *
 * @param code the Winch error code (e.g `WNCErrorMisuse`)
 * @return The created error object.
 */
+ (NSError *)wnc_errorWithCode:(NSInteger)code;

/** Return the message string related to the error code.
 *
 * @return The user friendly message string.
 */
- (NSString *)wnc_message;

@end
