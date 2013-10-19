//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WNCDefines.h"

@class WNCDatabase;

/** A class that represents a data loading operation over one or several weak values.
 */
@interface WNCLoad : NSOperation

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
 * @see setResultBlock:
 */
@property (nonatomic, readonly, strong) NSError *error;

///---------------------------------------------------------------------------------------
/// @name Initialization and disposal
///---------------------------------------------------------------------------------------

/** Create a load operation related to a given database.
 *
 * In most cases, the caller should enqueue this operation into an `NSOperation` with
 * `addOperation:` to easily trigger its execution in the background.
 *
 * @param database the database handle.
 * @return A load operation handle.
 */
- (id)initWithDatabase:(WNCDatabase *)database;

///---------------------------------------------------------------------------------------
/// @name Arguments
///---------------------------------------------------------------------------------------

/** Append a key referring to a weak value to load into the internal list of arguments.
 *
 * You must append all the keys for the values you wish to load before adding this operation
 * into an operation queue.
 *
 * @param name the name of the namespace containing the value to load.
 * @param key the key that refers to the value to load.
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 */
- (BOOL)addNamespace:(NSString *)name
                 key:(NSString *)key
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
