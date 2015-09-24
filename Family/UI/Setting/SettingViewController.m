//
//  SettingViewController.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

@implementation SettingViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"设置"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SettingTableViewCell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (0 == indexPath.row)
    {
        [cell.textLabel setText:@"标记"];
        cell.accessoryStyle = TableViewCellAccessoryTextIndicator;
        [cell.arrowTextLabel setText:@"已设"];
    }
    else if (1 == indexPath.row)
    {
        [cell.textLabel setText:@"分组"];
        cell.segmentViewDataSource = @[@{@"text": NSLocalizedString(@"名称", nil), @"icon": @""}, @{@"text": NSLocalizedString(@"类型", nil), @"icon": @""}];
        cell.accessoryStyle = TableViewCellAccessorySegment;
    }
    else
    {
        [cell.textLabel setText:@"开关"];
        cell.accessoryStyle = TableViewCellAccessorySwitch;
        
        
        [cell.switchView setOn:YES];
        [cell setSwitchChangedHandler:^(BOOL isOn)
         {
             
         }];
    }
    return cell;
}
@end
