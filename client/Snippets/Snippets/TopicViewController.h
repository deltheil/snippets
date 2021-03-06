//
//  RedisViewController.h
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;
@class WNCDatabase;

@interface TopicViewController : UIViewController

@property (strong, nonatomic) WNCDatabase *database;

@property (strong, nonatomic) Topic *topic;

@end
