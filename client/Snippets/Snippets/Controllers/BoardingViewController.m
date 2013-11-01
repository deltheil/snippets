//
//  BoardingViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "BoardingViewController.h"

// Winch main header
#import <Winch/Winch.h>

#import "WNCDatabase+Redis.h"
#import "WNCDebug.h"

@interface BoardingViewController ()

@end

@implementation BoardingViewController

- (id)initWithDatabase:(WNCDatabase *)db
{
    self = [super init];
    if (self) {
        _database = db;
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
    
    void (^resultBlock)(id, NSError *) = ^(id _, NSError *error) {
        WNCDLog(@"%@", error ? [error wnc_message] : @"sync ok");
        [self closeView];
    };
    
    void (^progressBlock)(NSInteger) = ^(NSInteger percentDone) {
        WNCDLog(@"sync progress: %d%%", (int) percentDone);
    };
    
    // TODO: manage errors properly
    // TODO: sync in background when not at cold start
    [_database rds_syncWithBlock:resultBlock
                   progressBlock:progressBlock
                           error:nil];
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
