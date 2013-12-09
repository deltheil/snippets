//
//  CommandViewController.m
//  Snippets
//
//  Created by James Heng on 09/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "CommandViewController.h"

@interface CommandViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CommandViewController

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
