//
//  ThemeTableViewController.m
//  Snippets
//
//  Created by James Heng on 10/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TopicListViewController.h"
#import "TopicViewController.h"
#import "TopicCell.h"

#import "WNCDatabase+Snippets.h"
#import "UIColor+Snippets.h"

@interface TopicListViewController ()

@property (strong, nonatomic) NSDictionary *topics;

@end

@implementation TopicListViewController

#pragma mark -Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _topics = @{@"Lua" : @"lua", @"Redis" : @"rds"};
    
    // TODO: sync in background if topic is already downloaded
    // TODO: manage errors properly

    // interactivePopGesture
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>) self;

    // set back arrow color
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#d3392e" alpha:1];
    
    // disable interactive pop gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"topicViewSegue"]) {
        UITableViewCell *cell = (UITableViewCell *) sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        NSArray *keys = [_topics allKeys];

        NSString *topic = [_topics objectForKey:keys[indexPath.row]];

        [_database sn_syncForTopic:topic resultBlock:nil progressBlock:nil error:nil];

        // TODO: if sync success, assign
        TopicViewController *topicVC = segue.destinationViewController;
        topicVC.topicName = keys[indexPath.row];
        topicVC.topic = topic;
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
    return [_topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"topicCellID";

    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.topic = _topics[indexPath.row];
    
    return cell;
}

@end
