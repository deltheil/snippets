//
//  RedisConsoleViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "RedisConsoleViewController.h"

@interface RedisConsoleViewController () <UITextFieldDelegate>

@property (weak) IBOutlet UIWebView *webview;
@property (weak) IBOutlet UITextField *textfield;

@end

@implementation RedisConsoleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.textfield becomeFirstResponder];
    [self.textfield setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textfield setClearButtonMode:UITextFieldViewModeAlways];
    [self.textfield setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Redis command -> %@ ", textField.text);
    textField.text = @"";
    return YES;
}

@end
