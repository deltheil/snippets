//
//  RDSGroupCell.m
//  Snippets
//
//  Created by James on 12/6/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [self.underlineView setHidden:!selected];
}

- (void)setGroupName:(NSString *)groupName
{
    _groupName = groupName;
    
    [self.groupLabel setText:_groupName];
}

@end
