//
//  CustomSegue.m
//  Snippets
//
//  Created by James on 12/21/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "FadeAnimationPushSegue.h"

@implementation FadeAnimationPushSegue

- (void)perform
{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;

    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.35;
    transition.type = kCATransitionFade;
    
    [src.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [src.navigationController pushViewController:dst animated:NO];
}

@end
