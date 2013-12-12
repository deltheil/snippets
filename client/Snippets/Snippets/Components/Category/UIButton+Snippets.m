//
//  UIButton+Snippets.m
//  Snippets
//
//  Created by James Heng on 27/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "UIButton+Snippets.h"

#import "UIColor+Snippets.h"

@implementation UIButton (Snippets)

- (NSString *)sn_fontName
{
    return self.titleLabel.font.fontName;
}

- (void)setSn_fontName:(NSString *)sn_fontName
{
    self.titleLabel.font = [UIFont fontWithName:sn_fontName size:self.titleLabel.font.pointSize];
}

- (NSString *)sn_hexColor
{
    return [self sn_hexColor];
}

- (void)setSn_hexColor:(NSString *)sn_hexColor
{
    [self setTitleColor:[UIColor colorWithHexString:sn_hexColor alpha:1] forState:UIControlStateNormal];
}

@end
