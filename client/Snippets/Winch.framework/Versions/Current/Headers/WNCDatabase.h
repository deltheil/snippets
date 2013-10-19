//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WNCDefines.h"

@class WNCNamespace;

/** A class that represents a local database that is able to keep in sync
 * with a remote, central datastore.
 *
 * A datastore is made of a collection of **records** grouped within **namespaces**.
 *
 * You can think of a namespace as a table. Namespaces allow you to organize your data
 * and control what data will be synchronized and how.
 *
 * Namespaces contain records. Records are the things that hold your data, they are composed
 * of a key and a value.
 *
 * The database can **synchronize** one or several namespaces at once, in a **data-pull** fashion.
 *
 * The goal of the synchronization is to maintain the local database up-to-date with the
 * server-side datastore, and thus to create, update or delete client-side records accordingly.
 *
 * By default, a synchronization operation ensures that both key *and* value are downloaded for
 * every new record. Thus, after each successful synchronization, the records are available offline.
 *
 * Optionally, you can synchronize a namespace in **weak** mode. In such a case only the keys of
 * the new records are downloaded, but not the values. In consequence, to read a weak value later
 * on, you must first perform a **load** operation which requires a working Internet connection.
 *
 * Think of weak values as a way to provide on-demand data loading (a.k.a lazy loading).
 *
 * @warning Please refer to https://winch.io/documentation/ for more details.
 */
@interface WNCDatabase : NSObject

/** The pointer to the underlying database handle.
 */
@property (nonatomic, readonly) void *handle;

///---------------------------------------------------------------------------------------
/// @name Initialization and disposal
///---------------------------------------------------------------------------------------

/** Get the absolute path that allows to store `fileName` under `Library/Caches`.
 *
 * @param fileName the requested file name.
 * @return The corresponding path that you may want to use as an input for databaseWithPath:
 */
+ (NSString *)cachesPathFor:(NSString *)fileName;

/** Get a database handle for the given path.
 *
 * @param path the database path.
 * @return A database handle.
 */
+ (id)databaseWithPath:(NSString *)path;

/** Open the database.
 *
 * You must use valid datastore credentials (namely `id` and `app_secret`) obtained via the
 * Winch HTTP API (see https://winch.io/documentation/ for more details).
 *
 * This is mandatory before you start interacting with any other methods.
 *
 * @param ID a valid datastore ID obtained via the Winch HTTP API.
 * @param appSecret the datastore application secret obtained via the Winch HTTP API.
 * @return `YES` if OK, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorInvalid` (the path you have provided
 * does not refer to a valid database file), `WNCErrorVersion` (the database file version is not
 * compatible as-is with this framework version), `WNCErrorCorrupt` (the database file is
 * corrupted) or `WNCErrorCred` (you have previously opened the database with different
 * credentials. If you made a mistake: de-install your app and re-install it with the right
 * datastore credentials).
 */
- (BOOL)openWithID:(NSString *)ID
         appSecret:(NSString *)appSecret;

/** Open the database.
 *
 * You must use valid datastore credentials (namely `id` and `app_secret`) obtained via the
 * Winch HTTP API (see https://winch.io/documentation/ for more details).
 *
 * This is mandatory before you start interacting with any other methods.
 *
 * @param ID a valid datastore ID obtained via the Winch HTTP API.
 * @param appSecret the datastore application secret obtained via the Winch HTTP API.
 * @param error the pointer to the error object, if any.
 * @return `YES` if OK, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorInvalid` (the path you have provided
 * does not refer to a valid database file), `WNCErrorVersion` (the database file version is not
 * compatible as-is with this framework version), `WNCErrorCorrupt` (the database file is
 * corrupted) or `WNCErrorCred` (you have previously opened the database with different
 * credentials. If you made a mistake: de-install your app and re-install it with the right
 * datastore credentials).
 */
- (BOOL)openWithID:(NSString *)ID
         appSecret:(NSString *)appSecret
             error:(NSError **)error;

/** Close the database.
 *
 * Use this when you stop interacting with the database. In particular it is
 * mandatory to close the database right before the application will exit.
 *
 * @return `YES` if it succeeded, `NO` otherwise.
 */
- (BOOL)close;

/** Close the database.
 *
 * Use this when you stop interacting with the database. In particular it is
 * mandatory to close the database right before the application will exit.
 *
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 */
- (BOOL)close:(NSError **)error;

///---------------------------------------------------------------------------------------
/// @name Namespace
///---------------------------------------------------------------------------------------

/** Get an object to interact with a given namespace.
 *
 * @param name the name of the requested namespace.
 * @return The namespace object, or nil if an error occurred.
 */
- (WNCNamespace *)getNamespace:(NSString *)name;

///---------------------------------------------------------------------------------------
/// @name Synchronization
///---------------------------------------------------------------------------------------

/** Perform a data synchronization in the background for one or several namespaces.
 *
 * The namespaces to synchronize are provided via a dictionary for which:
 *
 * - each key is an `NSString` that refers to the name of a namespace to synchronize,
 * - each value is an `NSNumber` that contains the synchronization options for the related namespace.
 *
 * For example, to synchronize `@"ns1"` in default mode, and `@"ns2"` in weak mode you should
 * provide the following parameters:
 *
 *    `NSDictionary *params = @{ @"ns1": @(kWNCSyncDefault), @"ns2": @(kWNCSyncWeak) }`
 *
 * @param params the parameters indicating which namespaces to synchronize.
 * @param error the pointer to the error object, if any.
 * @return `YES` if the synchronization has been successfully added to the internal operations
 * queue, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorForbid` (you try to synchronize a
 * namespace that already contains local records: this is forbidden. You must drop all records
 * of this namespace before you can synchronize it with the remote content), or `WNCErrorPending`
 * (a sync is already pending for this namespace).
 *
 * This method **always** raises an `NSInternalInconsistencyException` if the input `params`
 * dictionary is not filled correctly.
 */
- (BOOL)sync:(NSDictionary *)params
       error:(NSError **)error;

/** Perform a data synchronization in the background for one or several namespaces.
 *
 * The namespaces to synchronize are provided via a dictionary for which:
 *
 * - each key is an `NSString` that refers to the name of a namespace to synchronize,
 * - each value is an `NSNumber` that contains the synchronization options for the related namespace.
 *
 * For example, to synchronize `@"ns1"` in default mode, and `@"ns2"` in weak mode you should
 * provide the following parameters:
 *
 *    `NSDictionary *params = @{ @"ns1": @(kWNCSyncDefault), @"ns2": @(kWNCSyncWeak) };`
 *
 * @param params the parameters indicating which namespaces to synchronize.
 * @param block the block that is called when the operation is completed.
 * @param error the pointer to the error object, if any.
 * @return `YES` if the synchronization has been successfully added to the internal operations
 * queue, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorForbid` (you try to synchronize a
 * namespace that already contains local records: this is forbidden. You must drop all records
 * of this namespace before you can synchronize it with the remote content), or `WNCErrorPending`
 * (a sync is already pending for this namespace).
 *
 * This method **always** raises an `NSInternalInconsistencyException` if the input `params`
 * dictionary is not filled correctly.
 */
- (BOOL)sync:(NSDictionary *)params
       block:(WNCResultBlock)block
       error:(NSError **)error;

/** Perform a data synchronization in the background for one or several namespaces.
 *
 * The namespaces to synchronize are provided via a dictionary for which:
 *
 * - each key is an `NSString` that refers to the name of a namespace to synchronize,
 * - each value is an `NSNumber` that contains the synchronization options for the related namespace.
 *
 * For example, to synchronize `@"ns1"` in default mode, and `@"ns2"` in weak mode you should
 * provide the following parameters:
 *
 *    `NSDictionary *params = @{ @"ns1": @(kWNCSyncDefault), @"ns2": @(kWNCSyncWeak) };`
 *
 * @param params the parameters indicating which namespaces to synchronize.
 * @param block the block that is called when the operation is completed.
 * @param progressBlock the block that triggers the progress events.
 * @param error the pointer to the error object, if any.
 * @return `YES` if the synchronization has been successfully added to the internal operations
 * queue, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorForbid` (you try to synchronize a
 * namespace that already contains local records: this is forbidden. You must drop all records
 * of this namespace before you can synchronize it with the remote content), or `WNCErrorPending`
 * (a sync is already pending for this namespace).
 *
 * This method **always** raises an `NSInternalInconsistencyException` if the input `params`
 * dictionary is not filled correctly.
 */
- (BOOL)sync:(NSDictionary *)params
        block:(WNCResultBlock)block
progressBlock:(WNCProgressBlock)progressBlock
        error:(NSError **)error;

///---------------------------------------------------------------------------------------
/// @name Value Loading
///---------------------------------------------------------------------------------------

/** Perform a data loading in the background for one or several weak values.
 *
 * The values to synchronize are provided via a dictionary for which:
 *
 * - each key is an `NSString` that refers to the name of a namespace,
 * - each value is an `NSString` that refers to the key of the value to synchronize.
 *
 * For example, to synchronize the value represented by the `@"foo"` key within the
 * `@"ns1"` namespace, you should provide the following parameters:
 *
 *    `NSDictionary *params = @{ @"ns1": @"foo" };`
 *
 * You can also load multiple values at once by providing an array of keys:
 *
 *    `NSDictionary *params = @{ @"ns1": @[ @"foo", @"bar", @"baz" ] };`
 *
 * @param params the parameters indicating which values to synchronize.
 * @param error the pointer to the error object, if any.
 * @return `YES` if the synchronization has been successfully added to the internal operations
 * queue, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorNoOp` (nothing to do: you try to load a
 * value that is already loaded), `WNCErrorNoRec` (no such record: you try to load a value for a
 * key that does not exist) or `WNCErrorPending` (a sync is pending for this namespace, so you
 * cannot load any value right now: you must try again later).
 *
 * This method **always** raises an `NSInternalInconsistencyException` if the input `params`
 * dictionary is not filled correctly.
 */
- (BOOL)load:(NSDictionary *)params
       error:(NSError **)error;

/** Perform a data loading in the background for one or several weak values.
 *
 * The values to synchronize are provided via a dictionary for which:
 *
 * - each key is an `NSString` that refers to the name of a namespace,
 * - each value is an `NSString` that refers to the key of the value to synchronize.
 *
 * For example, to synchronize the value represented by the `@"foo"` key within the
 * `@"ns1"` namespace, you should provide the following parameters:
 *
 *    `NSDictionary *params = @{ @"ns1": @"foo" };`
 *
 * You can also load multiple values at once by providing an array of keys:
 *
 *    `NSDictionary *params = @{ @"ns1": @[ @"foo", @"bar", @"baz" ] };`
 *
 * @param params the parameters indicating which values to synchronize.
 * @param block the block that is called when the operation is completed.
 * @param error the pointer to the error object, if any.
 * @return `YES` if the synchronization has been successfully added to the internal operations
 * queue, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorNoOp` (nothing to do: you try to load a
 * value that is already loaded), `WNCErrorNoRec` (no such record: you try to load a value for a
 * key that does not exist) or `WNCErrorPending` (a sync is pending for this namespace, so you
 * cannot load any value right now: you must try again later).
 *
 * This method **always** raises an `NSInternalInconsistencyException` if the input `params`
 * dictionary is not filled correctly.
 */
- (BOOL)load:(NSDictionary *)params
       block:(WNCResultBlock)block
       error:(NSError **)error;

/** Perform a data loading in the background for one or several weak values.
 *
 * The values to synchronize are provided via a dictionary for which:
 *
 * - each key is an `NSString` that refers to the name of a namespace,
 * - each value is an `NSString` that refers to the key of the value to synchronize.
 *
 * For example, to synchronize the value represented by the `@"foo"` key within the
 * `@"ns1"` namespace, you should provide the following parameters:
 *
 *    `NSDictionary *params = @{ @"ns1": @"foo" };`
 *
 * You can also load multiple values at once by providing an array of keys:
 *
 *    `NSDictionary *params = @{ @"ns1": @[ @"foo", @"bar", @"baz" ] };`
 *
 * @param params the parameters indicating which values to synchronize.
 * @param block the block that is called when the operation is completed.
 * @param progressBlock the block that triggers the progress events.
 * @param error the pointer to the error object, if any.
 * @return `YES` if the synchronization has been successfully added to the internal operations
 * queue, `NO` otherwise.
 *
 * @warning **Note:** some possible errors are `WNCErrorNoOp` (nothing to do: you try to load a
 * value that is already loaded), `WNCErrorNoRec` (no such record: you try to load a value for a
 * key that does not exist) or `WNCErrorPending` (a sync is pending for this namespace, so you
 * cannot load any value right now: you must try again later).
 *
 * This method **always** raises an `NSInternalInconsistencyException` if the input `params`
 * dictionary is not filled correctly.
 */
- (BOOL)load:(NSDictionary *)params
        block:(WNCResultBlock)block
progressBlock:(WNCProgressBlock)progressBlock
        error:(NSError **)error;

///---------------------------------------------------------------------------------------
/// @name Operations Cancelling
///---------------------------------------------------------------------------------------

/** Cancel all pending synchronization and loading operations.
 */
- (void)cancel;

@end
