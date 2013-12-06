//
//  RDSCommandCell.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSCommandCell.h"

#import "RDSCommand.h"

@interface RDSCommandCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;

@end

@implementation RDSCommandCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setCommand:(RDSCommand *)command
{
    _command = command;
    
    self.nameLabel.text = command.name;
    self.summaryLabel.text = command.summary;
}

@end
