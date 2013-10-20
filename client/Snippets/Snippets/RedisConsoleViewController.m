//
//  RedisConsoleViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "RedisConsoleViewController.h"

#import "Redis.h" // our in memory engine
#import "NSError+Redis.h"

@interface RedisConsoleViewController () <UITextFieldDelegate>

@property (weak) IBOutlet UIWebView *webview;
@property (weak) IBOutlet UITextField *textfield;

@end

@implementation RedisConsoleViewController {
    Redis *_redis;
    NSMutableArray *_history; // use a Redis list instead?
    NSMutableArray *_entries;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _redis = [[Redis alloc] init];
        _history = [[NSMutableArray alloc] init];
        _entries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    // TODO: persist history into Winch!
    
    [_redis close];
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
    NSError *error;
    NSString *entry;
    NSString *cmd = textField.text;
    
    // Run the command
    NSString *resp = [_redis exec:cmd error:&error];
    if (!error) {
        entry = resp;
    }
    else {
        entry = [[error rds_message] stringByReplacingOccurrencesOfString:@"Vedis" withString:@"Redis"];
    }
    
    // Create the pair command + response / error
    [_entries addObject:[NSString stringWithFormat:@"<strong>redis> %@</strong>", cmd]];
    [_entries addObject:entry];

    // Recreate the full HTML with all entries
    NSString *html = [_entries componentsJoinedByString:@"<br/>"];
    
    [self.webview loadHTMLString:html baseURL:nil];
    
    // TODO: force the view to scroll down
    
    // Record the command into the history and clean up the prompt
    [_history addObject:cmd];
    textField.text = @"";
    
    return YES;
}

@end
