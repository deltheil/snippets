//
//  UIColor+Hex.h
//  evasion
//
//  Created by Aymeric Gallissot on 26/08/13.
//  Copyright (c) 2013 Fuzzze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
