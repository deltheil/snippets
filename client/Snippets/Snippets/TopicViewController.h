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

@property (nonatomic, strong) WNCDatabase *database;

@property (nonatomic, strong) Topic *topic;

@end
