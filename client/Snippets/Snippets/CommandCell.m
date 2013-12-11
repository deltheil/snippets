//
//  RDSCommandCell.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "CommandCell.h"

#import "Command.h"

@interface CommandCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;

@end

@implementation CommandCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setCommand:(Command *)command
{
    _command = command;
    
    self.nameLabel.text = command.name;
    self.summaryLabel.text = command.summary;
}

@end
