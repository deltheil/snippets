//
//  RedisCmdViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "RedisCmdViewController.h"

@interface RedisCmdViewController ()

@property (weak) IBOutlet UIWebView *webview;

@end

@implementation RedisCmdViewController

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
    
    // Load the HTML template in memory
    NSString *path = [[NSBundle mainBundle] pathForResource:@"redis_cmd" ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *tpl = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile]
                                          encoding:NSUTF8StringEncoding];
    
    // Add the specific content
    NSString *html = [NSString stringWithFormat:tpl, [self getContent]];
    
    [self.webview loadHTMLString:html baseURL:nil];
}

// Emulate the local database get
- (NSString *)getContent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"append" ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    return [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile]
                                 encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
