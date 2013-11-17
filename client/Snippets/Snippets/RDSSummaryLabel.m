//
//  RDSSummaryLabel.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSSummaryLabel.h"

@implementation RDSSummaryLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont fontWithName:@"VAGRoundedStd-Light" size:12.0];
        self.textColor = [UIColor colorWithHexString:@"006269"];
    }
    return self;
}

@end
