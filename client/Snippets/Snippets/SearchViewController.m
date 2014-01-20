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

#define WHITE_COLOR     [UIColor whiteColor]

@interface SearchViewController ()

// UI properties
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (strong, nonatomic) IBOutlet UIView *blackSearchView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;

// Private properties
@property (strong, nonatomic) UITapGestureRecognizer *hideKeyboardGesture;
@property (strong, nonatomic) NSArray *filteredCommands;
@property (assign) bool isFiltering;

@end

@implementation SearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    [searchField setTextColor:WHITE_COLOR];
    [searchField setTintColor:WHITE_COLOR];
    [searchField setAdjustsFontSizeToFitWidth:YES];
    [searchField setFont:[UIFont fontWithName:@"Aleo-Regular" size:14]];
    [searchField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setLeftViewMode:UITextFieldViewModeNever];

    [self.searchBar setImage:[UIImage imageNamed:@"sn_cross_off"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"sn_cross_on"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];

    [searchField setPlaceholder:[NSString stringWithFormat:@"Search a command in \"%@\"", _currentGroup]];
    
    // add a tap gesture to dismiss keyboard when searching
    self.hideKeyboardGesture = [[UITapGestureRecognizer alloc]
                                initWithTarget:self
                                action:@selector(dismissKeyboard)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // hide back button to navigation bar
    [self.navigationItem setHidesBackButton:YES];

    // set custom search cancel button
    self.navigationItem.rightBarButtonItem = self.cancelBarButton;

    // set an empty origin table view footer
    [self.tableView setTableFooterView:[UIView new]];

    // display search bar in navigation bar
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // force display keyboard
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // remove search bar from navigation bar
    [self.searchBar removeFromSuperview];
    // force hide keyboard
    [self.searchBar resignFirstResponder];
}

#pragma mark - IBActions

- (void)dismissKeyboard
{
    if (!_isFiltering || !self.noResultView.hidden) {
        [self searchBarCancelButtonClicked:self.cancelBarButton];
        return;
    }
    
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    [self.view removeGestureRecognizer:self.hideKeyboardGesture];
}

- (IBAction)searchBarCancelButtonClicked:(id)sender
{
    _isFiltering = NO;
    
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
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
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
    return (_isFiltering) ? [_filteredCommands count] : [self.commands count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommandCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    
    Command *cmd = (_isFiltering) ? _filteredCommands[row] : self.commands[row];
    
    cell.command = cmd;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view addGestureRecognizer:self.hideKeyboardGesture];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        _isFiltering = NO;

        self.noResultView.hidden = YES;

        self.blackSearchView.hidden = NO;
    }
    else {
        _isFiltering = YES;
        
        NSPredicate *filterMerchant = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
        
        _filteredCommands = [self.commands filteredArrayUsingPredicate:filterMerchant];

        self.noResultView.hidden = !([_filteredCommands count] < 1);

        self.blackSearchView.hidden = YES;
    }
    
    [self.tableView reloadData];
}

@end
