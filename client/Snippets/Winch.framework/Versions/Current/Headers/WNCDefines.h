//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

///---------------------------------------------------------------------------------------
/// @name Record Iterator Options
///---------------------------------------------------------------------------------------

/** overwrite the record (only for local data).
 */
extern int const kWNCIterPut;
/** delete the record (only for local data).
 */
extern int const kWNCIterOut;
/** stop the iterations.
 */
extern int const kWNCIterStop;

///---------------------------------------------------------------------------------------
/// @name Namespace Iterator Returned Types
///---------------------------------------------------------------------------------------

/** remote namespace.
 */
extern int const kWNCNamespaceRemote;
/** local namespace.
 */
extern int const kWNCNamespaceLocal;

///---------------------------------------------------------------------------------------
/// @name Database synchronization modes.
///---------------------------------------------------------------------------------------

/** default synchronization mode: both keys and values are synchronized.
 */
extern int const kWNCSyncDefault;
/** weak synchronization mode: only keys are synchronized. Values must be lazily loaded.
 */
extern int const kWNCSyncWeak;

///---------------------------------------------------------------------------------------
/// @name Blocks
///---------------------------------------------------------------------------------------

/** Type of a block used for an operation progress.
 */
typedef void (^WNCProgressBlock)(NSInteger percentDone);

/** Type of a block used when an operation is cancelled.
 */
typedef void (^WNCCancelBlock)(id object);

/** Type of a block used when an operation is completed.
 */
typedef void (^WNCResultBlock)(id object, NSError *error);

/** Type of a block triggered when the next record is fetched from a database.
 */
typedef void (^WNCIterBlock)(NSString *key, NSMutableData *data, int *option);

/** Type of a block triggered when the next namespace is fetched from a database.
 */
typedef void (^WNCNamespaceIterBlock)(NSString *name, int type);
