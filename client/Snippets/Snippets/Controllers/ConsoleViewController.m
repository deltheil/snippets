//
//  ConsoleViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "ConsoleViewController.h"
#import "TextFieldConsole.h"

#import "Redis.h" // our in memory engine
#import "NSError+Redis.h"

@interface ConsoleViewController () <UITextFieldDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSString *cli;
@property (nonatomic, strong) NSString *display;

@property (nonatomic, strong) TextFieldConsole *textFieldConsole;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *historyUp;
@property (nonatomic, strong) UIButton *historyDown;

@property (nonatomic) BOOL webViewEnable;

@end

@implementation ConsoleViewController {
    Redis *_redis;
    NSMutableArray *_history;
    NSMutableArray *_entries;
    NSInteger _currentIndex;
}

- (id)initWithCLI:(NSString *)cli AndDisplay:(NSString *)display
{
    self = [super init];
    if (self) {
        self.cli = cli;
        self.display = display;
        
        _redis = [[Redis alloc] init];
        _history = [[NSMutableArray alloc] init];
        _entries = [[NSMutableArray alloc] init];
        
        if (display != nil) {
            [_entries addObject:display];
        }
        
        _currentIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithHexString:@"212121"];
    
    // TextFieldConsole
    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"1f8d95"]];
    self.textFieldConsole = [[TextFieldConsole alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 50.0)];
    self.textFieldConsole.delegate = self;
    self.textFieldConsole.width = self.view.width - 101.0;
    self.textFieldConsole.left = 0.0;
    self.textFieldConsole.top = self.view.height - 216.0 - self.textFieldConsole.height;
    self.textFieldConsole.backgroundColor = [UIColor colorWithHexString:@"212121"];
    self.textFieldConsole.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldConsole.returnKeyType = UIReturnKeySend;
    self.textFieldConsole.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textFieldConsole.placeholder = @"Tap command";
    self.textFieldConsole.textColor = [UIColor colorWithHexString:@"999999"];
    [self.textFieldConsole setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:self.textFieldConsole];
    [self.textFieldConsole becomeFirstResponder];
    
    // TextFieldConsole Border
    UIView *textFiedConsoleBorderTop = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 2.0)];
    textFiedConsoleBorderTop.backgroundColor = [UIColor colorWithHexString:@"4d4d4d"];
    textFiedConsoleBorderTop.top = self.textFieldConsole.top - textFiedConsoleBorderTop.height;
    [self.view addSubview:textFiedConsoleBorderTop];
    
    // History Up
    self.historyUp = [self buttonHistory:[UIImage imageNamed:@"up"]];
    self.historyUp.top = self.textFieldConsole.top;
    self.historyUp.left = self.view.width - self.historyUp.width;
    [self.historyUp addTarget:self
                       action:@selector(historyBack:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.historyUp];
    
    // History Down
    self.historyDown = [self buttonHistory:[UIImage imageNamed:@"down"]];
    self.historyDown.top = self.textFieldConsole.top;
    self.historyDown.left = self.historyUp.left - self.historyDown.width;
    [self.historyDown addTarget:self
                         action:@selector(historyForward:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.historyDown];
    
    // Console
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.width, textFiedConsoleBorderTop.top - 20.0)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;

    // Button Close
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 27.0, 56.0, 23.0)];
    buttonClose.backgroundColor = [UIColor colorWithHexString:@"212121"];
    [buttonClose setImage:[UIImage imageNamed:@"nav-close"] forState:UIControlStateNormal];
    buttonClose.left = self.view.width - buttonClose.width - 16.0;
    [buttonClose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonClose];
    
    [self reloadEntries];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    if(!self.webViewEnable){
        self.webViewEnable = YES;
        [self.view insertSubview:self.webView atIndex:2];
    }
}

- (void)dealloc
{
    // TODO: persist history into Winch!
    [_redis close];
}

- (UIButton *)buttonHistory:(UIImage *)image
{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 51.0, 50.0)];
    button.backgroundColor = [UIColor clearColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 2.0, 0.0, 0.0);
    [button setImage:image forState:UIControlStateNormal];
    
    UIView *borderLeft = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2.0, button.height)];
    borderLeft.backgroundColor = [UIColor colorWithHexString:@"4d4d4d"];
    [button addSubview:borderLeft];
    
    return button;
}

- (void)historyBack:(UIButton *)sender
{
    if (_currentIndex == -1) {
        _currentIndex = [_history count] -1;
    }
    else {
        NSInteger idx = _currentIndex;
        if (idx > 0)
            _currentIndex = idx - 1;
    }
    
    NSLog(@" %d <- ", (int) _currentIndex);
    
    if (_currentIndex >= 0 && _currentIndex <= [_history count] -1) { // paranoid
        NSString *cmd = [_history objectAtIndex:_currentIndex];
        self.textFieldConsole.text = cmd;
    }
}

- (void)historyForward:(UIButton *)sender
{
    if (_currentIndex == -1) {
        _currentIndex = [_history count] -1;
    }
    else {
        NSInteger idx = _currentIndex;
        if (idx < [_history count] -1)
            _currentIndex = idx + 1;
    }
    
    NSLog(@" -> %d ", (int) _currentIndex);
    
    if (_currentIndex >= 0 && _currentIndex <= [_history count] -1) { // paranoid
        NSString *cmd = [_history objectAtIndex:_currentIndex];
        self.textFieldConsole.text = cmd;
    }
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
    
    // TODO: force the web view to scroll down
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSError *error;
    NSString *cmd = textField.text;
    
    // Run the command
    NSString *resp = [_redis exec:cmd error:&error];
    if (error) {
        resp = [[error rds_message] stringByReplacingOccurrencesOfString:@"Vedis" withString:@"Redis"];
    }
    
    // Create the pair command + response
    [_entries addObject:[NSString stringWithFormat:@"<div class='lg'>redis></div> %@", cmd]];
    [_entries addObject:resp];
    
    [self reloadEntries];
    
    // Record the command into the history and clean up the prompt
    [_history addObject:cmd];
    textField.text = @"";
    
    return NO;
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
