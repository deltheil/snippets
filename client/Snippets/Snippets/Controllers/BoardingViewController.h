//
//  BoardingViewController.h
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "LNViewController.h"

@class WNCDatabase;

@interface BoardingViewController : LNViewController

@property WNCDatabase *database;

- (id)initWithDatabase:(WNCDatabase *)db;

@end
