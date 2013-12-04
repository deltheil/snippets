//
//  UILabel+Snippets.m
//  Snippets
//
//  Created by James on 12/4/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "UILabel+Snippets.h"
#import "UIColor+Hex.h"

@implementation UILabel (Snippets)

- (NSString *)sn_fontName
{
    return self.font.fontName;
}

- (void)setSn_fontName:(NSString *)sn_fontName
{
    self.font = [UIFont fontWithName:sn_fontName size:self.font.pointSize];
}

- (NSString *)sn_hexColor
{
    return [self sn_hexColor];
}

- (void)setSn_hexColor:(NSString *)sn_hexColor
{
    [self setTextColor:[UIColor colorWithHexString:sn_hexColor alpha:1]];
}

@end
