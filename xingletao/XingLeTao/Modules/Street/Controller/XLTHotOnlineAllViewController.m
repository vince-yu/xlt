//
//  XLTHotOnlineAllViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHotOnlineAllViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "SDCycleScrollView.h"
#import "XLTAdManager.h"
#import "XLTHomePageLogic.h"
#import "XLTHomeCycleDailyCell.h"
#import "XLTGoodsDetailVC.h"
#import "XLTHotOnlineHeadView.h"
#import "XLTHomePlateContainerVC.h"
#import "XLTHotOnlinenRecommendHeadView.h"
#import "XLTHomeCycleBannerCollectionViewCell.h"
#import "XLTHotOnlinenGoodsCell.h"
#import "XLTRightFilterViewController.h"
#import "XLDStreetLogic.h"

typedef NS_ENUM(NSInteger, XLTCelebritySectionType) {
    XLTCelebritySectionCycleBannerType = 0,
    XLTCelebritySectionDailyType,
    XLTCelebritySectionRecommendGoodsType,
};

@interface XLTHotOnlineAllViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate, XLTHomeDailyRecommendCellDelegate,XLTHotOnlinenRecommendHeadViewDelegate,XLTRightFilterViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;

@property (nonatomic, strong) SDCycleScrollView *letaoCycleScrollView;
@property (nonatomic, assign) NSInteger letaoCurrentPageIndex;
@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@property (nonatomic, strong) NSArray *letaoFilterArray;

@property (nonatomic, strong) NSMutableArray *letaoTaskArray;
@property (nonatomic, assign) BOOL letaoIsLoadingState;

@end

@implementation XLTHotOnlineAllViewController
#define kRecommendGoodsPageSize 10
#define ktFristRecommendGoodsPageIndex 1

- (void)dealloc {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoPageDataArray = [NSMutableArray array];
        for (int k =0; k <= XLTCelebritySectionRecommendGoodsType; k ++){
            [self.letaoPageDataArray addObject:@[].mutableCopy];
        }
        self.letaoCurrentPageIndex = ktFristRecommendGoodsPageIndex;
        self.letaoTaskArray = [NSMutableArray array];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupContentCollectionView];
    [self letaoSetupTopImageView];
    [self xingletaonetwork_fetchAdData];
    [self letaoFetchFristRecommendPageData];
    [self requestHomeDailyRecommendData];
}

//推荐header
static NSString *const kXLTHotOnlinenRecommendHeadView = @"XLTHotOnlinenRecommendHeadView";

- (void)letaoSetupContentCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.sectionFootersPinToVisibleBounds = NO;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoListRegisterCells:_collectionView];
    [self letaoSetupRefreshHeader];
    _collectionView.mj_header = _letaoRefreshHeader;
    [self letaoSetupRefreshAutoFooter];
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
       // 首次隐藏
    _collectionView.mj_footer.hidden = YES;

    [self.view addSubview:_collectionView];
}



- (void)letaoSetupRefreshHeader {
    if (_letaoRefreshHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf letaoTriggerRefresh];
        }];
    }
}

- (void)letaoTriggerRefresh {
    if (_letaoIsLoadingState) {
        return;
    }
    _letaoIsLoadingState = YES;
    
    [self xingletaonetwork_fetchAdData];
    [self letaoFetchFristRecommendPageData];
    [self requestHomeDailyRecommendData];
}

- (void)letaoTriggerLoadMore {
    if(_letaoIsLoadingState) {
        return ;
    }
    _letaoIsLoadingState = YES;
    NSInteger requestIndex = _letaoCurrentPageIndex +1;
    [self letaoFetchRecommendPagePageDataForIndex:requestIndex pageSize:kRecommendGoodsPageSize];;
}

- (void)letaoSetupRefreshAutoFooter {
    if (_letaoRefreshAutoFooter == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshAutoFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf letaoTriggerLoadMore];
        }];
        _letaoRefreshAutoFooter.triggerAutomaticallyRefreshPercent = - 5.0;
        _letaoRefreshAutoFooter.autoTriggerTimes = -1;
        [_letaoRefreshAutoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
        _letaoRefreshAutoFooter.stateLabel.textColor = [UIColor colorWithHex:0xFFa9a9a9];
        _letaoRefreshAutoFooter.stateLabel.font = [UIFont letaoRegularFontWithSize:12.0];
    }
}


- (void)requestHomeDailyRecommendData {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoHomeLogic xingletaonetwork_requestHomeDailyRecommendDataSuccess:^(NSArray * _Nonnull dailyRecommendArray) {
        if ([dailyRecommendArray isKindOfClass:[NSArray class]]) {
            [weakSelf.letaoPageDataArray replaceObjectAtIndex:XLTCelebritySectionDailyType withObject:@[dailyRecommendArray]];
             [UIView performWithoutAnimation:^{
                 NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XLTCelebritySectionDailyType];
                 [weakSelf.collectionView reloadSections:reloadSet];
             }];
        }

    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing;
        [self showTipMessage:errorMsg];
    }];
}

- (void)xingletaonetwork_fetchAdData {
    __weak typeof(self)weakSelf = self;
    [[XLTAdManager shareManager] xingletaonetwork_requestAdListWithPosition:@"8" success:^(NSArray * _Nonnull adArray) {
        [weakSelf letaoUpdateAdSectionData:adArray];
        [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing;
        [weakSelf letaoRemoveLoading];
    }];
}



- (void)letaoSetupTopImageView {
    CGFloat letaobgImageViewHeight = [XLTHotOnlineHeadView headViewDefaultHeight];
    CGFloat bottomHeight = (42+35);
    UIImageView *letaobgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottomHeight - letaobgImageViewHeight, self.view.bounds.size.width, [XLTHotOnlineHeadView headViewDefaultHeight])];
    
    UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFFAE01]] gradientType:0 imgSize:letaobgImageView.bounds.size];
    letaobgImageView.image = bgImage;
    [self.view insertSubview:letaobgImageView belowSubview:self.collectionView];
    
    UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
    CGFloat bottomCircleHeight = ceilf(self.view.bounds.size.width/375*35);
    UIImageView *bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
    bottomCircleImageView.frame = CGRectMake(0, CGRectGetMaxY(letaobgImageView.frame) - bottomCircleHeight, self.view.bounds.size.width, bottomCircleHeight);
    [self.view insertSubview:bottomCircleImageView belowSubview:self.collectionView];

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return XLTCelebritySectionRecommendGoodsType +1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionArray = self.letaoPageDataArray[section];
    if ([sectionArray isKindOfClass:[NSArray class]]) {
       return sectionArray.count;
    } else {
       return 0;
    }
}


static NSString *const kXLTHomeCycleBannerCollectionViewCell = @"XLTHomeCycleBannerCollectionViewCell";

// 每日推荐轮播
static NSString *const kXLTHomeDailyRecommendCell = @"XLTHomeDailyRecommendCell";
//列表
static NSString *const kXLTHotOnlinenGoodsCell = @"XLTHotOnlinenGoodsCell";


- (void)letaoListRegisterCells:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"XLTHomeCycleBannerCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell];
    
    
    // 每日推荐轮播
    [collectionView registerNib:[UINib nibWithNibName:@"XLTHomeDailyRecommendCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeDailyRecommendCell];

    //列表
    [collectionView registerNib:[UINib nibWithNibName:@"XLTHotOnlinenGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHotOnlinenGoodsCell];
    
    [collectionView registerNib:[UINib nibWithNibName:kXLTHotOnlinenRecommendHeadView bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTHotOnlinenRecommendHeadView];


}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLTCelebritySectionCycleBannerType) {
        XLTHomeCycleBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell forIndexPath:indexPath];
        return cell;
    } else if(indexPath.section == XLTCelebritySectionDailyType) {
        XLTHomeCycleDailyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeDailyRecommendCell forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    } else  {
        XLTHotOnlinenGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHotOnlinenGoodsCell forIndexPath:indexPath];
        [cell letaoUpdateCellDataWithInfo:[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray]];
        return cell;
    }
}




//item大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLTCelebritySectionCycleBannerType) {
        return CGSizeMake(collectionView.bounds.size.width -20, kScreen_iPhone375Scale(115));
    }  else if(indexPath.section == XLTCelebritySectionDailyType) {
        return CGSizeMake(collectionView.bounds.size.width, 35);
    } else if(indexPath.section == XLTCelebritySectionRecommendGoodsType) {
        return CGSizeMake(collectionView.bounds.size.width, 157);
    }
    return CGSizeMake(collectionView.bounds.size.width, 35);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if (indexPath.section == XLTCelebritySectionCycleBannerType) {
        if (self.letaoCycleScrollView == nil) {
            self.letaoCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, collectionView.bounds.size.width -20, kScreen_iPhone375Scale(115)) delegate:self placeholderImage:nil];
            self.letaoCycleScrollView.backgroundColor = [UIColor colorWithHex:0xFFF3AFAD];
            self.letaoCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.letaoCycleScrollView.currentPageDotColor = [UIColor whiteColor];
            self.letaoCycleScrollView.pageDotColor = [UIColor colorWithWhite:1.0 alpha:0.48];
            self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        }
        self.letaoCycleScrollView.imageURLStringsGroup = [self letaoBuildCycleViewImageArray];

        [cell.contentView addSubview:self.letaoCycleScrollView];
    } else if (indexPath.section == XLTCelebritySectionDailyType) {
        XLTHomeCycleDailyCell *dailyCycleCell = (XLTHomeCycleDailyCell *)cell;
        if ([dailyCycleCell isKindOfClass:[XLTHomeCycleDailyCell class]]) {
            dailyCycleCell.delegate = self;
        }
    }
    return cell;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSArray *sectionArray = self.letaoPageDataArray[section];
    if (sectionArray.count > 0) {
        if (section == XLTCelebritySectionCycleBannerType) {
            return UIEdgeInsetsMake(0, 10, 15, 10);
        } else if (section == XLTCelebritySectionDailyType) {
            return UIEdgeInsetsMake(0, 0, 15, 0);
        }
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == XLTCelebritySectionRecommendGoodsType) {
        return CGSizeMake(collectionView.bounds.size.width, 44);
    }
     return CGSizeZero;
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == XLTCelebritySectionRecommendGoodsType) {
         if (kind == UICollectionElementKindSectionHeader) {
             XLTHotOnlinenRecommendHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTHotOnlinenRecommendHeadView forIndexPath:indexPath];
             headerView.delegate = self;
             return headerView;
         }
     }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if (indexPath.section == XLTCelebritySectionRecommendGoodsType) {
           if ([itemInfo isKindOfClass:[NSDictionary class]]) {
               NSString *letaoGoodsId = itemInfo[@"_id"];
               NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
               NSString *item_source = itemInfo[@"item_source"];
               XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
               goodDetailViewController.letaoPassDetailInfo = itemInfo;
               goodDetailViewController.letaoGoodsId = letaoGoodsId;
               goodDetailViewController.letaoStoreId = letaoStoreId;
               goodDetailViewController.letaoParentPlateId = self.letaoParentPlateId;
               goodDetailViewController.letaoCurrentPlateId = @"500001";
               goodDetailViewController.letaoGoodsSource = item_source;
               goodDetailViewController.letaoIsCustomPlate = YES;
               NSString *letaoGoodsItemId = itemInfo[@"item_id"];
               goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
               [self.navigationController pushViewController:goodDetailViewController animated:YES];
               // 汇报事件
               [SDRepoManager xltrepo_trackPlatleGoodsSelected:itemInfo
                                                     xlt_item_firstplatle_id:self.letaoParentPlateId
                                                  xlt_item_firstplatle_title:@"红人街"
                                                    xlt_item_secondplatle_id:nil
                                                 xlt_item_secondplatle_title:@"网红爆款"
                                        xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
           }
       }
}

- (BOOL)letaoIsPlateBannerItem:(NSDictionary *)intemInfo {
    if ([intemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *bannerItem = intemInfo[@"show_image"];
        if ([bannerItem isKindOfClass:[NSDictionary class]]) {
            NSNumber *status = bannerItem[@"status"];
            return ([status isKindOfClass:[NSNumber class]] && [status boolValue]);
        }
    }
    return NO;
}

- (NSDictionary *)letaoSafeDataAtIndexPath:(NSIndexPath *)indexPath
                            letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if ([letaoPageDataArray isKindOfClass:[NSArray class]]) {
        if (indexPath.section < letaoPageDataArray.count) {
            NSArray *sectionArray = letaoPageDataArray[indexPath.section];
            if ([sectionArray isKindOfClass:[NSArray class]]) {
                if (indexPath.row < sectionArray.count) {
                    return sectionArray[indexPath.row];
                }
            }
        }
    }
    return nil;
}

#pragma mark -  Filter

- (void)letaoStartFilter {
    XLTRightFilterViewController *filterViewController = [[XLTRightFilterViewController alloc] initWithNibName:@"XLTRightFilterViewController" bundle:[NSBundle mainBundle]];
    filterViewController.letaoPageDataArray = self.letaoFilterArray;
    filterViewController.delegate = self;
    filterViewController.view.hidden = YES;
    [self sourceViewController].definesPresentationContext = YES;
    filterViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[self sourceViewController] presentViewController:filterViewController animated:NO completion:^{
        filterViewController.view.hidden = NO;
        filterViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        filterViewController.contentBgView.transform = CGAffineTransformMakeTranslation(kScreenWidth -98, 0);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            filterViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        filterViewController.contentBgView.transform=CGAffineTransformMakeTranslation(0, 0);
              } completion:^(BOOL finished) {
                  
              }];
    }];
}

- (UIViewController *)sourceViewController {
    return self.navigationController;
}

- (void)letaoFilterVC:(XLTRightFilterViewController *)filterViewController didChangeFilterData:(NSArray *)letaoFilterArray {
    // set filterInfo
    self.letaoFilterArray = letaoFilterArray;
    [self letaoFetchFristRecommendPageData];
}

#pragma mark -  RecommendGoods

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

- (void)letaoFetchFristRecommendPageData {
    [self letaoFetchRecommendPagePageDataForIndex:ktFristRecommendGoodsPageIndex pageSize:kRecommendGoodsPageSize];
}


- (void)letaoFetchRecommendPagePageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize {
    [self letaoCancelAllTaks];
     __weak typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [XLDStreetLogic xingletaonetwork_requestRedGoodsListWithIndex:index pageSize:pageSize sourece:[self sourceParameter] sign:nil categoryId:nil postage:[self postageParameter] t:nil  startPrice:[self startPriceParameter] endPrice:[self endPriceParameter] success:^(id  _Nonnull goodArray, NSURLSessionDataTask * _Nonnull task) {
        if ([weakSelf.letaoTaskArray containsObject:task]) {
            [weakSelf.letaoTaskArray removeObject:task];
            [weakSelf letaoReceivedGoodsDataSuccess:goodArray andIndex:index];
            if (index == ktFristRecommendGoodsPageIndex) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                });
            }
        }
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
        if ([weakSelf.letaoTaskArray containsObject:task]) {
            [weakSelf.letaoTaskArray removeObject:task];
            [weakSelf letaoReceivedGoodsDataError:nil tipMessage:errorMsg];
        }
    }];
    sessionTask ? [self.letaoTaskArray  addObject:sessionTask] : nil ;
}


- (void)letaoCancelAllTaks {
    @synchronized (self) {
        [self.letaoTaskArray enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.letaoTaskArray removeAllObjects];
    }
}


- (void)letaoReceivedGoodsDataError:(NSError * _Nullable)error tipMessage:(NSString * _Nullable)tipMessage {
    [self letaoRemoveMJLoadingsStatus];
    [self letaoRemoveLoading];
    if ([tipMessage isKindOfClass:[NSString class]] && tipMessage.length > 0){
        [self showTipMessage:tipMessage];
    } else {
        [self showTipMessage:NetWork_NotReachable];
    }
}

- (void)letaoReceivedGoodsDataSuccess:(NSArray *)letaoPageDataArray andIndex:(NSInteger)index {
    if (index == ktFristRecommendGoodsPageIndex) {
        [self letaoReloadRecommendData:letaoPageDataArray];
    } else {
        [self letaoAddMoreRecommendData:letaoPageDataArray];
    }
    
    [self letaoRemoveLoading];
    
    [self letaoStopRefreshState];
    if (self.letaoPageDataArray.count > 0) {
        if(letaoPageDataArray.count < 1) {
            [self letaoStopLoadMoreStateWithNoMoreData];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.collectionView.mj_insetT + self.collectionView.mj_contentH <= self.collectionView.mj_h) {
                    self.collectionView.mj_footer.hidden =  (self.letaoPageDataArray.count == 0);
                    [self.letaoRefreshAutoFooter beginRefreshing];
                } else {
                    [self letaoStopLoadMoreState];
                }
            });
        }
    } else {
        [self letaoStopLoadMoreState];
    }
    
    // 没有数据的时候隐藏mj_footer
    self.collectionView.mj_footer.hidden =  (self.letaoPageDataArray.count == 0);
    
    self.letaoCurrentPageIndex = index;
}

- (void)letaoEndRefreshState {
    [_letaoRefreshHeader endRefreshing];
}

- (void)letaoRemoveMJLoadingsStatus {
    [self letaoStopRefreshState];
    [self letaoStopLoadMoreState];
}

- (void)letaoStopLoadMoreStateWithNoMoreData {
    [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    _letaoIsLoadingState = NO;
}


- (void)letaoStopRefreshState {
    [_letaoRefreshHeader endRefreshing];
    _letaoIsLoadingState = NO;
}

- (void)letaoStopLoadMoreState {
    [_letaoRefreshAutoFooter endRefreshing];
    _letaoIsLoadingState = NO;
}

- (void)letaoReloadRecommendData:(NSArray *)letaoPageDataArray {
    if ([letaoPageDataArray isKindOfClass:[NSArray class]]) {
        [self.letaoPageDataArray replaceObjectAtIndex:XLTCelebritySectionRecommendGoodsType withObject:letaoPageDataArray.mutableCopy];
         [UIView performWithoutAnimation:^{
             NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XLTCelebritySectionRecommendGoodsType];
             [self.collectionView reloadSections:reloadSet];
         }];
    }
}

- (void)letaoAddMoreRecommendData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        NSMutableArray *recommendGoods = @[].mutableCopy;
        NSArray *recommendGoodsSectionArray = self.letaoPageDataArray[XLTCelebritySectionRecommendGoodsType];
        if ([recommendGoodsSectionArray isKindOfClass:[NSArray class]]) {
            [recommendGoods addObjectsFromArray:recommendGoodsSectionArray];
        }
        [recommendGoods addObjectsFromArray:letaoPageDataArray];
        [self.letaoPageDataArray replaceObjectAtIndex:XLTCelebritySectionRecommendGoodsType withObject:recommendGoods];
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XLTCelebritySectionRecommendGoodsType];
            [self.collectionView reloadSections:reloadSet];
        }];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:XLTCelebritySectionCycleBannerType];
    NSArray *itemArray = (NSArray *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if ([itemArray isKindOfClass:[NSArray class]] && index < itemArray.count) {
        NSDictionary *itemInfo = itemArray[index];
        [[XLTAdManager shareManager] adJumpWithInfo:itemInfo sourceController:self];
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *adId = itemInfo[@"_id"];
            [[XLTAdManager shareManager] repoAdClickWitdAdId:adId];
        }
    }

}

#pragma mark -  AD


- (void)letaoUpdateAdSectionData:(NSArray *)adArray {
    NSArray *cycleAdArray = adArray;
    if (![cycleAdArray isKindOfClass:[NSArray class]]) {
        cycleAdArray = [NSArray new];
    }
    NSArray *sectionAdArray = (cycleAdArray.count == 0 ? @[] : @[cycleAdArray]);
    [self.letaoPageDataArray replaceObjectAtIndex:XLTCelebritySectionCycleBannerType withObject:sectionAdArray];
    [self.collectionView reloadData];
}

- (NSArray *)letaoBuildCycleViewImageArray {
    NSArray *cycleAdArray = self.letaoPageDataArray[XLTCelebritySectionCycleBannerType];
    NSArray *adArray = cycleAdArray.firstObject;
    if ([adArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *letaoBuildCycleViewImageArray = [NSMutableArray array];
        [adArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *image = @"";
            if ([info isKindOfClass:[NSDictionary class]]) {
                image = info[@"image"];
            }
            [letaoBuildCycleViewImageArray addObject:image];
        }];
        return letaoBuildCycleViewImageArray;
    }
    return @[];
}




#pragma mark -  XLTHomeDailyRecommendCellDelegate
- (void)letaoDailyCell:(XLTHomeCycleDailyCell *)cell didSelectedItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:XLTCelebritySectionDailyType];
    NSArray *itemArray = (NSArray *)[self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if ([itemArray isKindOfClass:[NSArray class]] && index < itemArray.count) {
        NSDictionary *itemInfo = itemArray[index];
        NSString *letaoGoodsId = itemInfo[@"_id"];
        NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
        XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
        goodDetailViewController.letaoPassDetailInfo = itemInfo;
        goodDetailViewController.letaoGoodsId = letaoGoodsId;
        goodDetailViewController.letaoStoreId = letaoStoreId;
        goodDetailViewController.letaoParentPlateId = self.letaoParentPlateId;
        goodDetailViewController.letaoCurrentPlateId = @"500001";
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
                                          xlt_item_secondplatle_title:@"网红爆款"
                                 xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
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
