//
//  CommandViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "CommandViewController.h"

@interface CommandViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CommandViewController

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
	
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Emulate the local database get
- (NSString *)getContent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"append" ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    return [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

@end
