//
//  CommandViewController.m
//  Snippets
//
//  Created by James Heng on 09/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "CommandViewController.h"
#import "ConsoleViewController.h"
#import "Command.h"

@interface CommandViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CommandViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"redis-doc" ofType:@"html"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSString *tpl = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile]
                                          encoding:NSUTF8StringEncoding];
    
    NSString *html = [NSString stringWithFormat:tpl, _htmlDoc];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"consoleViewSegue"]) {
        ConsoleViewController *consoleVC = segue.destinationViewController;
        consoleVC.command = _command;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setCommand:(Command *)command
{
    _command = command;

    [self.titleLabel setText:[_command.name capitalizedString]];
}

- (void)setHtmlDoc:(NSString *)htmlDoc
{
    _htmlDoc = htmlDoc;
}

@end
