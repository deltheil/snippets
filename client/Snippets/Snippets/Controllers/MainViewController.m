//
//  MainViewController.m
//  Snippets
//
//  Created by Aymeric Gallissot on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *sorting;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Sorting
    NSArray *sorter = @[@"All", @"Keys", @"Strings", @"Hashes", @"Lists", @"Sets", @"Sorted Sets", @"Pub/Sub", @"Transactions", @"Scripting", @"Connection", @"Server"];
    
    self.sorting = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, 48.0)];
    self.sorting.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    self.sorting.delegate = self;
    self.sorting.contentSize = CGSizeMake((85 * 12), 48.0);
    //self.sorting.showsHorizontalScrollIndicator = NO;
    self.sorting.showsVerticalScrollIndicator = NO;
    [self.sorting setContentOffset:CGPointMake(0, 0) animated:YES];
    
    __block float buttonSortingX = 14.0;
    [sorter enumerateObjectsUsingBlock:^(NSString *sort, NSUInteger idx, BOOL *stop) {
        
        UIButton *buttonSorting = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 85.0, 48.0)];
        buttonSorting.tag = idx;
        buttonSorting.left = buttonSortingX;
        buttonSorting.backgroundColor = [UIColor colorWithHexString:@"333333"];
        buttonSorting.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [buttonSorting setTitle:sort forState:UIControlStateNormal];
        [buttonSorting addTarget:self action:@selector(sortingButton:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonSortingX += 85.0;
        
        [self.sorting addSubview:buttonSorting];
    }];
     
    [self.view addSubview:self.sorting];
    
    
    // TableView
    float tableViewHeight = self.view.height - self.sorting.bottom;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.sorting.bottom, 320.0, tableViewHeight)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    // Cell selection
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    
    return cell;
}

#pragma mark Sorting
- (void)sortingButton:(UIButton *)sender{
    
    [self.sorting setContentOffset:CGPointMake((sender.tag * 85.0) + 14.0, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.sorting){
        [self.sorting setContentOffset: CGPointMake(self.sorting.contentOffset.x, 0.0)];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"%f", scrollView.contentOffset.x);
    
    /*
    int x = scrollView.contentOffset.x;
    int xOff = x % 50;
    if(xOff < 25)
    	x -= xOff;
    else
    	x += 50 - xOff;
    
    int halfW = scrollView.contentSize.width / 2; // the width of the whole content view, not just the scroll view
    if(x > halfW)
    	x = halfW;
    
    [scrollView setContentOffset:CGPointMake(x,scrollView.contentOffset.y)];
     */
}

@end
