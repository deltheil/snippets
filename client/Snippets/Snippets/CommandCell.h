//
//  RDSCommandCell.h
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Command;

@interface CommandCell : UITableViewCell

@property (nonatomic, strong) Command *command;

@end
