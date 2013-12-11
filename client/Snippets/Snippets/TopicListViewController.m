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

#import "Topic.h"

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

- (IBAction)chooseTopic:(id)sender
{

        NSString *topic = [_topics objectForKey:keys[indexPath.row]];

#pragma mark - Private

- (void)presentViewControllerForTopic:(Topic *)topic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TopicViewController  *topicVC = [storyboard instantiateViewControllerWithIdentifier:@"TopicViewController"];
    topicVC.topic = topic;
    topicVC.database = _database;
    
    [self.navigationController pushViewController:topicVC animated:YES];
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
