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
#import "UIImage+Extension.h"

#import "RequestCore.h"

#if 0
    #define kRemoveNavigationBarBottomLineWay1
#else
    #define kRemoveNavigationBarBottomLineWay2
#endif

@interface HomelandViewController ()
{
#ifdef kRemoveNavigationBarBottomLineWay2
    UIImageView *navBarHairlineImageView;
#endif
}
@end

@implementation HomelandViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef kRemoveNavigationBarBottomLineWay1
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
#endif
    
#ifdef kRemoveNavigationBarBottomLineWay2
    // PS: 这种方法可以保持bar的translucent
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
#endif

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitle:NSLocalizedString(@"家园", nil)];
    
#ifdef kRemoveNavigationBarBottomLineWay2
    navBarHairlineImageView.hidden = YES;
#endif
    
    
    [self testRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
#ifdef kRemoveNavigationBarBottomLineWay2
    navBarHairlineImageView.hidden = NO;
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Rewrite Super

- (void)adjustNavigationBarColor
{
    [self setNavigationBarColor:nil];
}

#pragma mark - Inner Methods
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
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
    
    // [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://cdn.duitang.com/uploads/item/201207/19/20120719132937_dGRrn.thumb.600_0.jpeg"]];
    
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
        web.fileURL = @"http://www.iqiyi.com";
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

#pragma mark - Request
- (void)testRequest
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", ServerURL, GetUserInfoInterface];
    
    [RequestCore POST:url params:@{@"intent" : @"1"} returnModel:[NSDictionary class] success:^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
        NSLog(@"result: %@", [dic description]);
    } failure:^(NSError *error) {
        NSLog(@"Failure url: %@", url);
        NSLog(@"%@", [error description]);
    }];
}
@end
