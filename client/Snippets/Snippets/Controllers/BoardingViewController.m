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

    UIButton *buttonGo = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.0)];
    buttonGo.left = floor((self.view.width - buttonGo.width) / 2 );
    buttonGo.top = 200.0;

    buttonGo.backgroundColor = [UIColor colorWithHexString:@"0BB5FF"];
    [buttonGo addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:buttonGo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)closeView{

    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self didMoveToParentViewController:nil];
}

@end
