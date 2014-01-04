//
//  SearchViewController.m
//  Snippets
//
//  Created by James on 12/21/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "SearchViewController.h"
#import "CommandViewController.h"

#import "WNCDatabase+Snippets.h"

#import "Topic.h"
#import "Command.h"
#import "CommandCell.h"

#define CELL_IDENTIFIER @"CommandCellID"

@interface SearchViewController ()

// UI properties
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Private properties
@property (strong, nonatomic) NSArray *commands;
@property (strong, nonatomic) NSArray *filteredCommands;

@end

@implementation SearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // display search bar in navigation bar
    [self.searchDisplayController setDisplaysSearchBarInNavigationBar:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set translucent to YES to support search display controller
    [self.navigationController.navigationBar setTranslucent:YES];
    
    // hide back button to navigation bar
    self.navigationItem.hidesBackButton = YES;
    
    // force display keyboard and focus to search bar
    [self.searchDisplayController.searchBar becomeFirstResponder];
    
    // register custom table view cell class to search results table view
    [[self.searchDisplayController searchResultsTableView] registerClass:[CommandCell class]
                                                  forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // set translucent to NO on will disappear for child view controllers
    [self.navigationController.navigationBar setTranslucent:NO];
}

#pragma mark - Private

- (NSArray *)commands
{
    if (_commands) {
        return _commands;
    }
    
    return [_database sn_fetchCommandsForTopic:_topic.uid error:nil];
}

#pragma mark - Actions

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.35;
    transition.type = kCATransitionFade;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([tableView isEqual:[self.searchDisplayController searchResultsTableView]]) ? [_filteredCommands count] : [self.commands count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommandCell *cell;
    
    if (tableView == [self.searchDisplayController searchResultsTableView]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    }
    else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    }

    NSInteger row = indexPath.row;
    
    Command *cmd = ([tableView isEqual:[self.searchDisplayController searchResultsTableView]])
                    ? _filteredCommands[row] : self.commands[row];
    
    cell.command = cmd;
    
    return cell;
}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self searchBarCancelButtonClicked:self.searchBar];
}


@end
