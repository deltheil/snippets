//
//  UITableView+Snippets.m
//  Snippets
//
//  Created by James Heng on 16/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "UITableView+Snippets.h"

#define CELL_ANIMATION_DURATION .4

@implementation UITableView (Snippets)

- (void)popUpVisibleCells
{
    // automatically scroll down to show first cell
    [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    // popup animation
    CGFloat timeOffset = 0;
    for (UIView* cell in [self visibleCells]) {
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
        anim.additive = YES;
        anim.fillMode = kCAFillModeBoth;
        anim.byValue = @(-self.bounds.size.height);
        anim.toValue = @0;
        anim.duration = CELL_ANIMATION_DURATION;
        anim.beginTime = CACurrentMediaTime() + timeOffset;
        anim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.240 :0.350 :0.555 :1.15];
        [cell.layer addAnimation:anim forKey:@"slide"];
        timeOffset+= .04;
    }
}

@end
