//
//  UIView+Position.h
//  evasion
//
//  Created by Aymeric Gallissot on 26/08/13.
//  Copyright (c) 2013 Fuzzze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign, readonly) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign, readonly) CGFloat bottom;

@end
