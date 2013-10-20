//
//  BoardingViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "BoardingViewController.h"

@interface BoardingViewController ()

@end

@implementation BoardingViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];

    self.view.backgroundColor = [UIColor colorWithHexString:@"ff9900"];

    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default-568h"]];
    [self.view addSubview:background];
    
    [self performSelector:@selector(closeView) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)closeView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self willMoveToParentViewController:nil];
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//    [self didMoveToParentViewController:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
