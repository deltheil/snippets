//
//  SearchViewController.m
//  Snippets
//
//  Created by James on 12/21/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "SearchViewController.h"
#import "CommandViewController.h"

#import "UIColor+Snippets.h"

#import "WNCDatabase+Snippets.h"

#import "Topic.h"
#import "Command.h"

#import "CommandCell.h"

#define CELL_IDENTIFIER @"CommandCellID"

#define RED_COLOR [UIColor whiteColor]
//[UIColor colorWithHexString:@"#f16353" alpha:1]

@interface SearchViewController ()

// UI properties
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Private properties
@property (strong, nonatomic) NSArray *filteredCommands;

@end

@implementation SearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // display search bar in navigation bar
    [self.searchDisplayController setDisplaysSearchBarInNavigationBar:YES];

    // set UI customization
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    [searchField setTextColor:RED_COLOR];
    [searchField setTintColor:RED_COLOR];
    [searchField setAdjustsFontSizeToFitWidth:YES];
    [searchField setFont:[UIFont fontWithName:@"Aleo-Regular" size:14]];
    [searchField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setLeftViewMode:UITextFieldViewModeNever];

    // search bar UI customization
    [self.searchBar setImage:[UIImage imageNamed:@"sn_cross_off"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"sn_cross_on"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];


    // set placeholder text
    [searchField setPlaceholder:[NSString stringWithFormat:@"Search a command in \"%@\"", _currentGroup]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set translucent to YES to support search display controller
    [self.navigationController.navigationBar setTranslucent:YES];
    
    // hide back button to navigation bar
    self.navigationItem.hidesBackButton = YES;

    // set an empty origin table view footer
    [self.tableView setTableFooterView:[UIView new]];
    
    // set an empty search results table view footer
    [[self.searchDisplayController searchResultsTableView] setTableFooterView:[UIView new]];

    // register custom table view cell class to search results table view
    [[self.searchDisplayController searchResultsTableView] registerClass:[CommandCell class]
                                                  forCellReuseIdentifier:CELL_IDENTIFIER];

    
    // force display keyboard and focus to search bar
    // if search bar is not active to avoid an ugly animation on pop vc
    // with gesture from command doc vc
    if (![self.searchDisplayController isActive])
        [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // set translucent to NO on will disappear for child view controllers
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // force hide keyboard
    [self.searchDisplayController.searchBar resignFirstResponder];
}

#pragma mark - IBActions

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.35;
    transition.type = kCATransitionFade;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CommandVCSegue"]) {
        UITableViewCell *cell = (UITableViewCell *) sender;
        
        NSIndexPath *indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForCell:cell];
        
        Command *cmd = _filteredCommands[indexPath.row];
        
        NSString *htmlDoc = [_database sn_getHTMLForCommand:cmd forTopic:_topic.uid];
        
        CommandViewController *cmdVC = segue.destinationViewController;
        cmdVC.command = cmd;
        cmdVC.htmlDoc = htmlDoc;
    }
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

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *filterMerchant = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
    
    _filteredCommands = [self.commands filteredArrayUsingPredicate:filterMerchant];
    
    return YES;
}

@end
