//
//  XLTHomePlateFilterListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomePlateFilterListVC.h"
#import "XLTHomePageLogic.h"
#import "XLTCouponSwitchView.h"
#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "XLTHomeTopCollectionViewCell.h"
#import "XLTHomeCustomHeadBgView.h"
#import "XLTCouponSwitchView.h"
#import "LetaoEmptyCoverView.h"
#import "XLTGoodsDetailVC.h"
#import "XLTCategoryFilterListVC.h"
#import "XLTRightFilterViewController.h"

@interface XLTHomePlateFilterListVC () <XLTCouponSwitchViewDelegate, XLTPlateTopSectionCellDelegate>
@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@property (nonatomic, strong) NSArray *plateArray;

@property (nonatomic, strong) XLTCouponSwitchView *letaoCouponSwitchView;
@property(nonatomic, assign) BOOL letaoSwitchOn;
@property (nonatomic, strong) NSMutableArray *listSessionTaskArray;

@end

@implementation XLTHomePlateFilterListVC

- (void)dealloc {
    [self cancelAllGoodsListRequest];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.title = self.plateName;
    [self letaoSetupTopHeadView];
    [self requestFilterOptionsData];
    self.collectionView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
     self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
}

- (void)requestFristPageData {
    [super requestFristPageData];
    if (!self.nonePlateList) {
        [self requestPlateData];
    }
}

- (void)requestFilterPageData {
    [super requestFristPageData];
}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    if(self.plateArray.copy == 0) {
        [super letaoShowLoading];
    }
}

- (void)letaoShowEmptyView {
    // do nothing
    if (self.nonePlateList) {
        [super letaoShowEmptyView];
    }
}

- (void)letaoShowErrorView {
    // do nothing
    if (self.nonePlateList) {
        [super letaoShowErrorView];
    } 
}

- (void)letaoSetupFilterView {
}

- (void)letaoSetupTopHeadView {
    XLTHomeCustomHeadBgView *letaoTopHeadView = [[XLTHomeCustomHeadBgView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XLTHomeCustomHeadView letaoDefaultHeight])];
    letaoTopHeadView.letaobgImageView.hidden = YES;
    letaoTopHeadView.letaoCircleImageView.hidden = YES;
    [self.view insertSubview:letaoTopHeadView belowSubview:self.collectionView];
}

- (void)cancelAllGoodsListRequest {
    @synchronized (self) {
        [self.listSessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.listSessionTaskArray removeAllObjects];
    }
}

- (NSMutableArray *)listSessionTaskArray {
    if(!_listSessionTaskArray) {
        _listSessionTaskArray = [NSMutableArray array];
    }
    return _listSessionTaskArray;
}

- (void)requestPlateData {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoHomeLogic xingletaonetwork_requestHomePlateDataForPlateId:self.letaoCurrentPlateId success:^(NSArray * _Nonnull plateArray) {
        weakSelf.plateArray = plateArray;
        [weakSelf.collectionView reloadData];
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing
    }];
}



- (void)requestFilterOptionsData {
    /*
    if ([self letaoCurrentPlateIdParameter]) {
        if (self.letaoHomeLogic == nil) {
            self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
        }
        if (self.plateArray.count == 0) {
            [self letaoShowLoading];
        }
        __weak typeof(self)weakSelf = self;
        [self.letaoHomeLogic xingletaonetwork_requestPlateFilterOptionsWithPlateId:[self letaoCurrentPlateIdParameter] success:^(NSDictionary * _Nonnull filterInfo) {
            [weakSelf updateFilterOptions:filterInfo];
        } failure:^(NSString * _Nonnull errorMsg) {
            // do nothing
            self.topFilterView.letaoInvalidFilterBtn = NO;
        }];
    }*/
}

- (void)updateFilterOptions:(NSDictionary *)filterInfo {
    /*
    NSArray *itemSource = filterInfo[@"item_source"];
    __block XLTRightFilterType type = XLTRightFilterTypeNone;

    if ([itemSource isKindOfClass:[NSArray class]]) {
        XLTGoodsSupportPlatform supportGoodsPlatform = [XLTAppPlatformManager shareManager].supportGoodsPlatform;
        [itemSource enumerateObjectsUsingBlock:^(NSString *  _Nonnull itemCode, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([itemCode isKindOfClass:[NSString class]]) {
                if ([itemCode isEqualToString:XLTTaobaoPlatformIndicate] && ((supportGoodsPlatform & XLTTaobaoGoodsPlatform) == XLTTaobaoGoodsPlatform)) {
                    type = type | XLTRightFilterTypeTaoBao;
                } else if ([itemCode isEqualToString:XLTTianmaoPlatformIndicate] && ((supportGoodsPlatform & XLTTianmaoGoodsPlatform) == XLTTianmaoGoodsPlatform)) {
                    type = type | XLTRightFilterTypeTianMao;
                } else if ([itemCode isEqualToString:XLTJindongPlatformIndicate] && ((supportGoodsPlatform & XLTJindongGoodsPlatform) == XLTJindongGoodsPlatform)) {
                    type = type | XLTRightFilterTypeJingDong;
                } else if ([itemCode isEqualToString:XLTPDDPlatformIndicate] && ((supportGoodsPlatform & XLTPDDGoodsPlatform) == XLTPDDGoodsPlatform)){
                    type = type | XLTRightFilterTypePDD;
                }
            }
        }];
        type = type | XLTRightFilterTypePrice;
        type = type | XLTRightFilterTypeFreePost;
    }
    self.letaoFilterArray = [XLTRightFilterViewController buildFilterDataArrayWithType:type];
    self.topFilterView.letaoInvalidFilterBtn = NO;*/
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationBarDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}


//排序 item_sell_count-销量 rebate.xkd_amount-返利金 item_price-卷后价 +从小到大 -从大到小 sort 默认排序
//XLTSortTypeComprehensive = 0,     //综合
//XLTSortTypePriceAsc = 1,        //价格升序
//XLTSortTypePriceDesc = 2,        //价格降序
//XLTSortTypeSalesAsc = 3,         //销量升序
//XLTSortTypeSalesDesc = 4,       //销量降序
//XLTSortTypeEarnAsc = 5,         //返利升序
//XLTSortTypeEarnDesc = 6,       //返利降序
- (NSString *)letaoSortValueTypeParameter {
    switch (self.letaoSortValueType) {
        case XLTSortTypeComprehensive:
            return nil;
            break;
        case XLTSortTypePriceAsc:
            return @"+item_price";
            break;
        case XLTSortTypePriceDesc:
            return @"-item_price";
            break;
        case XLTSortTypeSalesAsc:
            return @"+item_sell_count";
            break;
        case XLTSortTypeSalesDesc:
            return @"-item_sell_count";
            break;
        case XLTSortTypeEarnAsc:
            return @"+rebate.xkd_amount";
            break;
        case XLTSortTypeEarnDesc:
            return @"-rebate.xkd_amount";
            break;
            
        default:
            break;
    }
}

- (NSString *)sourceParameter {
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSArray *sourceSectionArray = self.letaoFilterArray.firstObject;
    [sourceSectionArray enumerateObjectsUsingBlock:^(XLTRightFilterItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.isSelected && item.itemCode) {
            [sourceArray addObject:item.itemCode];
        }
    }];
    if (sourceArray.count > 0) {
       return [sourceArray componentsJoinedByString:@","];
    } else {
        return nil;
    }
}

- (NSNumber *)postageParameter {
     NSMutableArray *expressArray = [NSMutableArray array];
     NSArray *expressSectionArray = self.letaoFilterArray.lastObject;
     [expressSectionArray enumerateObjectsUsingBlock:^(XLTRightFilterItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
         if (item.isSelected && item.itemCode) {
             [expressArray addObject:item.itemCode];
         }
     }];
    return expressArray.count >0 ? @1 : nil;
}

- (NSNumber *)startPriceParameter {
    if (self.letaoFilterArray.count > 1) {
        NSArray *expressSectionArray = self.letaoFilterArray[1];
        XLTRightFilterItem *item = expressSectionArray.firstObject;
        if ([item.minPrice isKindOfClass:[NSString class]] && item.minPrice.length) {
            return [NSNumber numberWithInteger:[item.minPrice integerValue]*100];
        }
    }
    return nil;
}

- (NSNumber *)endPriceParameter {
    if (self.letaoFilterArray.count > 1) {
        NSArray *expressSectionArray = self.letaoFilterArray[1];
        XLTRightFilterItem *item = expressSectionArray.firstObject;
        if ([item.maxPrice isKindOfClass:[NSString class]] && item.maxPrice.length) {
            return [NSNumber numberWithInteger:[item.maxPrice integerValue]*100];
        }
    }
    return nil;
}

- (NSString *)letaoCurrentPlateIdParameter{
    return self.letaoCurrentPlateId;
}

- (NSString *)categoryIdParameter{
    return self.categoryId;
}

- (NSString *)letaoStoreIdParameter{
    return nil;
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
     NSString *categoryId = self.categoryId;
    if ([categoryId isKindOfClass:[NSString class]] && categoryId.length > 0) {
        [self letaoFetchCategoryPageDataForIndex:index pageSize:pageSize success:success failed:failed];
    } else {
        [self letaoFetchPlatePageDataForIndex:index pageSize:pageSize success:success failed:failed];
    }
}

- (void)letaoFetchCategoryPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    [self cancelAllGoodsListRequest];
    NSString *categoryId = self.categoryId;
    __weak typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [self.letaoHomeLogic requestHomeCategoryGoodsListDataForIndex:index pageSize:pageSize categoryId:[self categoryIdParameter] sort:[self letaoSortValueTypeParameter] source:[self sourceParameter] postage:[self postageParameter] startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] letaoStoreId:[self letaoStoreIdParameter] hasCoupon:self.letaoSwitchOn success:^(NSArray * _Nonnull goodsArray,NSURLSessionDataTask * task) {
        if ([weakSelf.listSessionTaskArray containsObject:task]) {
            [weakSelf.listSessionTaskArray removeObject:task];
            success(goodsArray);
            if (index == [weakSelf theFirstPageIndex]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
              if ([categoryId isKindOfClass:[NSString class]] &&
                categoryId.length) {
                // 汇报分类商品展示
                NSString *xlt_item_firstcate_id = nil;
                NSString *xlt_item_firstcate_title = nil;
                NSString *xlt_item_secondcate_id = nil;
                NSString *xlt_item_secondcate_title = nil;
                NSString *xlt_item_thirdcate_id = nil;
                NSString *xlt_item_thirdcate_title = nil;
                
                if (self.parentCategoryName && self.parentCategoryId) {
                      xlt_item_firstcate_id = self.parentCategoryId;
                      xlt_item_firstcate_title = self.parentCategoryName;
                }
                
                if ([self.categoryLevel isKindOfClass:[NSNumber class]] && [self.categoryLevel intValue] == 1) {
                    xlt_item_firstcate_id = self.categoryId;
                    xlt_item_firstcate_title = self.plateName;
                } else if ([self.categoryLevel isKindOfClass:[NSNumber class]] && [self.categoryLevel intValue] == 2) {
                    xlt_item_secondcate_id = self.categoryId;
                    xlt_item_secondcate_title = self.plateName;
                } else {
                    xlt_item_thirdcate_id = self.categoryId;
                    xlt_item_thirdcate_title = self.plateName;
                }

                [SDRepoManager xltrepo_trackCategoryGoodsEventWithListCount:weakSelf.letaoPageDataArray.count xlt_item_firstcate_id:xlt_item_firstcate_id xlt_item_firstcate_title:xlt_item_firstcate_title xlt_item_secondcate_id:xlt_item_secondcate_id xlt_item_secondcate_title:xlt_item_secondcate_title xlt_item_thirdcate_id:xlt_item_thirdcate_id xlt_item_thirdcate_title:xlt_item_thirdcate_title];
            }
        }
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
        if ([weakSelf.listSessionTaskArray containsObject:task]) {
            [weakSelf.listSessionTaskArray removeObject:task];
            failed(nil,errorMsg);
        }
    }];
    sessionTask ? [self.listSessionTaskArray  addObject:sessionTask] : nil ;

}


- (void)letaoFetchPlatePageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    [self cancelAllGoodsListRequest];
    NSString *categoryId = self.categoryId;
    __weak typeof(self)weakSelf = self;

    NSURLSessionTask *sessionTask = [self.letaoHomeLogic requestHomePlateGoodsListDataForIndex:index pageSize:pageSize sort:[self letaoSortValueTypeParameter] source:[self sourceParameter] postage:[self postageParameter] startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] letaoStoreId:[self letaoStoreIdParameter] hasCoupon:self.letaoSwitchOn plate:[self letaoCurrentPlateIdParameter] success:^(NSArray * _Nonnull goodsArray,NSURLSessionDataTask * task) {
        if ([weakSelf.listSessionTaskArray containsObject:task]) {
            [weakSelf.listSessionTaskArray removeObject:task];
            success(goodsArray);
            if (index == [weakSelf theFirstPageIndex]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
              if ([categoryId isKindOfClass:[NSString class]] &&
                categoryId.length) {
                // 汇报分类商品展示
                NSString *xlt_item_firstcate_id = nil;
                NSString *xlt_item_firstcate_title = nil;
                NSString *xlt_item_secondcate_id = nil;
                NSString *xlt_item_secondcate_title = nil;
                NSString *xlt_item_thirdcate_id = nil;
                NSString *xlt_item_thirdcate_title = nil;
                
                if (self.parentCategoryName && self.parentCategoryId) {
                      xlt_item_firstcate_id = self.parentCategoryId;
                      xlt_item_firstcate_title = self.parentCategoryName;
                }
                
                if ([self.categoryLevel isKindOfClass:[NSNumber class]] && [self.categoryLevel intValue] == 1) {
                    xlt_item_firstcate_id = self.categoryId;
                    xlt_item_firstcate_title = self.plateName;
                } else if ([self.categoryLevel isKindOfClass:[NSNumber class]] && [self.categoryLevel intValue] == 2) {
                    xlt_item_secondcate_id = self.categoryId;
                    xlt_item_secondcate_title = self.plateName;
                } else {
                    xlt_item_thirdcate_id = self.categoryId;
                    xlt_item_thirdcate_title = self.plateName;
                }

                [SDRepoManager xltrepo_trackCategoryGoodsEventWithListCount:weakSelf.letaoPageDataArray.count xlt_item_firstcate_id:xlt_item_firstcate_id xlt_item_firstcate_title:xlt_item_firstcate_title xlt_item_secondcate_id:xlt_item_secondcate_id xlt_item_secondcate_title:xlt_item_secondcate_title xlt_item_thirdcate_id:xlt_item_thirdcate_id xlt_item_thirdcate_title:xlt_item_thirdcate_title];
            }
        }
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
        if ([weakSelf.listSessionTaskArray containsObject:task]) {
            [weakSelf.listSessionTaskArray removeObject:task];
            failed(nil,errorMsg);
        }
    }];
    sessionTask ? [self.listSessionTaskArray  addObject:sessionTask] : nil ;

}

// CELL
static NSString *const kXLTHomeTopCollectionViewCell = @"XLTHomeTopCollectionViewCell";
static NSString *const kXLTHomeCategoryGoodsCollectionViewCell = @"XLTHomeCategoryGoodsCollectionViewCell";



- (void)letaoListRegisterCells {
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeTopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeTopCollectionViewCell];
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTHomeCategoryGoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCategoryGoodsCollectionViewCell];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 && self.plateArray.count > 0) {
       return 1;
    } else if (section == 1){
       return self.letaoPageDataArray.count;
    } else {
        return 0;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLTHomeTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeTopCollectionViewCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell letaoUpdateCellDataWithInfo:self.plateArray];
        return cell;
    } else {
        XLTHomeCategoryGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCategoryGoodsCollectionViewCell forIndexPath:indexPath];
        if ([self isMemberOfClass:[XLTHomePlateFilterListVC class]]) {
            cell.letaoShowImageFlag = YES;
        }
        NSDictionary *itemInfo = self.letaoPageDataArray[indexPath.row];;
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
         if (kind == UICollectionElementKindSectionHeader) {
             UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier forIndexPath:indexPath];
            if (self.topFilterView == nil) {
                self.topFilterView = [[NSBundle mainBundle]loadNibNamed:@"XLTTopFilterView" owner:self options:nil].lastObject;
             }
             self.topFilterView.delegate = self;
             self.topFilterView.frame = CGRectMake(0, 0, headerView.bounds.size.width, 44.0);
             self.topFilterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
             [headerView addSubview:self.topFilterView];
             
             // 优惠券
             if (self.letaoCouponSwitchView == nil) {
                 self.letaoCouponSwitchView = [[NSBundle mainBundle]loadNibNamed:@"XLTCouponSwitchView" owner:self options:nil].lastObject;
              }
              self.letaoCouponSwitchView.delegate = self;
              self.letaoCouponSwitchView.frame = CGRectMake(0, CGRectGetMaxY(self.topFilterView.frame), headerView.bounds.size.width, 44.0);
              self.letaoCouponSwitchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
              [headerView addSubview:self.letaoCouponSwitchView];
              
             return headerView;
         }
     }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(collectionView.bounds.size.width, 88);
    } else {
        return CGSizeZero;
    }
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    if(indexPath.section == 0) {
        CGFloat itemHeight = floorf((kScreenWidth -20 -20 -30)/4) +33;
        if (self.plateArray.count >4) {
            return CGSizeMake(kScreenWidth -20, itemHeight *2 +15);
        } else {
            return CGSizeMake(kScreenWidth -20, itemHeight+15) ;
        }
    } else if(indexPath.section == 1){
        CGFloat offset = ceilf(((kScreenWidth -375)/39)*15);
        // 因为间距不是等比放大，调整一个修正量offset
        CGFloat height = kScreen_iPhone375Scale(340) - offset;
        return CGSizeMake(collectionView.bounds.size.width/2 -15, height);
    } else {
        return CGSizeZero;
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(section == 0) {
        if (self.plateArray.count > 0) {
            return UIEdgeInsetsMake(10, 10, 10, 10);;
        } else {
            return UIEdgeInsetsZero;
        }
    } else {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(section == 1) {
       return 10;
    }
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
    goodDetailViewController.letaoCurrentPlateId = self.letaoCurrentPlateId;
    NSString *item_source = itemInfo[@"item_source"];
    goodDetailViewController.letaoGoodsSource = item_source;
    NSString *letaoGoodsItemId = itemInfo[@"item_id"];
    goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;

    [self.navigationController pushViewController:goodDetailViewController animated:YES];
    
    
    if ([self.categoryId isKindOfClass:[NSString class]] &&
        self.categoryId.length) {
        // 汇报分类商品展示
        NSString *xlt_item_firstcate_id = nil;
        NSString *xlt_item_firstcate_title = nil;
        NSString *xlt_item_secondcate_id = nil;
        NSString *xlt_item_secondcate_title = nil;
        NSString *xlt_item_thirdcate_id = nil;
        NSString *xlt_item_thirdcate_title = nil;
            
        if (self.parentCategoryName && self.parentCategoryId) {
                xlt_item_firstcate_id = self.parentCategoryId;
                xlt_item_firstcate_title = self.parentCategoryName;
        }
            
        if ([self.categoryLevel isKindOfClass:[NSNumber class]] && [self.categoryLevel intValue] == 1) {
            xlt_item_firstcate_id = self.categoryId;
            xlt_item_firstcate_title = self.plateName;
        } else if ([self.categoryLevel isKindOfClass:[NSNumber class]] && [self.categoryLevel intValue] == 2) {
            xlt_item_secondcate_id = self.categoryId;
            xlt_item_secondcate_title = self.plateName;
        } else {
            xlt_item_thirdcate_id = self.categoryId;
            xlt_item_thirdcate_title = self.plateName;
        }

        [SDRepoManager xltrepo_trackCategoryGoodsSelectedWithInfo:itemInfo xlt_item_firstcate_id:xlt_item_firstcate_id xlt_item_firstcate_title:xlt_item_firstcate_title xlt_item_secondcate_id:xlt_item_secondcate_id xlt_item_secondcate_title:xlt_item_secondcate_title xlt_item_thirdcate_id:xlt_item_thirdcate_id xlt_item_thirdcate_title:xlt_item_thirdcate_title xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
    } else {
        // 模块点击
        [SDRepoManager xltrepo_trackPlatleGoodsSelected:itemInfo xlt_item_firstplatle_id:self.letaoParentPlateId xlt_item_firstplatle_title:self.letaoParentPlateName xlt_item_secondplatle_id:self.letaoCurrentPlateId xlt_item_secondplatle_title:self.plateName xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
    }
}

- (void)letaoCell:(XLTHomeTopCollectionViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.plateArray.count) {
        NSDictionary *plateInfo = self.plateArray[indexPath.item];
        if ([plateInfo isKindOfClass:[NSDictionary class]]) {
            NSString *plateName = plateInfo[@"title"];
            if (![plateName isKindOfClass:[NSString class]]) {
                plateName = @"";
            }
            NSString *letaoCurrentPlateId = plateInfo[@"_id"];
            XLTCategoryFilterListVC *plateFilterListViewController = [[XLTCategoryFilterListVC alloc] init];
            plateFilterListViewController.nonePlateList = YES;
            plateFilterListViewController.letaoCurrentPlateId = letaoCurrentPlateId;
            plateFilterListViewController.plateName = plateName;
            plateFilterListViewController.letaoParentPlateId = self.letaoCurrentPlateId;
            plateFilterListViewController.letaoParentPlateName = self.plateName;
            [self.navigationController pushViewController:plateFilterListViewController animated:YES];
            
            [[XLTRepoDataManager shareManager] repoPlateViewPage:self.letaoCurrentPlateId childPlate:letaoCurrentPlateId];
            
//            [SDRepoManager xltrepo_trackPlatleClickEvent:self.letaoCurrentPlateId xlt_item_id:letaoCurrentPlateId xlt_item_title:plateName];

        }
    }
    

}


- (void)letaoCouponSwitchView:(XLTCouponSwitchView *)topFilterView didSwitchOn:(BOOL)isOn {
    self.letaoSwitchOn = isOn;
    [self requestFristPageData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
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
