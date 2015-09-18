//
//  BaseTableViewController.m
//  MyBox
//
//  Created by junbo jia on 14-8-4.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
{
    UITableViewStyle _tableViewStyle;
}
@end

@implementation BaseTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init])
    {
        _tableViewStyle = style;
        _tableViewDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        _tableViewStyle = UITableViewStylePlain;
        _tableViewDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTableview];
    [self hideTableViewExtraLines:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation
#pragma mark iOS 8 Prior
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view layoutSubviews];
    
//    CGRect frame = [self scrollViewSubviewRect];
//    [self.tableView setFrame:frame];
//    [self.tableView layoutSubviews];
    
//    for (UITableViewCell *cell in self.tableView.visibleCells)
//    {
//        CGRect cellFrame = cell.frame;
//        cellFrame.size.width = CGRectGetWidth(self.tableView.bounds);
//        cell.frame = cellFrame;
//    }
}

#pragma mark ios 8 Later
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.view setNeedsLayout];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        CGRect frame = [self scrollViewSubviewRect];
        [self.tableView setFrame:frame];
        [self.tableView layoutSubviews];
    }];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//}

#pragma mark - Inner Methods

- (void)addTableview
{
    _tableView = [[UITableView alloc] initWithFrame:[self scrollViewSubviewRect] style:_tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0f alpha:1.0f];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)hideTableViewExtraLines:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Delete row
- (void)deleteTableViewRowsAtIndexPaths:(NSArray *)rows
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
