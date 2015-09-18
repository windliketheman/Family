//
//  BaseTableViewController.h
//  MyBox
//
//  Created by junbo jia on 14-8-4.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *tableViewDataSource;

- (id)initWithStyle:(UITableViewStyle)style;

- (void)reloadTableView;

- (void)deleteTableViewRowsAtIndexPaths:(NSArray *)rows;

- (void)hideTableViewExtraLines:(UITableView *)tableView;

@end
