//
//  CommandViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "CommandViewController.h"
#import "ConsoleViewController.h"

#import "RDSCommand.h"

@interface CommandViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CommandViewController

- (id)initWithCommand:(RDSCommand *)c
{
    self = [super init];
    if (self) {
        _command = c;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.navigationItem.leftBarButtonItem = [self buttonBack];
    self.navigationItem.rightBarButtonItem = [self buttonConsole];
    self.navigationItem.titleView = [self titleLogo];
    
    // WebView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, self.view.height - 76.0)];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    
    // Load the HTML template in memory
    NSString *path = [[NSBundle mainBundle] pathForResource:@"redis_cmd" ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *tpl = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    // Add the specific content
    NSString *html = [NSString stringWithFormat:tpl, [self getContent]];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
    // Try Code
    UIButton *buttonTry = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 270.0, 46.0)];
    buttonTry.top = self.webView.bottom + 15.0;
    buttonTry.left = floor((self.view.width - buttonTry.width) / 2 );
    [buttonTry setBackgroundImage:[UIImage imageNamed:@"try"] forState:UIControlStateNormal];
    [buttonTry addTarget:self action:@selector(tryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTry];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

// Emulate the local database get
- (NSString *)getContent
{
    return [self.command getHTMLString];
}

#pragma mark Try
- (void)tryAction{

    ConsoleViewController *consoleView = [[ConsoleViewController alloc] init];
    [self.navigationController pushViewController:consoleView animated:YES];
}


@end
