//
//  ConsoleViewController.m
//  Snippets
//
//  Created by James Heng on 09/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSMutableArray *entries;

@end

@implementation ConsoleViewController

#pragma mark - Life Cyle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _entries = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.textField becomeFirstResponder];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setHtmlHeader:(NSString *)htmlHeader
{
    _htmlHeader = htmlHeader;

}

#pragma mark - Actions

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
