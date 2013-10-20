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
    [buttonNow setBackgroundImage:[UIImage imageNamed:@"nav-console"] forState:UIControlStateNormal];
    [buttonNow setFrame:CGRectMake(0, 0, 30, 30)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [containerView addSubview:buttonNow];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

- (UIBarButtonItem *)buttonBack{
    UIButton *buttonNow = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonNow addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [buttonNow setBackgroundImage:[UIImage imageNamed:@"nav-back.png"] forState:UIControlStateNormal];
    [buttonNow setFrame:CGRectMake(0, 0, 66, 30)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 66, 30)];
    [containerView addSubview:buttonNow];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

- (UIImageView *)titleLogo{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-logo"]];
    
    return logo;
}

- (void)actionBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)consoleOpen{
    
}

@end
