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

#import "WNCDatabase+Snippets.h"

#import "Topic.h"
#import "RDSGroup.h"
#import "RDSGroupCell.h"
#import "RDSCommand.h"
#import "CommandCell.h"

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
    
    // disable interactive pop gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"commandViewSegue"]) {
        UITableViewCell *cell = (UITableViewCell *) sender;
        
        NSIndexPath *indexPath = [self.commandsTableView indexPathForCell:cell];
        
        RDSCommand *cmd = self.commands[indexPath.row];

        NSString *htmlDoc = [_database sn_getHTMLForCommand:cmd forTopic:_topic.uid];

        CommandViewController *cmdVC = segue.destinationViewController;
        cmdVC.command = cmd;
        cmdVC.htmlDoc = htmlDoc;
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
    
    CommandCell *cell = (CommandCell *) [_commandsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CommandCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    }
    
    RDSCommand *cmd = self.commands[indexPath.row];
    cell.command = cmd;
    
    return cell;
}

@end
