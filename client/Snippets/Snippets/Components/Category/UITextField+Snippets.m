//
//  UITextField+Snippets.m
//  Snippets
//
//  Created by James Heng on 09/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "UITextField+Snippets.h"
#import "UIColor+Snippets.h"

@implementation UITextField (Snippets)

- (NSString *)sn_fontName
{
    return self.font.fontName;
}

- (void)setSn_fontName:(NSString *)sn_fontName
{
    self.font = [UIFont fontWithName:sn_fontName size:self.font.pointSize];
}

- (NSString *)sn_textHexColor
{
    return [self sn_textHexColor];
}

- (void)setSn_textHexColor:(NSString *)sn_textHexColor
{
    [self setTextColor:[UIColor colorWithHexString:sn_textHexColor alpha:1]];
}

- (NSString *)sn_placeHolderHexColor
{
    return [self sn_placeHolderHexColor];
}

- (void)setSn_placeHolderHexColor:(NSString *)sn_placeHolderHexColor
{
    [self setValue:[UIColor colorWithHexString:sn_placeHolderHexColor alpha:.2] forKeyPath:@"_placeholderLabel.textColor"];
}

@end
