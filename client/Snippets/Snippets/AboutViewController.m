//
//  AboutViewController.m
//  Snippets
//
//  Created by James Heng on 11/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@end

@implementation AboutViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set font programmatically because UITextView category does not work yet
    [self.descriptionTextView setFont:[UIFont fontWithName:@"VAGRoundedStd-Light" size:17]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openWinchUrl:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.winch.io"]];
}

#pragma mark - Actions

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
