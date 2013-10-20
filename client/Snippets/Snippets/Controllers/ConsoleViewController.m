//
//  ConsoleViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "ConsoleViewController.h"
#import "TextFieldConsole.h"

#import "Redis.h" // our in memory engine
#import "NSError+Redis.h"

@interface ConsoleViewController () <UITextFieldDelegate, UIWebViewDelegate>


@property (nonatomic, strong) TextFieldConsole *textFieldConsole;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *historyUp;
@property (nonatomic, strong) UIButton *historyDown;

@property (nonatomic, strong) Redis *redis;
@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) NSMutableArray *entries;

@end

@implementation ConsoleViewController

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
    
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    
    _redis = [[Redis alloc] init];
    _history = [[NSMutableArray alloc] init];
    _entries = [[NSMutableArray alloc] init];
    
    // TextFieldConsole
    self.textFieldConsole = [[TextFieldConsole alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 50.0)];
    self.textFieldConsole.delegate = self;
    self.textFieldConsole.width = self.view.width - 101.0;
    self.textFieldConsole.left = 0.0;
    self.textFieldConsole.top = self.view.height - 216.0 - self.textFieldConsole.height;
    self.textFieldConsole.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    self.textFieldConsole.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldConsole.returnKeyType = UIReturnKeySend;
    self.textFieldConsole.placeholder = @"Tap command";
    [self.view addSubview:self.textFieldConsole];
    [self.textFieldConsole becomeFirstResponder];
    
    // TextFieldConsole Border
    UIView *textFiedConsoleBorderTop = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 2.0)];
    textFiedConsoleBorderTop.backgroundColor = [UIColor colorWithHexString:@"dadbdf"];
    textFiedConsoleBorderTop.top = self.textFieldConsole.top - textFiedConsoleBorderTop.height;
    [self.view addSubview:textFiedConsoleBorderTop];
    
    // History Up
    self.historyUp = [self buttonHistory:[UIImage imageNamed:@"up"]];
    self.historyUp.top = self.textFieldConsole.top;
    self.historyUp.left = self.view.width - self.historyUp.width;
    [self.view addSubview:self.historyUp];
    
    // History Down
    self.historyDown = [self buttonHistory:[UIImage imageNamed:@"down"]];
    self.historyDown.top = self.textFieldConsole.top;
    self.historyDown.left = self.historyUp.left - self.historyDown.width;
    [self.view addSubview:self.historyDown];
    
    // Console
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.width, textFiedConsoleBorderTop.top - 20.0)];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;

    
    // Button Close
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 40.0, 56.0, 23.0)];
    [buttonClose setBackgroundImage:[UIImage imageNamed:@"nav-close"] forState:UIControlStateNormal];
    buttonClose.left = self.view.width - buttonClose.width - 20.0;
    [buttonClose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonClose];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // TODO: persist history into Winch!
    
    [_redis close];
}

- (UIButton *)buttonHistory:(UIImage *)image{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 51.0, 50.0)];
    button.backgroundColor = [UIColor clearColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 2.0, 0.0, 0.0);
    [button setImage:image forState:UIControlStateNormal];
    
    UIView *borderLeft = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2.0, button.height)];
    borderLeft.backgroundColor = [UIColor colorWithHexString:@"dadbdf"];
    [button addSubview:borderLeft];
    
    return button;
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
    
    // Load the HTML template in memory
    NSString *path = [[NSBundle mainBundle] pathForResource:@"console" ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *tpl = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    // Create the pair command + response / error
    [_entries addObject:[NSString stringWithFormat:@"<div class='lg'>redis></div> %@", cmd]];
    [_entries addObject:entry];
    
    // Recreate the full HTML with all entries
    NSString *htmlContent = [_entries componentsJoinedByString:@"<br/></div>"];
    
    NSString *html = [NSString stringWithFormat:tpl, htmlContent];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
    // TODO: force the view to scroll down
    
    // Record the command into the history and clean up the prompt
    [_history addObject:cmd];
    textField.text = @"";
    
    // Automatic Scroll
    // float consoleHeight = self.webView.scrollView.contentSize.height - 280.0;
    // NSLog(@"----- %f", consoleHeight);
    // [self.webView.scrollView setContentOffset:CGPointMake(0.0, consoleHeight) animated:YES];
    
    return YES;
}

- (void)closeAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
