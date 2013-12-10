//
//  RedisViewController.h
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WNCDatabase;

@interface TopicViewController : UIViewController

@property (nonatomic, strong) WNCDatabase *database;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topic;
@end
