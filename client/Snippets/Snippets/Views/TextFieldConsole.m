//
//  TextFieldConsole.m
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TextFieldConsole.h"

@implementation TextFieldConsole

- (CGRect)textRectForBounds:(CGRect)bounds {
    int leftMargin = 18;
    int rigtMargin = 18;
    CGRect inset = CGRectMake(bounds.origin.x + leftMargin, bounds.origin.y, bounds.size.width - leftMargin - rigtMargin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int leftMargin = 18;
    int rigtMargin = 18;
    CGRect inset = CGRectMake(bounds.origin.x + leftMargin, bounds.origin.y, bounds.size.width - leftMargin - rigtMargin, bounds.size.height);
    return inset;
}

@end
