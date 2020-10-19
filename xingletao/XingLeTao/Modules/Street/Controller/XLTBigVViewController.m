//
//  XLTBigVViewController.m
//  XingKouDai
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBigVViewController.h"
#import "XLDStreetLogic.h"
#import "XLTBigVGoodsCell.h"
#import "XLTBigVHeadView.h"
#import "XLTGoodsDetailVC.h"
#import "XLTHotOnlineHeadView.h"
#import "XLTSearchViewController.h"
#import "XLTBigVGoodsListVC.h"
#import "XLTBigVContainerVC.h"

@interface XLTBigVViewController () <XLTBigVHeadViewDelegate, XLTBigVGoodsCellDelegate>
@property (nonatomic, strong) XLTHotOnlineHeadView *letaoTopHeadView;

@end

@implementation XLTBigVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupTopHeadView];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    
    [[XLTRepoDataManager shareManager] repoRedStreetWithPlate:self.letaoParentPlateId childPlate:@"500003"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
    [self.view bringSubviewToFront:self.letaoTopHeadView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return flowLayout;
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
     __weak typeof(self)weakSelf = self;
    [XLDStreetLogic xingletaonetwork_requestBigVListWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull daVArray) {
        success(daVArray);
        [weakSelf.view bringSubviewToFront:weakSelf.collectionView];
    } failure:^(NSString * _Nonnull errorMsg) {
        failed(nil,errorMsg);
    }];

}


// CELL
static NSString *const kXLTBigVGoodsCell = @"XLTBigVGoodsCell";
static NSString *const kXLTBigVHeadView = @"XLTBigVHeadView";

- (void)letaoListRegisterCells {
    [self.collectionView registerNib:[UINib nibWithNibName:kXLTBigVGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTBigVGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kXLTBigVHeadView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTBigVHeadView];
}

- (NSArray *)letaoGoodsArrayForSection:(NSInteger)section {
    NSDictionary *letaoBigVDictionary = self.letaoPageDataArray[section];
    if ([letaoBigVDictionary isKindOfClass:[NSDictionary class]]) {
        NSArray *goodsArray = letaoBigVDictionary[@"good_info"];
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
    return [self letaoGoodsArrayForSection:section].count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTBigVGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTBigVGoodsCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    NSDictionary *itemInfo = [self letaoGoodsInfoForIndexPath:indexPath];
    BOOL isLastCell = (indexPath.row == [self letaoGoodsArrayForSection:indexPath.section].count -1);
    [cell letaoUpdateCellDataWithInfo:itemInfo isLastCell:isLastCell];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLastCell = (indexPath.row == [self letaoGoodsArrayForSection:indexPath.section].count -1);
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
     XLTBigVHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTBigVHeadView forIndexPath:indexPath];
     headerView.indexPath = indexPath;
     NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.section];
    [headerView updateDaVData:itemInfo];
    headerView.delegate = self;
    return headerView;
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
    goodDetailViewController.letaoCurrentPlateId = @"500003";
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
                                      xlt_item_secondplatle_title:@"大V推荐"
                             xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
}

- (void)letaoBigVTopHeadViewClicked:(XLTBigVHeadView *)headView {
    [self letaopushBigVContainerVCWithIndexPath:headView.indexPath];
}

- (void)letaoMoreBtnClicked:(XLTBigVGoodsCell *)cell {
    [self letaopushBigVContainerVCWithIndexPath:cell.indexPath];
}

- (void)letaopushBigVContainerVCWithIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *letaoBigVDictionary = self.letaoPageDataArray[indexPath.section];
    if ([letaoBigVDictionary isKindOfClass:[NSDictionary class]]) {
        XLTBigVContainerVC *daVContainerViewController = [[XLTBigVContainerVC alloc] init];
        daVContainerViewController.letaoBigVDictionary = letaoBigVDictionary;
        daVContainerViewController.letaoParentPlateId = self.letaoParentPlateId;
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
