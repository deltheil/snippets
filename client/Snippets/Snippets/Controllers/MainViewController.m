//
//  MainViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "MainViewController.h"
#import "CommandViewController.h"
#import "ConsoleViewController.h"

#import <Winch/Winch.h>

#import "WNCDatabase+Redis.h"

// Data model
#import "RDSCommand.h"
#import "RDSGroup.h"

@interface MainViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *sorting;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cmds;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MainViewController

- (id)initWithDatabase:(WNCDatabase *)database
{
    self = [super init];
    if (self) {
        self.database = database;
        
        NSArray *cmds = [_database fetchCommands:nil];
        
        self.cmds = cmds;
        self.groups = [_database fetchGroups:nil];
        self.dataSource = cmds;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Sorting
    /*NSArray *sorter = @[@"All", @"Keys", @"Strings", @"Hashes", @"Lists", @"Sets", @"Sorted Sets", @"Pub/Sub", @"Transactions", @"Scripting", @"Connection", @"Server"];*/
    
    self.sorting = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, 48.0)];
    self.sorting.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    self.sorting.delegate = self;
    self.sorting.contentSize = CGSizeMake((85 * 12) + (self.view.width - 85.0), 48.0);
    //self.sorting.showsHorizontalScrollIndicator = NO;
    self.sorting.showsVerticalScrollIndicator = NO;
    [self.sorting setContentOffset:CGPointMake(0, 0) animated:YES];
    
    __block float buttonSortingX = 14.0;
    [_groups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RDSGroup *g = (RDSGroup *) obj;

        UIButton *buttonSorting = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 85.0, 48.0)];
        buttonSorting.tag = idx;
        buttonSorting.left = buttonSortingX;
        buttonSorting.backgroundColor = [UIColor clearColor];
        buttonSorting.titleLabel.font = [UIFont fontWithName:@"VAGRoundedStd-Light" size:12.0];
        [buttonSorting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonSorting setTitle:g.name forState:UIControlStateNormal];
        [buttonSorting addTarget:self action:@selector(sortingButton:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonSortingX += 85.0;
        
        [self.sorting addSubview:buttonSorting];
    }];
    
    [self.view addSubview:self.sorting];

    // Sorting Border Bottom
    UIView *sortingBorderBottom = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, (1.0 / [UIScreen mainScreen].scale))];
    sortingBorderBottom.top = self.sorting.bottom - sortingBorderBottom.height;
    sortingBorderBottom.backgroundColor = [UIColor colorWithHexString:@"d3392e"];
    [self.view addSubview:sortingBorderBottom];
    
    
    // Sorter Selected
    UIView *sorterSelected = [[UIView alloc] initWithFrame:CGRectMake(14.0, 0.0, 85.0, 2.0)];
    sorterSelected.top = self.sorting.bottom - sorterSelected.height;
    sorterSelected.backgroundColor = [UIColor colorWithHexString:@"d3392e"];
    [self.view addSubview:sorterSelected];
    

    // TableView
    float tableViewHeight = self.view.height - self.sorting.bottom;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.sorting.bottom, 320.0, tableViewHeight)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [self buttonConsole];
    self.navigationItem.titleView = [self titleLogo];
    self.navigationItem.leftBarButtonItem = [self buttonLanguage];
    
    // Fonts
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RDSCommand *cmd = [_dataSource objectAtIndex:indexPath.row];
    NSString *htmlDoc = [_database getHTMLForCommand:cmd];
    
    CommandViewController *commandView = [[CommandViewController alloc] initWithCommand:cmd
                                                                          documentation:htmlDoc];
    [self.navigationController pushViewController:commandView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RDSCommand *cmd = [_dataSource objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    // Cell selection
    // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // [cell setBackgroundColor:[UIColor clearColor]];
    
    // Title
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 40.0)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.top = 20.0;
    labelTitle.left = 15.0;
    labelTitle.font = [UIFont fontWithName:@"Aleo-Regular" size:13.0];
    labelTitle.text = cmd.name;
    labelTitle.textColor = [UIColor colorWithHexString:@"d3392e"];
    [labelTitle sizeToFit];
    [cell addSubview:labelTitle];
    
    // Summary
    UILabel *labelSummary = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 84.0)];
    labelSummary.backgroundColor = [UIColor clearColor];
    labelSummary.top = labelTitle.bottom + 5.0;
    labelSummary.left = 15.0;
    labelSummary.font = [UIFont fontWithName:@"VAGRoundedStd-Light" size:12.0];
    labelSummary.textColor = [UIColor colorWithHexString:@"006269"];
    labelSummary.text = cmd.summary;
    labelSummary.lineBreakMode = NSLineBreakByWordWrapping;
    labelSummary.numberOfLines = 0;
    [labelSummary sizeToFit];
    [cell addSubview:labelSummary];
    
    // Accessory
    UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory"]];
    accessory.top = floor((84.0 - accessory.height) / 2);
    accessory.left = cell.width - accessory.width - 15.0;
    [cell addSubview:accessory];
    
    // Sepator
    UIView *sepator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.width, (1.0 / [UIScreen mainScreen].scale))];
    sepator.top = 84.0 - sepator.height;
    sepator.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    [cell addSubview:sepator];
    
    
    return cell;
}

#pragma mark Sorting

- (void)sortingButton:(UIButton *)sender
{
    [self.sorting setContentOffset:CGPointMake((sender.tag * 85.0), 0) animated:YES];
    
    RDSGroup *group = (RDSGroup *) [_groups objectAtIndex:sender.tag];
    
    NSMutableArray *filtCmds = [NSMutableArray arrayWithArray:_cmds];
    
    [filtCmds filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        RDSCommand *cmd = (RDSCommand *) evaluatedObject;
        return [group.cmds containsObject:cmd.uid];
    }]];
    
    self.dataSource = filtCmds;
    
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.sorting){
        [self.sorting setContentOffset: CGPointMake(self.sorting.contentOffset.x, 0.0)];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == self.sorting){
        int position = (int) floor(scrollView.contentOffset.x / 85.0);
        
        [self.sorting setContentOffset:CGPointMake((position * 85.0), 0) animated:YES];
        return;
    }
}

#pragma mark Data source

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

- (UIBarButtonItem *)buttonLanguage{
    UIButton *buttonNow = [UIButton buttonWithType:UIButtonTypeCustom];
    //[buttonNow addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [buttonNow setBackgroundImage:[UIImage imageNamed:@"nav-redis"] forState:UIControlStateNormal];
    [buttonNow setFrame:CGRectMake(0.0, 0, 60, 30)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [containerView addSubview:buttonNow];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

- (void)consoleOpen{
    
    ConsoleViewController *consoleView = [[ConsoleViewController alloc] initWithCLI:nil AndDisplay:nil];
    [self.navigationController presentViewController:consoleView animated:YES completion:nil];
}


@end
