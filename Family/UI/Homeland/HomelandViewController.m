//
//  HomelandViewController.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "HomelandViewController.h"
#import "WebViewController.h"
#import "BaseViewController+Picker.h"
#import "UINavigationController+Custom.h"
#import "UIImageView+WebCache.h"

@implementation HomelandViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitle:NSLocalizedString(@"家园", nil)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Rewrite Super

- (void)adjustNavigationBarColor
{
    [self setNavigationBarColor:[UIColor redColor]];
}

- (void)adjustNavigationBarTitleColor
{
    [self setNavigationBarTitleColor:[UIColor whiteColor]];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"HomelandTableViewCellID";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 40)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.contentView addSubview:imageView];
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://cdn.duitang.com/uploads/item/201207/19/20120719132937_dGRrn.thumb.600_0.jpeg"]];
    
    cell.backgroundColor = [UIColor purpleColor];
    
    if (0 == indexPath.row)
    {
        cell.textLabel.text = @"WebView";
    }
    else if (1 == indexPath.row)
    {
        cell.textLabel.text = @"AssetPicker";
    }
    else if (2 == indexPath.row)
    {
        cell.textLabel.text = @"Camera";
    }
    else
    {
        //
    }
    
    if (indexPath.row % 3 == 0)
    {
        imageView.backgroundColor = [UIColor redColor];
    }
    else if (indexPath.row % 3 == 1)
    {
        imageView.backgroundColor = [UIColor greenColor];
    }
    else
    {
        imageView.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        WebViewController *web = [[WebViewController alloc] init];
        web.fileURL = @"http://www.baidu.com";
        web.fileURL = @"http://119.254.196.16/ennewhelp/"; // help
        // web.fileURL = @"http://119.254.196.16/about/index.html"; // introduction
        web.fileURL = @"http://cnn.com";
        [self pushVC:web];
    }
    else if (1 == indexPath.row)
    {
        [self presentModalVC:[self assetPicker]];
    }
    else if (2  == indexPath.row)
    {
        [self presentModalVC:[self photoCameraPicker]];
    }
    else
    {
        BaseViewController *vc = [[[self class] alloc] init];
        [self pushVC:vc];
    }
    
    // 取消选中
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
