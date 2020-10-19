//
//  XLTHomePlateListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomePlateListVC.h"
#import "XLTHomePageLogic.h"
#import "XLTHomeGoodsCollectionViewCell.h"
#import "XLTHomeHotGoodsCollectionViewCell.h"
#import "XLTHomeSingleGoodsCollectionViewCell.h"
#import "LetaoEmptyCoverView.h"
#import "XLTHomeCouponGoodsCollectionViewCell.h"
#import "XLTGoodsDetailVC.h"

@interface XLTHomePlateListVC ()
@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@end

@implementation XLTHomePlateListVC


- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];

}

- (void)repoViewPage {
    [[XLTRepoDataManager shareManager] repoPlateViewPage:self.letaoParentPlateId childPlate:self.plateCode];
    // 汇报事件
//    [SDRepoManager xltrepo_trackPlatleClickEvent:nil xlt_item_id:self.plateCode xlt_item_title:self.plateName];

}


- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    BOOL hasCoupon = NO;
    if (self.plateType == XLTPlateCouponType) {
        hasCoupon = YES;
    }    
    [self.letaoHomeLogic requestHomePlateGoodsListDataForIndex:index pageSize:pageSize sort:nil source:nil postage:nil startPrice:nil endPrice:nil letaoStoreId:nil hasCoupon:hasCoupon plate:self.plateCode success:^(NSArray * _Nonnull goodsArray,NSURLSessionDataTask * task) {
         success(goodsArray);

     } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
            failed(nil,errorMsg);
     }];
}

// CELL
static NSString *const kXLTHomeGoodsCollectionViewCell = @"XLTHomeGoodsCollectionViewCell";
static NSString *const kXLTHomeHotGoodsCollectionViewCell = @"XLTHomeHotGoodsCollectionViewCell";
static NSString *const kXLTHomeSingleGoodsCollectionViewCell = @"XLTHomeSingleGoodsCollectionViewCell";
static NSString *const kXLTHomeCouponGoodsCollectionViewCell = @"XLTHomeCouponGoodsCollectionViewCell";


- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeGoodsCollectionViewCell];
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeHotGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeHotGoodsCollectionViewCell];
    
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeSingleGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell];
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeCouponGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCouponGoodsCollectionViewCell];


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.letaoPageDataArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.plateType == XLTPlate_99Type) {
        XLTHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeGoodsCollectionViewCell forIndexPath:indexPath];
        cell.letaoShowImageFlag = YES;
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    } else if (self.plateType == XLTPlateHotType) {
        XLTHomeHotGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeHotGoodsCollectionViewCell forIndexPath:indexPath];
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    } else if (self.plateType == XLTPlateCouponType) {
        XLTHomeCouponGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCouponGoodsCollectionViewCell forIndexPath:indexPath];
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    }  else {
        XLTHomeSingleGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeSingleGoodsCollectionViewCell forIndexPath:indexPath];
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    }
    return [UICollectionViewCell new];
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 157;
    if (self.plateType == XLTPlateCouponType) {
        height = 110;
    }
    return CGSizeMake(collectionView.bounds.size.width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.plateType == XLTPlateCouponType) {
        return UIEdgeInsetsMake(15, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.plateType == XLTPlateCouponType) {
        return 15.0;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];
    NSString *letaoGoodsId = itemInfo[@"_id"];
    NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
    XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
    goodDetailViewController.letaoPassDetailInfo = itemInfo;
    goodDetailViewController.letaoGoodsId = letaoGoodsId;
    goodDetailViewController.letaoStoreId = letaoStoreId;
    goodDetailViewController.letaoParentPlateId = self.letaoParentPlateId;
    goodDetailViewController.letaoCurrentPlateId = self.plateCode;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.letaoGoodsSource = item_source;
    NSString *letaoGoodsItemId = itemInfo[@"item_id"];
    goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;

    [self.navigationController pushViewController:goodDetailViewController animated:YES];
    
    
    // 板块商品点击汇报
    NSString *xlt_item_firstplatle_id = nil;
    NSString *xlt_item_firstplatle_title = nil;
    NSString *xlt_item_secondplatle_id = nil;
    NSString *xlt_item_secondplatle_title = nil;
    
    if (self.letaoParentPlateName && self.letaoParentPlateId) {
        xlt_item_firstplatle_title = self.letaoParentPlateName;
        xlt_item_firstplatle_id = self.letaoParentPlateId;
    }
    if (self.plateName && self.plateCode) {
        xlt_item_secondplatle_id = self.plateCode;
        xlt_item_secondplatle_title = self.plateName;
    }
    [SDRepoManager xltrepo_trackPlatleGoodsSelected:itemInfo xlt_item_firstplatle_id:xlt_item_firstplatle_id xlt_item_firstplatle_title:xlt_item_firstplatle_title xlt_item_secondplatle_id:xlt_item_secondplatle_id xlt_item_secondplatle_title:xlt_item_secondplatle_title xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
}

- (void)letaoShowEmptyView {
    [super letaoShowEmptyView];
    self.letaoEmptyCoverView.titleStr = @"换个分类看看吧~";
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
}

@end
