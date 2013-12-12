//
//  UIBarButtonItem+Snippets.m
//  Snippets
//
//  Created by James Heng on 27/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "UIBarButtonItem+Snippets.h"
#import "UIColor+Snippets.h"

@implementation UIBarButtonItem (Snippets)

- (NSString *)sn_fontName
{
    return [self sn_fontName];
}

- (void)setSn_fontName:(NSString *)sn_fontName
{
    [self setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#d3392e" alpha:1],
                                   NSFontAttributeName : [UIFont fontWithName:sn_fontName size:14.5]
                                   }
                            forState:UIControlStateNormal];
}

@end
