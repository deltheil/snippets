//
//  LNViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "LNViewController.h"

@interface LNViewController ()

@end

@implementation LNViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)buttonConsole{
    UIButton *buttonNow = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonNow addTarget:self action:@selector(consoleOpen) forControlEvents:UIControlEventTouchUpInside];
    //[buttonNow setBackgroundImage:[UIImage imageNamed:@"nav-more.png"] forState:UIControlStateNormal];
    [buttonNow setFrame:CGRectMake(5, 0, 44, 44)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [containerView addSubview:buttonNow];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

- (void)consoleOpen{
    
}

@end
