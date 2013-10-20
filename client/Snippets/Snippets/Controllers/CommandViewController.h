//
//  CommandViewController.h
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "LNViewController.h"

@class RDSCommand;

@interface CommandViewController : LNViewController

@property RDSCommand *command;

- (id)initWithCommand:(RDSCommand *)c;

@end
