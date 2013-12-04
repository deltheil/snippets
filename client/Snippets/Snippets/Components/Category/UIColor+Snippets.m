//
//  UIColor+Hex.m
//  evasion
//
//  Created by Aymeric Gallissot on 26/08/13.
//  Copyright (c) 2013 Fuzzze. All rights reserved.
//

#import "UIColor+Snippets.h"

@implementation UIColor (Snippets)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha
{
    assert(7 == [hexString length]);
    assert('#' == [hexString characterAtIndex:0]);
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor colorWithRed:(redInt/255.0) green:(greenInt/255.0) blue:(blueInt/255.0) alpha:alpha];
}

@end
