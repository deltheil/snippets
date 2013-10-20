//
//  ConsoleViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "ConsoleViewController.h"
#import "TextFiedConsole.h"

@interface ConsoleViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) TextFiedConsole *textFieldConsole;
@property (nonatomic, strong) UITextView *console;

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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
	
    // History
    self.history = [[NSMutableArray alloc] init];
    
    self.textFieldConsole = [[TextFiedConsole alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 40.0)];
    self.textFieldConsole.delegate = self;
    self.textFieldConsole.width = self.view.width - 101.0;
    self.textFieldConsole.left = 0.0;
    self.textFieldConsole.top = self.view.height - 216.0 - self.textFieldConsole.height;
    self.textFieldConsole.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    
    
    self.textFieldConsole.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldConsole.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:self.textFieldConsole];
    [self.textFieldConsole becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
