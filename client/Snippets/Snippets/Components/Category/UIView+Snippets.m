//
//  UIView+Snippets.m
//  Snippets
//
//  Created by James on 12/6/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "UIView+Snippets.h"
#import "UIColor+Snippets.h"

@implementation UIView (Snippets)

- (NSString *)sn_hexColor
{
    return [self sn_hexColor];
}

- (void)setSn_hexColor:(NSString *)sn_hexColor
{
    [self setBackgroundColor:[UIColor colorWithHexString:sn_hexColor alpha:1]];
}

@end
