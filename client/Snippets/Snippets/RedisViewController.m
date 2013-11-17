//
//  RedisViewController.m
//  Snippets
//
//  Created by Cédric Deltheil on 17/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RedisViewController.h"

#import <Winch/Winch.h>

#import "WNCDatabase+Redis.h"
#import "RDSGroup.h"
#import "RDSCommand.h"
#import "RDSCommandCell.h"

@interface RedisViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *menuView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) RDSGroup *currentGroup;

@end

@implementation RedisViewController

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
	// Do any additional setup after loading the view.
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
