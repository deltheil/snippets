//
//  SearchViewController.h
//  Snippets
//
//  Created by James on 12/21/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WNCDatabase;
@class Topic;

@interface SearchViewController : UIViewController

@property (strong, nonatomic) WNCDatabase *database;
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) NSArray *commands;
@property (strong, nonatomic) NSString *currentGroup;

@end
