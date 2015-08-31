//
//  BaseTableViewController.h
//  ennew
//
//  Created by mijibao on 15/5/22.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

// subclass rewrite, if not, default return UITableViewStylePlain
- (UITableViewStyle)tableViewStyle;

@end
