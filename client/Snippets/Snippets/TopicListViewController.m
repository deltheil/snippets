//
//  ThemeTableViewController.m
//  Snippets
//
//  Created by James Heng on 10/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TopicListViewController.h"
#import "RedisViewController.h"
#import "TopicCell.h"

@interface TopicListViewController ()

@property (strong, nonatomic) NSMutableArray *themes;

@end

@implementation TopicListViewController

#pragma mark -Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _themes = [[NSMutableArray alloc] initWithArray:@[@"Redis", @"Lua"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"topicViewController"]) {
        
        UITableViewCell *cell = (UITableViewCell *) sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        NSString *topic = _themes[indexPath.row];
        
        RedisViewController *topicVC = segue.destinationViewController;
        topicVC.topicName = topic;
        topicVC.database = _database;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_themes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"topicCellID";

    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.topic = _themes[indexPath.row];
    
    return cell;
}

@end
