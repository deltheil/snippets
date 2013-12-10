//
//  CommandViewController.m
//  Snippets
//
//  Created by James Heng on 09/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "CommandViewController.h"
#import "ConsoleViewController.h"
#import "RDSCommand.h"

@interface CommandViewController ()

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
        consoleVC.htmlHeader = [_command htmlHeader];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setTopicName:(NSString *)topicName
{
    _topicName = topicName;
    
    [self.titleLabel setText:topicName];
}

- (void)setCommand:(RDSCommand *)command
{
    _command = command;
}

- (void)setHtmlDoc:(NSString *)htmlDoc
{
    _htmlDoc = htmlDoc;
}

@end
