//
//  RedisViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TopicViewController.h"
#import "CommandViewController.h"
#import "SearchViewController.h"

#import <Winch/Winch.h>

#import "WNCDatabase+Snippets.h"
#import "UITableView+Snippets.h"
#import "UIColor+Snippets.h"

#import "Topic.h"
#import "Group.h"
#import "Command.h"

#import "CommandCell.h"

#define GROUP_CELL_WIDTH 160
#define GROUP_CELL_HEIGHT 44

#define CELL_IDENTIFIER @"CommandCellID"

#define GRAY_COLOR [UIColor colorWithHexString:@"#f2f2f2" alpha:1]

@interface TopicViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *groupPickerView;
@property (nonatomic, weak) IBOutlet UITableView *commandsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

// Private properties
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) Group *currentGroup;

@end

@implementation TopicViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // enable interactive pop gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // set gray background color
    [self.groupPickerView setBackgroundColor:GRAY_COLOR];
    
    // We cannot customize our own picker view selection indicator since ios7 ( cf: http://goo.gl/KjxaXd )
    // We choose to hide these two selection lines by adding subviews to the controller view
    // with the same background color than the picker view.
    // By doing this, we will create a clear color effect on built-in selection indicators and avoid their appearance
    NSInteger offSetX = CGRectGetWidth(self.view.frame) / 2;
    
    // add left selection indicator line
    UIView *lIndicatorLine = [[UIView alloc] init];
    lIndicatorLine.frame = CGRectMake(offSetX - 45, 0, 1, GROUP_CELL_HEIGHT);
    lIndicatorLine.backgroundColor = GRAY_COLOR;
    
    [self.view addSubview:lIndicatorLine];

    // add right selection indicator line
    UIView *rIndicatorLine = [[UIView alloc] init];
    rIndicatorLine.frame = CGRectMake(offSetX + 48, 0, 1, GROUP_CELL_HEIGHT);
    rIndicatorLine.backgroundColor = GRAY_COLOR;
    
    [self.view addSubview:rIndicatorLine];

    // add bottom selection indicator line
    UIView *bIndicatorLine = [[UIView alloc] init];
    bIndicatorLine.frame = CGRectMake(offSetX - 40, GROUP_CELL_HEIGHT - 1, 84, 2);
    bIndicatorLine.backgroundColor = [UIColor colorWithHexString:@"#f16353" alpha:1];

    [self.view addSubview:bIndicatorLine];
    
    // transform pickerView to be horizontal
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14 / 2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [self.groupPickerView setTransform:rotate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CommandVCSegue"]) {
        UITableViewCell *cell = (UITableViewCell *) sender;
        
        NSIndexPath *indexPath = [self.commandsTableView indexPathForCell:cell];
        
        Command *cmd = self.commands[indexPath.row];

        NSString *htmlDoc = [_database sn_getHTMLForCommand:cmd forTopic:_topic.uid];

        CommandViewController *cmdVC = segue.destinationViewController;
        cmdVC.command = cmd;
        cmdVC.htmlDoc = htmlDoc;
    }
    
    else if ([segue.identifier isEqualToString:@"SearchVCSegue"]) {
        SearchViewController *searchVC = segue.destinationViewController;
        searchVC.topic = _topic;
        searchVC.database = _database;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [self.titleLabel setText:_topic.name];
    [self.backButton setTitle:_topic.name];
}

- (NSArray *)groups
{
    if (_groups) {
        return _groups;
    }
    
    _groups = [_database sn_fetchGroupsForTopic:_topic.uid error:nil];
    
    return _groups;
}

- (NSArray *)commands
{
    if (_commands) {
        return _commands;
    }
    
    NSMutableArray *cmds = [NSMutableArray arrayWithArray:[_database sn_fetchCommandsForTopic:_topic.uid error:nil]];
    
    if (_currentGroup) {
        [cmds filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *_) {
            Command *cmd = (Command *) obj;
            return [_currentGroup.cmds containsObject:cmd.uid];
        }]];
    }
    
    _commands = [NSArray arrayWithArray:cmds];
    
    return _commands;
}

- (void)setCurrentGroup:(Group *)currentGroup
{
    NSString *prev = _currentGroup ? _currentGroup.name : @"<void>";
    NSString *next = currentGroup ? currentGroup.name : @"<void>";
    
    if ([prev isEqualToString:next]) {
        return;
    }
    
    _currentGroup = currentGroup;
    
    self.commands = nil;
    
    [self.commandsTableView reloadData];
    
    // table view popup animation
    [self.commandsTableView popUpVisibleCells];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component;
{
    return [self.groups count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return GROUP_CELL_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return GROUP_CELL_HEIGHT;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentGroup = [self.groups objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    Group *group = [self.groups objectAtIndex:row];
    
    // reusing view
    UILabel *label = (UILabel *) view;
    
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectZero];
        
        // customize title label
        [label setFont:[UIFont fontWithName:@"VAGRoundedStd-Light" size:26]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        // transform label to be horizontal
        CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14 / 2);
        rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
        [label setTransform:rotate];
    }
    
    [label setText:group.name];
    
    return label;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commands count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommandCell *cell = (CommandCell *) [_commandsTableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[CommandCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CELL_IDENTIFIER];
    }
    
    Command *cmd = self.commands[indexPath.row];
    cell.command = cmd;
    
    return cell;
}

@end
