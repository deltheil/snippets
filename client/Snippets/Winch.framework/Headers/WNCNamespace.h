//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WNCDefines.h"

@class WNCDatabase;

/** A class that represents a collection of records within a Winch database.
 */
@interface WNCNamespace : NSObject

///---------------------------------------------------------------------------------------
/// @name Properties
///---------------------------------------------------------------------------------------

/** The name of the namespace.
 */
@property (nonatomic, readonly, strong) NSString *name;

/** The database that owns this namespace.
 */
@property (nonatomic, readonly, strong) WNCDatabase *database;

///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/** Create a namespace related to a parent database.
 *
 * @param database the database handle that owns this namespace.
 * @param name the namespace name.
 * @return A namespace instance.
 */
- (id)initWithDatabase:(WNCDatabase *)database
                  name:(NSString *)name;

///---------------------------------------------------------------------------------------
/// @name Read
///---------------------------------------------------------------------------------------

/** Get data for the given key.
 *
 * @param key the key to search for.
 * @return The corresponding data object if any, or `nil` otherwise.
 *
 * @warning **Note:** if an error occurred, `nil` is returned. In most cases `nil`
 * is returned when there is no such record which corresponds to the `WNCErrorNoRec` error
 * code. You may want to use the getDataForKey:error: method to get the error code in addition.
 */
- (NSData *)getDataForKey:(NSString *)key;

/** Get data for the given key.
 *
 * @param key the key to search for.
 * @param error the pointer to the error object, if any.
 * @return The corresponding data object if any, or `nil` otherwise.
 *
 * @warning **Note:** if an error occurred, `nil` is returned. In most cases `nil`
 * is returned when there is no such record which corresponds to the `WNCErrorNoRec` error
 * code.
 */
- (NSData *)getDataForKey:(NSString *)key
                    error:(NSError **)error;

/** Count the number of records currently in the namespace.
 *
 * @return the total number of records, or -1 if an error occurred.
 */
- (NSInteger)count;

///---------------------------------------------------------------------------------------
/// @name Write
///---------------------------------------------------------------------------------------

/** Store data for the given key.
 *
 * It is important to note that this function only acts **locally**.
 * In other words, data written with this method is never replicated
 * (a.k.a synchronized) *in the cloud*, which means that you will **NOT**
 * be able to synchronize this namespace within another environment.
 *
 * So this method acts as a local persistent cache. Thus it is particularly
 * useful when you need to persist locally the response from a web service,
 * an image blob, a browsing history, etc.
 *
 * If you ever need to dispatch such data remotely, you are responsible to
 * do it at the application level, and out of scope of the corresponding class.
 *
 * @param data the data to store in the database.
 * @param key the key to be stored in the database.
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 * @see removeDataForKey:error:
 *
 * @warning **Warning:** this method can only be used if this namespace does not
 * refer to a namespace previously synchronized. Symmetrically, one cannot
 * synchronize this namespace further on as soon as some data has been written into
 * it. If you do not respect the above limitations, the `WNCErrorForbid` error code is
 * returned.
 */
- (BOOL)putData:(NSData *)data
         forKey:(NSString *)key
          error:(NSError **)error;

/** Remove data for the given key.
 *
 * This is only possible for records created with the put:data:error:
 * method. It is **NOT** available for records that have been created via a
 * synchronization operation.
 *
 * If you attempt to remove a record created by the means of a synchronization
 * operation, the `WNCErrorForbid` error code is returned.
 *
 * @param key the key to remove from the database.
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 * @see putData:forKey:error:
 */
- (BOOL)removeDataForKey:(NSString *)key
                   error:(NSError **)error;

/** Remove all records from this namespace.
 *
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 */
- (BOOL)dropAllRecords:(NSError **)error;

///---------------------------------------------------------------------------------------
/// @name Enumerate
///---------------------------------------------------------------------------------------

/** Iterate through every record.
 *
 * By default, the records are sorted by keys with ascending string order.
 *
 * Via the given block, the caller can use the `options` variable as follow:
 *
 * - 0 (default) to keep iterating,
 * - `kWNCIterPut` to modify in place the **local** record with the content of `data`,
 * - `kWNCIterOut` to delete the corresponding **local** record,
 * - `kWNCIterStop` to stop iterating over the records.
 *
 * @param block the block called for each encountered record.
 * @return `YES` if it succeeded, `NO` otherwise.
 *
 * @warning **Important:** the `kWNCIterPut` and `kWNCIterOut` options are
 * reserved to records that have been created **locally** i.e via the
 * putData:forKey:error: method. If you do not respect this limitation, the
 * `WNCErrorForbid` error code is returned.
 */
- (BOOL)enumerateRecordsUsingBlock:(WNCIterBlock)block;

/** Iterate through every record.
 *
 * By default, the records are sorted by keys with ascending string order.
 *
 * Via the given block, the caller can use the `options` variable as follow:
 *
 * - 0 (default) to keep iterating,
 * - `kWNCIterPut` to modify in place the **local** record with the content of `data`,
 * - `kWNCIterOut` to delete the corresponding **local** record,
 * - `kWNCIterStop` to stop iterating over the records.
 *
 * @param block the block called for each encountered record.
 * @param error the pointer to the error object, if any.
 * @return `YES` if it succeeded, `NO` otherwise.
 *
 * @warning **Important:** the `kWNCIterPut` and `kWNCIterOut` options are
 * reserved to records that have been created **locally** i.e via the
 * putData:forKey:error: method. If you do not respect this limitation, the
 * `WNCErrorForbid` error code is returned.
 */
- (BOOL)enumerateRecordsUsingBlock:(WNCIterBlock)block
                             error:(NSError **)error;

@end
