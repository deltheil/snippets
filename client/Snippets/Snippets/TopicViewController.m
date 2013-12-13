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
#import "Group.h"
#import "GroupCell.h"
#import "Command.h"
#import "CommandCell.h"

#define GROUP_CELL_WIDTH 90

@interface TopicViewController ()

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *groupsCollectionView;
@property (nonatomic, weak) IBOutlet UITableView *commandsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

// Private properties
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) Group *currentGroup;

@property (nonatomic) double lastScrollPosX;

@end

@implementation TopicViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // enable interactive pop gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"commandViewSegue"]) {
        UITableViewCell *cell = (UITableViewCell *) sender;
        
        NSIndexPath *indexPath = [self.commandsTableView indexPathForCell:cell];
        
        Command *cmd = self.commands[indexPath.row];

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
}

- (void)updateScrollViewOffset
{
    float toX = self.groupsCollectionView.contentOffset.x;
    
    float modulo = toX - (int) (toX / GROUP_CELL_WIDTH) * GROUP_CELL_WIDTH;
    
    if (modulo != 0) {
        toX -= fabs(modulo);
        if (self.groupsCollectionView.contentOffset.x - _lastScrollPosX > 0) {
            toX += GROUP_CELL_WIDTH;
        }
    }
    
    toX = fmax(toX, 0);
    toX = fmin(toX, self.groupsCollectionView.contentSize.width - GROUP_CELL_WIDTH);
    
    [UIView animateWithDuration:.15 delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.groupsCollectionView.contentOffset = CGPointMake(toX, self.groupsCollectionView.contentOffset.y);
                     }
                     completion:^(BOOL finished) {
                         _lastScrollPosX = self.groupsCollectionView.contentOffset.x;
                     }];
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.groups count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Group *group = [self.groups objectAtIndex:indexPath.row];
    
    GroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicGroupCellID" forIndexPath:indexPath];
    cell.groupName = group.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    self.currentGroup = [self.groups objectAtIndex:row];
    
    // set table view offset when group has been selected
    // and table view has been scrolled before
    [self.commandsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    // scroll to select item to avoid a cut visible rect
    GroupCell *groupCell = (GroupCell *) [collectionView cellForItemAtIndexPath:indexPath];

    [self.groupsCollectionView scrollRectToVisible:groupCell.frame animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.groupsCollectionView) {
        scrollView.contentOffset = scrollView.contentOffset;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.groupsCollectionView) {
        if (!decelerate) {
            [self updateScrollViewOffset];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.groupsCollectionView) {
        [self updateScrollViewOffset];
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
    
    Command *cmd = self.commands[indexPath.row];
    cell.command = cmd;
    
    return cell;
}

@end
