//
//  ConsoleViewController.m
//  Snippets
//
//  Created by James Heng on 09/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "ConsoleViewController.h"
#import "Redis.h"

#import "NSError+Redis.h"

#define REDIS_PROMPT @"<div class='lg'>redis></div> %@"

#define REDIS_CMD(_CMD) \
[NSString stringWithFormat:REDIS_PROMPT, (_CMD)]

@interface ConsoleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) Redis *redis;

@end

@implementation ConsoleViewController

#pragma mark - Life Cyle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _entries = [[NSMutableArray alloc] init];
    _redis = [[Redis alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//  [self.textField becomeFirstResponder];
    [self reloadEntries];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [_redis close];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setHtmlHeader:(NSString *)htmlHeader
{
    _htmlHeader = htmlHeader;

    [_entries addObject:htmlHeader];
}

- (void)reloadEntries
{
    // Load the HTML template in memory
    NSString *path = [[NSBundle mainBundle] pathForResource:@"redis-cli" ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *tpl = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];

    // Recreate the full HTML with all entries
    NSString *content = [_entries componentsJoinedByString:@"<br/>"];
    NSString *html = [NSString stringWithFormat:tpl, content];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

#pragma mark - Actions

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSError *error;
    NSString *cmd = [textField.text uppercaseString];
    
    // Run the command
    NSString *resp = [_redis exec:cmd error:&error];
    if (error) {
        resp = [[error rds_message] stringByReplacingOccurrencesOfString:@"Vedis" withString:@"Redis"];
    }
    
    // Create the pair command + response
    [_entries addObject:REDIS_CMD(cmd)];
    [_entries addObject:resp];
    
    [self reloadEntries];
    
    textField.text = @"";
    
    return NO;
}

#pragma mark - Notifications

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    UIViewAnimationCurve curve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    CGRect endFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    endFrame = [self.view convertRect:endFrame fromView:nil];

    float height = self.inputContainerView.frame.size.height;
    float y = (endFrame.origin.y > self.view.frame.size.height) ? self.view.frame.size.height : endFrame.origin.y - height;

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:(UIViewAnimationOptions)curve
                     animations:^{
                         CGRect textFieldFrame = self.inputContainerView.frame;
                         textFieldFrame.origin.y = y;
                         self.inputContainerView.frame = textFieldFrame;
                     }
                     completion:nil];
}

@end
