//
//  XLTFineShopViewController.m
//  XingKouDai
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTFineShopViewController.h"
#import "XLDStreetLogic.h"
#import "XLTBigVHeadView.h"
#import "XLTGoodsDetailVC.h"
#import "XLTHotOnlineHeadView.h"
#import "XLTSearchViewController.h"
#import "XLTCelebrityStoreHeaderView.h"
#import "XLTCelebrityStoreGoodsCell.h"
#import "XLTCelebrityFooter.h"
#import "XLTBGCollectionViewFlowLayout.h"
#import "XLTStoreContainerVC.h"


@interface XLTFineShopViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XLTBGCollectionViewDelegateFlowLayout, XLTCelebrityStoreHeaderDelegate>
@property (nonatomic, strong) XLTHotOnlineHeadView *letaoTopHeadView;

@end
@implementation XLTFineShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupTopHeadView];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    
    [[XLTRepoDataManager shareManager] repoRedStreetWithPlate:self.letaoParentPlateId childPlate:@"500002"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
    [self.view bringSubviewToFront:self.letaoTopHeadView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(10, kSafeAreaInsetsTop, self.view.bounds.size.width -20, self.view.bounds.size.height - kSafeAreaInsetsTop);
}

- (void)letaoSetupTopHeadView {
    XLTHotOnlineHeadView *letaoTopHeadView = [[XLTHotOnlineHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XLTHotOnlineHeadView headViewDefaultHeight])];
    [letaoTopHeadView.leftButton addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
    [letaoTopHeadView.searchButton addTarget:self action:@selector(letaoSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:letaoTopHeadView];
    self.letaoTopHeadView = letaoTopHeadView;
}

- (void)letaoPopAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)letaoSearchAction {
    XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:NO];
}


- (UICollectionViewFlowLayout *)collectionViewLayout {
    XLTBGCollectionViewFlowLayout *flowLayout = [[XLTBGCollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
     __weak typeof(self)weakSelf = self;
    [XLDStreetLogic xingletaonetwork_requestRedShopListWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull shopArray) {
        success(shopArray);
        [weakSelf.view bringSubviewToFront:weakSelf.collectionView];
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];

}


// CELL
static NSString *const kXLTCelebrityStoreHeaderView = @"XLTCelebrityStoreHeaderView";
static NSString *const kXLTCelebrityStoreGoodsCell = @"XLTCelebrityStoreGoodsCell";
static NSString *const kXLTCelebrityFooter = @"XLTCelebrityFooter";

- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:kXLTCelebrityStoreHeaderView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTCelebrityStoreHeaderView];

    [self.collectionView registerNib:[UINib nibWithNibName:kXLTCelebrityStoreGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTCelebrityStoreGoodsCell];

    [self.collectionView registerNib:[UINib nibWithNibName:kXLTCelebrityFooter bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXLTCelebrityFooter];

}

- (NSArray *)letaoGoodsArrayForSection:(NSInteger)section {
    NSDictionary *letaoBigVDictionary = self.letaoPageDataArray[section];
    if ([letaoBigVDictionary isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = letaoBigVDictionary[@"goods"];
        if ([goodsArray isKindOfClass:[NSArray class]]) {
            return goodsArray;
        }
    }
    return nil;
}

- (NSDictionary *)letaoGoodsInfoForIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *goodsArray = [self letaoGoodsArrayForSection:indexPath.section];
    if (indexPath.row < goodsArray.count) {
        return goodsArray[indexPath.row];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.letaoPageDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *iteminfo = self.letaoPageDataArray[section];
    if ([iteminfo isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = iteminfo[@"goods"];
        if ([goodsArray isKindOfClass:[NSArray class]]) {
            return MIN(3, goodsArray.count);
        }
    }
    return 0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTCelebrityStoreGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTCelebrityStoreGoodsCell forIndexPath:indexPath];
    NSDictionary *iteminfo = self.letaoPageDataArray[indexPath.section];
    NSArray *goodsArray = iteminfo[@"goods"];
    NSDictionary *goodInfo = nil;
    if (indexPath.row < goodsArray.count) {
        goodInfo = goodsArray[indexPath.row];
    }
    [cell letaoUpdateCellDataWithInfo:goodInfo];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floorl((collectionView.bounds.size.width -40)/3);
    return CGSizeMake(width, width +60 + 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    NSDictionary *letaoStoreDictionary = self.letaoPageDataArray[section];
    CGFloat height = 120;
    if (![XLTCelebrityStoreHeaderView letaoStoreisEvaluatesValidForInfo:letaoStoreDictionary]) {
        height -= 40;
    }
    return CGSizeMake(collectionView.bounds.size.width, height);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 60);
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (kind == UICollectionElementKindSectionHeader) {
         XLTCelebrityStoreHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTCelebrityStoreHeaderView forIndexPath:indexPath];
          headerView.indexPath = indexPath;
          NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.section];
         [headerView updateCelebrityData:itemInfo];
         headerView.delegate = self;
         return headerView;
     } else {
         XLTCelebrityFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXLTCelebrityFooter forIndexPath:indexPath];
          footer.indexPath = indexPath;
          NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.section];
         [footer letaoUpdateCellDataWithInfo:itemInfo];
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
    NSDictionary *itemInfo = [self letaoGoodsInfoForIndexPath:indexPath];
    NSString *letaoGoodsId = itemInfo[@"_id"];
    NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
    XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
    goodDetailViewController.letaoPassDetailInfo = itemInfo;
    goodDetailViewController.letaoGoodsId = letaoGoodsId;
    goodDetailViewController.letaoStoreId = letaoStoreId;
    goodDetailViewController.letaoParentPlateId = self.letaoParentPlateId;
    goodDetailViewController.letaoCurrentPlateId = @"500002";
    goodDetailViewController.letaoIsCustomPlate = YES;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.letaoGoodsSource = item_source;
    NSString *letaoGoodsItemId = itemInfo[@"item_id"];
    goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
    [self.navigationController pushViewController:goodDetailViewController animated:YES];
    
    // 汇报事件
    [SDRepoManager xltrepo_trackPlatleGoodsSelected:itemInfo
                                          xlt_item_firstplatle_id:self.letaoParentPlateId
                                       xlt_item_firstplatle_title:@"红人街"
                                         xlt_item_secondplatle_id:nil
                                      xlt_item_secondplatle_title:@"网红店"
                             xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
}


- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    return [UIColor whiteColor];
}

- (void)letaoPushToStoreAction:(XLTCelebrityStoreHeaderView *)storeHeaderView {
    if (storeHeaderView.indexPath.section < self.letaoPageDataArray.count) {
        NSDictionary *seller  = self.letaoPageDataArray[storeHeaderView.indexPath.section];
        XLTStoreContainerVC *storeViewController = [[XLTStoreContainerVC alloc] init];
        NSString *letaoStoreId = nil;
        if ([seller isKindOfClass:[NSDictionary class]]) {
            letaoStoreId = seller[@"seller_shop_id"];
        }
        storeViewController.letaoStoreId = letaoStoreId;
        storeViewController.letaoStoreDictionary = seller;
        [self.navigationController pushViewController:storeViewController animated:YES];
    }

}

@end
