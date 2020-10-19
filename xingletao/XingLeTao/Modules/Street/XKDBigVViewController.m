//
//  XKDExplosionViewController.m
//  XingKouDai
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XKDBigVViewController.h"
#import "XKDStreetLogic.h"
#import "XKDDaVGoodsCell.h"
#import "XKDDaVHeadView.h"
#import "XKDGoodDetailViewController.h"
#import "XKDExplosionHeadView.h"
#import "XKDSearchViewController.h"
#import "XKDDaVContainerViewController.h"

@interface XKDBigVViewController () <XKDDaVHeadViewDelegate, XKDDaVGoodsCellDelegate>
@property (nonatomic, strong) XKDExplosionHeadView *homeHeadView;

@end

@implementation XKDBigVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bulidHomeHeadView];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self xkd_hiddenNavigationBar:YES];
    
    [[XKDRepoManager shareManager] repoRedStreetWithPlate:self.rootPlateId childPlate:@"500003"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)showLoadingView {
    self.loadingViewBgColor = [UIColor clearColor];
    [super showLoadingView];
    [self.view bringSubviewToFront:self.homeHeadView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
}

- (void)bulidHomeHeadView {
    XKDExplosionHeadView *homeHeadView = [[XKDExplosionHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XKDExplosionHeadView headViewDefaultHeight])];
    [homeHeadView.leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [homeHeadView.searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeHeadView];
    self.homeHeadView = homeHeadView;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction {
    XKDSearchViewController *searchViewController = [[XKDSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:NO];
}


- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)requestPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XKDBaseListRequestSuccess)success failed:(XKDBaseListRequestFailed)failed {
     __weak typeof(self)weakSelf = self;
    [XKDStreetLogic getBigVListWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull daVArray) {
        success(daVArray);
        [weakSelf.view bringSubviewToFront:weakSelf.collectionView];
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];

}


// CELL
static NSString *const kXKDDaVGoodsCell = @"XKDDaVGoodsCell";
static NSString *const kXKDDaVHeadView = @"XKDDaVHeadView";

- (void)registerCells {
    [self.collectionView registerNib:[UINib nibWithNibName:kXKDDaVGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXKDDaVGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kXKDDaVHeadView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXKDDaVHeadView];
}

- (NSArray *)goodsArrayInSection:(NSInteger)section {
    NSDictionary *daVInfo = self.dataArray[section];
    if ([daVInfo isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = daVInfo[@"good_info"];
        if ([goodsArray isKindOfClass:[NSArray class]]) {
            return goodsArray;
        }
    }
    return nil;
}

- (NSDictionary *)goodsInfoAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *goodsArray = [self goodsArrayInSection:indexPath.section];
    if (indexPath.row < goodsArray.count) {
        return goodsArray[indexPath.row];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self goodsArrayInSection:section].count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XKDDaVGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXKDDaVGoodsCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    NSDictionary *itemInfo = [self goodsInfoAtIndexPath:indexPath];
    BOOL isLastCell = (indexPath.row == [self goodsArrayInSection:indexPath.section].count -1);
    [cell updateCellData:itemInfo isLastCell:isLastCell];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLastCell = (indexPath.row == [self goodsArrayInSection:indexPath.section].count -1);
    CGFloat offset = 0;
    if (isLastCell) {
        offset += 22;
    }
    return CGSizeMake(collectionView.bounds.size.width-20, 115 +offset);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 75);

}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     XKDDaVHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXKDDaVHeadView forIndexPath:indexPath];
     headerView.indexPath = indexPath;
     NSDictionary *itemInfo = self.dataArray[indexPath.section];
    [headerView updateDaVData:itemInfo];
    headerView.delegate = self;
    return headerView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self goodsInfoAtIndexPath:indexPath];
    NSString *goodsId = itemInfo[@"_id"];
    NSString *storeId = itemInfo[@"seller_shop_id"];
    XKDGoodDetailViewController *goodDetailViewController = [[XKDGoodDetailViewController alloc] init];
    goodDetailViewController.goodsId = goodsId;
    goodDetailViewController.storeId = storeId;
    goodDetailViewController.rootPlateId = self.rootPlateId;
    goodDetailViewController.plateId = @"500003";
    goodDetailViewController.isFromCustomPlate = YES;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.item_source = item_source;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];
}

- (void)daVHeadViewClickAction:(XKDDaVHeadView *)headView {
    [self pushDaVContainerViewController:headView.indexPath];
}

- (void)moreButtonAction:(XKDDaVGoodsCell *)cell {
    [self pushDaVContainerViewController:cell.indexPath];
}

- (void)pushDaVContainerViewController:(NSIndexPath *)indexPath {
    NSDictionary *daVInfo = self.dataArray[indexPath.section];
    if ([daVInfo isKindOfClass:[NSDictionary class]]) {
        XKDDaVContainerViewController *daVContainerViewController = [[XKDDaVContainerViewController alloc] init];
        daVContainerViewController.daVInfo = daVInfo;
        daVContainerViewController.rootPlateId = self.rootPlateId;
        [self.navigationController pushViewController:daVContainerViewController animated:YES];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
