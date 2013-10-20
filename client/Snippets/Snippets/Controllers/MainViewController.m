//
//  MainViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "MainViewController.h"
#import "CommandViewController.h"
#import "ConsoleViewController.h"

#import <Winch/Winch.h>

// Data model
#import "RDSCommand.h"
#import "RDSType.h"

@interface MainViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *sorting;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cmds;
@property (nonatomic, strong) NSArray *types;

@end

@implementation MainViewController

- (id)initWithDatabase:(WNCDatabase *)db
{
    self = [super init];
    if (self) {
        _database = db;
        if ([[_database getNamespace:kRDSCommandsNS] count] > 0) {
            self.cmds = [RDSCommand fetch:nil];
            self.types = [RDSType fetch:nil];
        }
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
    [_types enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RDSType *t = (RDSType *) obj;

        UIButton *buttonSorting = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 85.0, 48.0)];
        buttonSorting.tag = idx;
        buttonSorting.left = buttonSortingX;
        buttonSorting.backgroundColor = [UIColor clearColor];
        buttonSorting.titleLabel.font = [UIFont fontWithName:@"VAGRoundedStd-Light" size:12.0];
        [buttonSorting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonSorting setTitle:t.name forState:UIControlStateNormal];
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

    // Fonts
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
    
    if ([_cmds count] > 0) {
        [self reload];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // TODO: move the initial sync at another level
    if ([_cmds count] <= 0) {
        [self reload];
    }
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
    RDSCommand *cmd = [_cmds objectAtIndex:indexPath.row];
    
    CommandViewController *commandView = [[CommandViewController alloc] initWithCommand:cmd];
    [self.navigationController pushViewController:commandView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_cmds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RDSCommand *cmd = [_cmds objectAtIndex:indexPath.row];
    
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
- (void)sortingButton:(UIButton *)sender{
    [self.sorting setContentOffset:CGPointMake((sender.tag * 85.0), 0) animated:YES];
    
    RDSType *type = (RDSType *) [_types objectAtIndex:sender.tag];
    
    NSMutableArray *filt = [NSMutableArray arrayWithCapacity:[type.cmds count]];
    for (NSString *uid in type.cmds) {
        RDSCommand *c = [RDSCommand getCommand:uid];
        if (c != nil) {
            [filt addObject:c];

        }
    }
    
    self.cmds = filt;
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

- (void)setTypes:(NSArray *)t
{
    NSMutableArray *ary = [NSMutableArray arrayWithArray:t];
    
    NSMutableArray *allCmds = [NSMutableArray arrayWithCapacity:[_cmds count]];
    for (RDSCommand *cmd in _cmds) {
        [allCmds addObject:cmd.uid];
    }
    
    RDSType *all = [[RDSType alloc] initWithName:@"All" commands:allCmds];
    
    [ary insertObject:all atIndex:0];
    
    _types = ary;
}

- (void)reload
{
    [self reloadWithResultBlock:nil progressBlock:nil];
}

- (void)reloadWithResultBlock:(void (^)(NSError *error))resultBlock
                progressBlock:(void (^)(NSInteger percentDone))progressBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^postSyncBlock)(NSArray *, NSArray *, NSError *) = ^(NSArray *c, NSArray *t, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (resultBlock) {
            resultBlock(error);
        }
        
        if (!error) {
            self.cmds = c;
            self.types = t;
            [self.tableView reloadData];
        }
    };
    
    [RDSCommand sync:postSyncBlock
            progress:progressBlock];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)consoleOpen{
    
    ConsoleViewController *consoleView = [[ConsoleViewController alloc] init];
    [self.navigationController pushViewController:consoleView animated:YES];
}


@end
