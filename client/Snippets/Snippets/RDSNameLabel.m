//
//  RDSNameLabel.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSNameLabel.h"

@implementation RDSNameLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont fontWithName:@"Aleo-Regular" size:13.0];
        self.textColor = [UIColor colorWithHexString:@"d3392e"];
    }
    return self;
}

@end
