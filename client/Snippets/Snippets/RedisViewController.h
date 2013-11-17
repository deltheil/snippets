//
//  RedisViewController.h
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WNCDatabase;

@interface RedisViewController : UIViewController

@property (nonatomic, strong) WNCDatabase *database;

@end
