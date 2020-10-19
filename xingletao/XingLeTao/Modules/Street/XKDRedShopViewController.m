//
//  XKDExplosionViewController.m
//  XingKouDai
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XKDRedShopViewController.h"
#import "XKDStreetLogic.h"
#import "XKDDaVHeadView.h"
#import "XKDGoodDetailViewController.h"
#import "XKDExplosionHeadView.h"
#import "XKDSearchViewController.h"
#import "XKDOnlineCelebrityStoreHeaderView.h"
#import "XKDOnlineCelebrityStoreGoodsCell.h"
#import "XKDOnlineCelebrityFooter.h"
#import "JHCollectionViewFlowLayout.h"
#import "XKDStoreContainerViewController.h"


@interface XKDRedShopViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, JHCollectionViewDelegateFlowLayout, XKDOnlineCelebrityStoreHeaderDelegate>
@property (nonatomic, strong) XKDExplosionHeadView *homeHeadView;

@end
@implementation XKDRedShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bulidHomeHeadView];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self xkd_hiddenNavigationBar:YES];
    
    [[XKDRepoManager shareManager] repoRedStreetWithPlate:self.rootPlateId childPlate:@"500002"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)showLoadingView {
    self.loadingViewBgColor = [UIColor clearColor];
    [super showLoadingView];
    [self.view bringSubviewToFront:self.homeHeadView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(10, kSafeAreaInsetsTop, self.view.bounds.size.width -20, self.view.bounds.size.height - kSafeAreaInsetsTop);
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
    JHCollectionViewFlowLayout *flowLayout = [[JHCollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)requestPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XKDBaseListRequestSuccess)success failed:(XKDBaseListRequestFailed)failed {
     __weak typeof(self)weakSelf = self;
    [XKDStreetLogic getRedShopListWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull shopArray) {
        success(shopArray);
        [weakSelf.view bringSubviewToFront:weakSelf.collectionView];
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];

}


// CELL
static NSString *const kXKDOnlineCelebrityStoreHeaderView = @"XKDOnlineCelebrityStoreHeaderView";
static NSString *const kXKDOnlineCelebrityStoreGoodsCell = @"XKDOnlineCelebrityStoreGoodsCell";
static NSString *const kXKDOnlineCelebrityFooter = @"XKDOnlineCelebrityFooter";

- (void)registerCells {
    [self.collectionView registerNib:[UINib nibWithNibName:kXKDOnlineCelebrityStoreHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXKDOnlineCelebrityStoreHeaderView];

    [self.collectionView registerNib:[UINib nibWithNibName:kXKDOnlineCelebrityStoreGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXKDOnlineCelebrityStoreGoodsCell];

    [self.collectionView registerNib:[UINib nibWithNibName:kXKDOnlineCelebrityFooter bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXKDOnlineCelebrityFooter];

}

- (NSArray *)goodsArrayInSection:(NSInteger)section {
    NSDictionary *daVInfo = self.dataArray[section];
    if ([daVInfo isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = daVInfo[@"goods"];
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
    NSDictionary *iteminfo = self.dataArray[section];
    if ([iteminfo isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = iteminfo[@"goods"];
        if ([goodsArray isKindOfClass:[NSArray class]]) {
            return MIN(3, goodsArray.count);
        }
    }
    return 0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XKDOnlineCelebrityStoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXKDOnlineCelebrityStoreGoodsCell forIndexPath:indexPath];
    NSDictionary *iteminfo = self.dataArray[indexPath.section];
    NSArray *goodsArray = iteminfo[@"goods"];
    NSDictionary *goodInfo = nil;
    if (indexPath.row < goodsArray.count) {
        goodInfo = goodsArray[indexPath.row];
    }
    [cell updateCellData:goodInfo];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floorl((collectionView.bounds.size.width -40)/3);
    return CGSizeMake(width, width +60 + 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    NSDictionary *storeInfo = self.dataArray[section];
    CGFloat height = 120;
    if (![XKDOnlineCelebrityStoreHeaderView evaluatesValid:storeInfo]) {
        height -= 40;
    }
    return CGSizeMake(collectionView.bounds.size.width, height);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 60);
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (kind == UICollectionElementKindSectionHeader) {
         XKDOnlineCelebrityStoreHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXKDOnlineCelebrityStoreHeaderView forIndexPath:indexPath];
          headerView.indexPath = indexPath;
          NSDictionary *itemInfo = self.dataArray[indexPath.section];
         [headerView updateCellData:itemInfo];
         headerView.delegate = self;
         return headerView;
     } else {
         XKDOnlineCelebrityFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXKDOnlineCelebrityFooter forIndexPath:indexPath];
          footer.indexPath = indexPath;
          NSDictionary *itemInfo = self.dataArray[indexPath.section];
         [footer updateCellData:itemInfo];
         return footer;
     }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self goodsInfoAtIndexPath:indexPath];
    NSString *goodsId = itemInfo[@"_id"];
    NSString *storeId = itemInfo[@"seller_shop_id"];
    XKDGoodDetailViewController *goodDetailViewController = [[XKDGoodDetailViewController alloc] init];
    goodDetailViewController.goodsId = goodsId;
    goodDetailViewController.storeId = storeId;
    goodDetailViewController.rootPlateId = self.rootPlateId;
    goodDetailViewController.plateId = @"500002";
    goodDetailViewController.isFromCustomPlate = YES;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.item_source = item_source;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];
}


- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [UIColor whiteColor];
}

- (void)storeHeaderViewGoStoreAction:(XKDOnlineCelebrityStoreHeaderView *)storeHeaderView {
    if (storeHeaderView.indexPath.section < self.dataArray.count) {
        NSDictionary *seller  = self.dataArray[storeHeaderView.indexPath.section];
        XKDStoreContainerViewController *storeViewController = [[XKDStoreContainerViewController alloc] init];
        NSString *storeId = nil;
        if ([seller isKindOfClass:[NSDictionary class]]) {
            storeId = seller[@"seller_shop_id"];
        }
        storeViewController.storeId = storeId;
        storeViewController.storeInfo = seller;
        [self.navigationController pushViewController:storeViewController animated:YES];
    }

}


/*
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
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
