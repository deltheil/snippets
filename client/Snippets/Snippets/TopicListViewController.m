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

@property (strong, nonatomic) NSArray *topics;
@property (nonatomic) NSIndexPath *selectedTopic;
@end

@implementation TopicListViewController

#pragma mark -Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // temporary for demo "redis"
    Topic *rds = [[Topic alloc] init];
    rds.uid = @"rds";
    rds.name = @"Redis";
    rds.description = @"Redis is an open source, BSD licensed, advanced key-value store..";
    
    _topics = [[NSArray alloc] initWithObjects:rds, nil];
    
    //  set an empty table view footer
    [self.tableView setTableFooterView:[UIView new]];

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
    UIButton *button = (UIButton *) sender;
    
    TopicCell *cell = nil;
    
    // Getting tableViewCell from button
    
    for (id view = [button superview]; view != nil; view = [view superview]) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            cell = (TopicCell *) view;
            break;
        }
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Topic *topic = _topics[indexPath.row];
    
    // cold start check
    if ([_database sn_countCommandsForTopicForTopic:topic.uid] > 0) {
        [self presentViewControllerForTopic:topic];

        // sync in background
        [_database sn_syncForTopic:topic.uid
                       resultBlock:nil
                     progressBlock:nil
                             error:nil];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^resultBlock)(NSArray *, NSError *) = ^(id _, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.tableView setUserInteractionEnabled:YES];
        
        if (error) {
            // keep selected topic to use for retry
            _selectedTopic = indexPath;
            // show alert view to handle retry action
            [self showAlertSyncError:error];
        }
        else {
            [self presentViewControllerForTopic:topic];
        }
    };

    void (^progressBlock)(NSInteger percentDone) = ^(NSInteger percentDone) {
        [cell setPercent:percentDone];
    };

    [_database sn_syncForTopic:topic.uid resultBlock:resultBlock progressBlock:progressBlock error:nil];
    
    [self.tableView setUserInteractionEnabled:NO];
}

#pragma mark - Private

- (void)showAlertSyncError:(NSError *)error
{
    NSString *message;
    
    switch ([error code]) {
        case WNCErrorNoConn:
            message = NSLocalizedString(@"INITIAL_SYNC_ERROR_MESSAGE_NETWORK", nil);
            break;
        case WNCErrorSlowConn:
        case WNCErrorTimeout:
            message = NSLocalizedString(@"INITIAL_SYNC_ERROR_MESSAGE_SLOW_NETWORK", nil);
            break;
        default:
            message = NSLocalizedString(@"INITIAL_SYNC_ERROR_MESSAGE", nil);
            break;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SYNC_ERROR", nil)
                                message:message
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"DONE", nil)
                      otherButtonTitles:NSLocalizedString(@"RETRY", nil), nil] show];
}

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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    
    // Retry
    TopicCell *cell = (TopicCell *) [self.tableView cellForRowAtIndexPath:_selectedTopic];
    // call choose topic IBAction
    [self chooseTopic:cell.chooseButton];
}

@end
