//
//  AssetViewController.m
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AssetViewController.h"
#import "AssetTableViewCell.h"
#import "AssetPickerViewController.h"
#import "AssetPickerDefine.h"

#define kTableBottomCellHeight 44.0f

#pragma mark - AssetViewController

@interface AssetViewController () <AssetTableViewCellDelegate>
{
    NSUInteger thumbnailColumns;
    CGSize     thumbnailSize;
    CGFloat    thumbnailItemSpacing;
    CGFloat    thumbnailsSidesSpacing;
    
    BOOL       unFirst;
}

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

#define kAssetViewCellIdentifier @"AssetViewCellIdentifier"

@implementation AssetViewController

- (id)init
{
    if (self = [super init])
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        if ([self respondsToSelector:@selector(setPreferredContentSize:)])
            self.preferredContentSize = kPopoverContentSize;
        
        //[self setContentSizeForViewInPopover:kPopoverContentSize];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!unFirst)
    {
        // columns = floor(self.view.frame.size.width / (kThumbnailSize.width+minimumInteritemSpacing));
        thumbnailsSidesSpacing = [self adjustToFitWidth:CGRectGetWidth(self.tableView.bounds) - self.tableView.contentInset.left - self.tableView.contentInset.right thumbnailSize:&thumbnailSize columns:&thumbnailColumns itemSpacing:&thumbnailItemSpacing];
        
        [self setupAssets];
        
        unFirst = YES;
    }
}

#pragma mark - Rotation

#pragma mark iOS 8 Prior
//static CGSize tableViewContentSizeBeforeRotation;
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    tableViewContentSizeBeforeRotation = self.tableView.contentSize;
//}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self rotateTableView];
}

#pragma mark ios 8 Later
//- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
//              withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super willTransitionToTraitCollection:newCollection
//                 withTransitionCoordinator:coordinator];
//    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
//        if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
//            //To Do: modify something for compact vertical size
//        } else {
//            //To Do: modify something for other vertical size
//        }
//        [self.view setNeedsLayout];
//    } completion:nil];
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.view setNeedsLayout];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self rotateTableView];
    }];
}

#pragma mark Todo 
// 屏幕旋转了 tableview也旋转
- (void)rotateTableView
{
    CGFloat offsetPercent = self.tableView.contentOffset.y / (self.tableView.contentSize.height + [self cellHeight] - kTableBottomCellHeight);
    
    [self setupTableView];
    
    thumbnailsSidesSpacing = [self adjustToFitWidth:CGRectGetWidth(self.tableView.bounds) - self.tableView.contentInset.left - self.tableView.contentInset.right thumbnailSize:&thumbnailSize columns:&thumbnailColumns itemSpacing:&thumbnailItemSpacing];
    
    [self.tableView reloadData];
    
    CGRect scrollToRect = CGRectMake(0.0f,
                                     (self.tableView.contentSize.height + [self cellHeight] - kTableBottomCellHeight)*offsetPercent,
                                     self.tableView.bounds.size.width,
                                     self.tableView.bounds.size.height);
    if (scrollToRect.origin.y + scrollToRect.size.height > self.tableView.contentSize.height)
    {
        scrollToRect.origin.y = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    //[self.tableView scrollRectToVisible:scrollToRect animated:NO];
    [self.tableView setContentOffset:scrollToRect.origin];
}

#pragma mark - Setup

- (void)setupViews
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
}

- (void)setupButtons
{
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
}

- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.numberOfPhotos = 0;
    self.numberOfVideos = 0;
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }
        else
        {
            if (NSNotFound == index) // finished
            {
                [self.tableView reloadData];
                
                // [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(self.assets.count*1.0/thumbnailColumns)  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self tableView:self.tableView scrollToIndex:self.assets.count columns:thumbnailColumns];
                
                [self updateTitle];
            }
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

- (void)tableView:(UITableView *)tableView scrollToIndex:(NSUInteger)index columns:(NSUInteger)columns
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(index*1.0/columns) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Thumbnail

- (void)setupTableView // ToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    thumbnailItemSpacing = kThumbnailMinSpacing;
    
//    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
//    {
//        self.tableView.contentInset = UIEdgeInsetsMake(6.0f, 0, 0, 0);
//    }
//    else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(6.0f, 0, 0, 0);
    }
}

- (NSUInteger)adjustToFitWidth:(float)width thumbnailSize:(CGSize *)outputSize columns:(NSUInteger *)outputColumns itemSpacing:(CGFloat *)outputSpacing
{
    CGFloat minItemSpacing = *outputSpacing;
    CGFloat maxColumns = (width + minItemSpacing) / (kThumbnailMinLength + minItemSpacing);
    *outputColumns = (NSUInteger)maxColumns;
    
    return [self thumbnailSize:outputSize itemSpacing:outputSpacing toFitWidth:width columns:(NSUInteger)maxColumns minItemSpacing:minItemSpacing];
}

- (NSUInteger)thumbnailSize:(CGSize *)outputSize itemSpacing:(CGFloat *)outputSpacing toFitWidth:(const CGFloat)inputWidth columns:(const NSUInteger)inputColumns minItemSpacing:(CGFloat)minItemSpacing
{
    NSUInteger itemWidth = 0;
    if ([self itemWidth:&itemWidth itemSpacing:outputSpacing toFitWidth:inputWidth columns:inputColumns recursive:YES])
    {
        // 能够满足要求
        *outputSize = CGSizeMake(itemWidth, itemWidth);
        return 0;
    }
    else
    {
        // 根本满足不了要求，那只能在tableview两侧加空白
        *outputSpacing = minItemSpacing;
        [self itemWidth:&itemWidth itemSpacing:outputSpacing toFitWidth:inputWidth columns:inputColumns recursive:NO];
        *outputSize = CGSizeMake(itemWidth, itemWidth);
        
        return (inputWidth - itemWidth*inputColumns - *outputSpacing*(inputColumns - 1))/2;
    }
}

- (BOOL)itemWidth:(NSUInteger *)itemWidth itemSpacing:(CGFloat *)itemSpacing  toFitWidth:(const NSUInteger)width columns:(const NSUInteger)columns recursive:(BOOL)recursive
{
    *itemWidth = floor((width - (columns-1)*(*itemSpacing))/columns);
    
    if (recursive)
    {
        if (width - *itemWidth*columns - *itemSpacing*(columns - 1))
        {
            if (*itemSpacing < kThumbnailMaxSpacing)
            {
                *itemSpacing += 1;
                return [self itemWidth:itemWidth itemSpacing:itemSpacing toFitWidth:width columns:columns recursive:YES];
            }
            else
            {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.assets.count*1.0/thumbnailColumns) + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != ceil(self.assets.count*1.0/thumbnailColumns))
    {
        return [self cellHeight];
    }
    else
    {
        return kTableBottomCellHeight;
    }
}

- (CGFloat)cellHeight
{
    return thumbnailSize.height + thumbnailItemSpacing;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ceil(self.assets.count*1.0/thumbnailColumns))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        
        if (!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
            cell.textLabel.font=[UIFont systemFontOfSize:18];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.backgroundColor=[UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        NSString *title;
        
        if (_numberOfVideos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片", nil), (long)_numberOfPhotos];
        else if (_numberOfPhotos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 部视频", nil), (long)_numberOfVideos];
        else
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
        
        cell.textLabel.text=title;
        return cell;
    }
    
    
    NSMutableArray *tempAssets = [[NSMutableArray alloc] init];
    for (int i = 0; i < thumbnailColumns; i++)
    {
        if ((indexPath.row*thumbnailColumns + i) < self.assets.count)
        {
            [tempAssets addObject:[self.assets objectAtIndex:indexPath.row*thumbnailColumns + i]];
        }
    }
    
    static NSString *CellIdentifier = kAssetViewCellIdentifier;
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    
    AssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[AssetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    // 屏幕可能会发生旋转，thumbnailSize不是初始化后一成不变，因此要动态更新
    cell.thumbnailSize = thumbnailSize;
    
    float rowX = self.tableView.frame.size.width - thumbnailSize.width*tempAssets.count - thumbnailItemSpacing*(tempAssets.count - 1);
    rowX /= 2;
    rowX = thumbnailsSidesSpacing;
    [cell bind:tempAssets selectionFilter:picker.selectionFilter itemSpacing:thumbnailItemSpacing columns:thumbnailColumns rowX:rowX];
    return cell;
}

#pragma mark - AssetTableViewCell Delegate

- (BOOL)isSelectedAsset:(ALAsset *)asset
{
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    return [picker isSelectedAsset:asset];
}

- (BOOL)shouldSelectAsset:(ALAsset *)asset
{
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    return [picker shouldSelectAsset:asset];
}

- (void)didSelectAsset:(ALAsset *)asset
{
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    [picker didSelectAsset:asset];
    
    [self updateTitle];
}

- (void)didDeselectAsset:(ALAsset *)asset
{
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    [picker didDeselectAsset:asset];
    
    [self updateTitle];
}

#pragma mark - Title
- (void)updateTitle
{
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    [self setTitleWithSelectedIndexPaths:[picker selectedAssets]];
}

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    if (!indexPaths.count)
    {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (int i = 0; i < indexPaths.count; i++)
    {
        ALAsset *asset = indexPaths[i];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;
    }
    
    NSString *format;
    
    if (photosSelected && videoSelected)
        format = NSLocalizedString(@"已选择 %ld 个项目", nil);
    
    else if (photosSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 张照片", nil) : NSLocalizedString(@"已选择 %ld 张照片 ", nil);
    
    else if (videoSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 部视频", nil) : NSLocalizedString(@"已选择 %ld 部视频 ", nil);
    
    self.title = [NSString stringWithFormat:format, (long)indexPaths.count];
}


#pragma mark - Actions
- (void)finishPickingAssets:(id)sender
{
    AssetPickerViewController *picker = (AssetPickerViewController *)self.navigationController;
    [picker finishPicking];
    
    if (picker.isFinishDismissViewController)
    {
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
