//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WNCDefines.h"

@class WNCDatabase;

/** `UIImageView` extensions used to ease the ability to create an image
 * from a blob stored within a winch database (see WNCDatabase).
 *
 * The image should be associated to a record within a given namespace. In
 * such a case the record key represents the image unique identifier, and
 * the value represents the image data such as a JPEG blob.
 *
 * The record may already be available locally - if the image has previously
 * been loaded or synchronized, or not. In such a case the value is said to be
 * weak. If the image data is not present, this extension provides a set of
 * convenient methods to load it asynchronously.
 */
@interface UIImageView (Winch)

///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/** Setup the database to be used for further load operations.
 *
 * @param database the database to use for any subsequent extensions calls.
 *
 * This is mandatory before using the extensions below.
 */
+ (void)wnc_setDatabase:(WNCDatabase *)database;

///---------------------------------------------------------------------------------------
/// @name Load
///---------------------------------------------------------------------------------------

/** Load the image for the given key and namespace, and refresh the image view.
 *
 * If the corresponding data is weak, this method loads it asynchronously.
 *
 * @param name the namespace to work with.
 * @param key the key that refers to the image data.
 *
 * @see wnc_setDatabase:
 */
- (void)wnc_loadImageWithNamespace:(NSString *)name
                               key:(NSString *)key;

/** Load the image for the given key and namespace, and refresh the image view.
 *
 * If the corresponding data is weak, this method loads it asynchronously.
 *
 * @param name the namespace to work with.
 * @param key the key that refers to the image data.
 * @param block the block that is called as soon as the image gets loaded.
 *
 * @see wnc_setDatabase:
 */
- (void)wnc_loadImageWithNamespace:(NSString *)name
                               key:(NSString *)key
                             block:(WNCResultBlock)block;

/** Load the image for the given key and namespace, and refresh the image view.
 *
 * If the corresponding data is weak, this method loads it asynchronously.
 *
 * @param name the namespace to work with.
 * @param key the key that refers to the image data.
 * @param block the block that is called as soon as the image gets loaded.
 * @param placeholder the placeholder image to use while the image is being loaded.
 *
 * @see wnc_setDatabase:
 */
- (void)wnc_loadImageWithNamespace:(NSString *)name
                               key:(NSString *)key
                             block:(WNCResultBlock)block
                       placeholder:(UIImage *)placeholder;

///---------------------------------------------------------------------------------------
/// @name Cancel
///---------------------------------------------------------------------------------------

/** Cancel any pending image data loading.
 *
 * @see wnc_setDatabase:
 */
- (void)wnc_cancel;

@end
