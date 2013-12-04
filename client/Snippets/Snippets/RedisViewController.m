//
//  RedisViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RedisViewController.h"

#import <Winch/Winch.h>

#import "RDSGroup.h"
#import "RDSCommand.h"
#import "RDSCommandCell.h"
#import "WNCDatabase+Redis.h"

@interface RedisViewController ()

// UI properties
@property (nonatomic, weak) IBOutlet UIScrollView *menuView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// Private properties
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) RDSGroup *currentGroup;

@end

@implementation RedisViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

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
    [self.tableView reloadData];
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"redisCommandCellID";
    
    RDSCommandCell *cell = (RDSCommandCell *) [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RDSCommandCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    }
    
    RDSCommand *cmd = self.commands[indexPath.row];
    cell.command = cmd;
    
    return cell;
}

@end
