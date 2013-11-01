//
//  CommandViewController.h
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "LNViewController.h"

@class RDSCommand;

@interface CommandViewController : LNViewController

@property RDSCommand *cmd;
@property NSString *htmlDoc;

- (id)initWithCommand:(RDSCommand *)cmd
        documentation:(NSString *)htmlDoc;

@end
