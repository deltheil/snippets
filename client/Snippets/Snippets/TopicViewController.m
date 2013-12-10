//
//  RedisViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TopicViewController.h"
#import "CommandViewController.h"
#import "ConsoleViewController.h"

#import <Winch/Winch.h>

#import "WNCDatabase+Redis.h"

#import "RDSGroup.h"
#import "RDSGroupCell.h"
#import "RDSCommand.h"
#import "RDSCommandCell.h"

#define GROUP_CELL_WIDTH 90

@interface TopicViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *groupsCollectionView;
@property (nonatomic, weak) IBOutlet UITableView *commandsTableView;

// Private properties
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) RDSGroup *currentGroup;

@end

@implementation TopicViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // calling sync method to test with data
    // TODO: sync in background when not at cold start
    // TODO: manage errors properly
    [_database rds_syncWithBlock:nil
                   progressBlock:nil
                           error:nil];
        
    // disable interactive pop gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"commandViewSegue"]) {
        
        UIButton *button = (UIButton *) sender;
        
        UITableViewCell *cell = nil;
        
        // Getting tableViewCell from button
        
        for (id view = [button superview]; view != nil; view = [view superview]) {
            if ([view isKindOfClass:[UITableViewCell class]]) {
                cell = (UITableViewCell *) view;
                break;
            }
        }

        NSIndexPath *indexPath = [self.commandsTableView indexPathForCell:cell];
        
        RDSCommand *cmd = self.commands[indexPath.row];

        NSString *htmlDoc = [_database rds_getHTMLForCommand:cmd];

        CommandViewController *cmdVC = segue.destinationViewController;
        cmdVC.command = cmd;
        cmdVC.htmlDoc = htmlDoc;
        cmdVC.topicName = _topicName;
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

- (NSArray *)groups
{
    if (_groups) {
        return _groups;
    }
    
    _groups = [_database rds_fetchGroups:nil];
    
    return _groups;
}

- (NSArray *)commands
{
    if (_commands) {
        return _commands;
    }
    
    NSMutableArray *cmds = [NSMutableArray arrayWithArray:[_database rds_fetchCommands:nil]];
    
    if (_currentGroup) {
        [cmds filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *_) {
            RDSCommand *cmd = (RDSCommand *) obj;
            return [_currentGroup.cmds containsObject:cmd.uid];
        }]];
    }
    
    _commands = [NSArray arrayWithArray:cmds];
    
    return _commands;
}

- (void)setCurrentGroup:(RDSGroup *)currentGroup
{
    NSString *prev = _currentGroup ? _currentGroup.name : @"<void>";
    NSString *next = currentGroup ? currentGroup.name : @"<void>";
    
    if ([prev isEqualToString:next]) {
        return;
    }
    
    _currentGroup = currentGroup;
    
    self.commands = nil;
    
    [self.commandsTableView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.groups count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RDSGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    RDSGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicGroupCellID" forIndexPath:indexPath];
    cell.groupName = group.name;
    
    // TODO: at the app launch set the red underline view to the first row "ALL"

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    self.currentGroup = [self.groups objectAtIndex:row];

    // TODO: overflow has to be rethink for the scroll view [1]
    // [1] [collectionView setContentOffset:CGPointMake((row * GROUP_CELL_WIDTH), 0) animated:YES];
    
    // set table view offset when group has been selected
    // and table view has been scrolled before
    [self.commandsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.groupsCollectionView) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - scrollView.contentInset.left;
        scrollView.contentOffset = contentOffset;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.groupsCollectionView) {
        NSInteger position = (NSInteger) floor(scrollView.contentOffset.x / GROUP_CELL_WIDTH);
        [scrollView setContentOffset:CGPointMake((position * GROUP_CELL_WIDTH), 0) animated:YES];
    }
}

#pragma mark - UITableViewDataSource

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
    static NSString *cellIdentifier = @"topicCommandCellID";
    
    RDSCommandCell *cell = (RDSCommandCell *) [_commandsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RDSCommandCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    }
    
    RDSCommand *cmd = self.commands[indexPath.row];
    cell.command = cmd;
    
    return cell;
}

@end
