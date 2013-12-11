//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WNCDefines.h"

@class WNCDatabase;

/** A class that represents a data synchronization operation over one or several namespaces.
 */
@interface WNCSync : NSOperation

///---------------------------------------------------------------------------------------
/// @name Properties
///---------------------------------------------------------------------------------------

/** The database related to this operation.
 */
@property (nonatomic, readonly) WNCDatabase *database;

/** The operation error.
 *
 * This must be checked as soon as the result block is called. If the operation succeeded
 * the error is `nil`. If the operation has been cancelled the error code is `WNCErrorCancel`.
 * Otherwise an appropriate error code is set.
 *
 * @warning **Note:** some possible errors are `WNCErrorBadInput` (the sync failed because the
 * corresponding namespace does not exist, or the datastore ID is invalid) or `WNCErrorBadSecret`
 * (the database has been opened with an invalid app secret).
 *
 * @see setResultBlock:
 */
@property (nonatomic, readonly, strong) NSError *error;

///---------------------------------------------------------------------------------------
/// @name Initialization and disposal
///---------------------------------------------------------------------------------------

/** Create a synchronization operation related to a given database.
 *
 * In most cases, the caller should enqueue this operation into an `NSOperation` with
 * `addOperation:` to easily trigger its execution in the background.
 *
 * @param database the database handle.
 * @return A synchronization operation handle.
 */
- (id)initWithDatabase:(WNCDatabase *)database;

///---------------------------------------------------------------------------------------
/// @name Arguments
///---------------------------------------------------------------------------------------

/** Append a namespace to synchronize to the internal list of arguments.
 *
 * You must append all the namespace you wish to synchronize before adding this operation
 * into an operation queue.
 *
 * @param name the name of the namespace to synchronize.
 * @param options the synchronization options for the related namespace.
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 */
- (BOOL)addNamespace:(NSString *)name
             options:(int)options
               error:(NSError **)error;

///---------------------------------------------------------------------------------------
/// @name Operation life-cycle
///---------------------------------------------------------------------------------------

/** Register to the operation progress.
 *
 * @param progressBlock the block that triggers the progress events.
 */
- (void)setProgressBlock:(WNCProgressBlock)progressBlock;

/** Register to the operation cancelling.
 *
 * In most cases, the operation is cancelled when the caller calls `NSOperation` `cancelAllOperations`
 * on the operation queue that holds this operation.
 *
 * @param cancelBlock the block that is called as soon as the operation is cancelled.
 */
- (void)setCancelBlock:(WNCCancelBlock)cancelBlock;

/** Register to the operation completion.
 *
 * @param resultBlock the block that is called when the operation is completed.
 * @see error
 */
- (void)setResultBlock:(WNCResultBlock)resultBlock;

@end
