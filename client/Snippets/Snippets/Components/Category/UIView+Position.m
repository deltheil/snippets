//
//  UIView+Position.m
//  evasion
//
//  Created by Aymeric Gallissot on 26/08/13.
//  Copyright (c) 2013 Fuzzze. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

@end
