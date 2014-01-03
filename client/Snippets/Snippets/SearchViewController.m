//
//  SearchViewController.m
//  Snippets
//
//  Created by James on 12/21/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "SearchViewController.h"
#import "Command.h"
#import "CommandCell.h"

#define CELL_IDENTIFIER @"topicCommandCellID"

@interface SearchViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

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
    
    // hide back button to navigation bar
    self.navigationItem.hidesBackButton = YES;
    
    // force display keyboard and focus to search bar
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Private

- (void)setCommands:(NSArray *)commands
{
    _commands = commands;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commands count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommandCell *cell = (CommandCell *) [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];

    if (!cell) {
        cell = [[CommandCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CELL_IDENTIFIER];
    }

    Command *cmd = _commands[indexPath.row];
    cell.command = cmd;
    
    return cell;
}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchDisplayController.searchResultsTableView registerClass:[CommandCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
}


@end
