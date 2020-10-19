//
//  XLTFineGoodsViewController.m
//  XingKouDai
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTFineGoodsViewController.h"
#import "XLTGoodsDetailVC.h"
#import "XLTHotOnlineHeadView.h"
#import "XLTSearchViewController.h"
#import "XLTBigVGoodsListVC.h"
#import "SDCycleScrollView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTAdManager.h"
#import "XLTFineGoodsCell.h"
#import "XLTHomeCycleBannerCollectionViewCell.h"
#import "XLDStreetLogic.h"
#import "NSString+Size.h"

typedef NS_ENUM(NSInteger, XLTCelebritySectionType) {
    XLTGoodThingSectionCycleBannerType = 0,
    XLTGoodThingSectionGoodsType,
};

@interface XLTFineGoodsViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) XLTHotOnlineHeadView *letaoTopHeadView;
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;

@property (nonatomic, strong) SDCycleScrollView *letaoCycleScrollView;
@property (nonatomic, assign) NSInteger letaoCurrentPageIndex;
@property (nonatomic, assign) BOOL letaoIsLoadingState;

@end

@implementation XLTFineGoodsViewController
#define kRecommendGoodsPageSize 10
#define ktFristRecommendGoodsPageIndex 1

- (void)dealloc {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoPageDataArray = [NSMutableArray array];
        for (int k =0; k <= XLTGoodThingSectionGoodsType; k ++){
            [self.letaoPageDataArray addObject:@[].mutableCopy];
        }
        self.letaoCurrentPageIndex = ktFristRecommendGoodsPageIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupContentCollectionView];
    [self letaoSetupTopImageView];
    [self letaoSetupTopHeadView];
    [self letaoShowLoading];
    [self xingletaonetwork_fetchAdData];
    [self letaoFetchFristRecommendPageData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    
    [[XLTRepoDataManager shareManager] repoRedStreetWithPlate:self.letaoParentPlateId childPlate:@"500004"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
    [self.view bringSubviewToFront:self.letaoTopHeadView];
    [self.view bringSubviewToFront:self.collectionView];
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

- (void)xingletaonetwork_fetchAdData {
    __weak typeof(self)weakSelf = self;
    [[XLTAdManager shareManager] xingletaonetwork_requestAdListWithPosition:@"9" success:^(NSArray * _Nonnull adArray) {
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
    return XLTGoodThingSectionGoodsType +1;
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
//列表
static NSString *const kXLTFineGoodsCell = @"XLTFineGoodsCell";


- (void)letaoListRegisterCells:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"XLTHomeCycleBannerCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell];

    //列表
    [collectionView registerNib:[UINib nibWithNibName:kXLTFineGoodsCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTFineGoodsCell];

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLTGoodThingSectionCycleBannerType) {
        XLTHomeCycleBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTHomeCycleBannerCollectionViewCell forIndexPath:indexPath];
        return cell;
    } else {
        XLTFineGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTFineGoodsCell forIndexPath:indexPath];
        NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:letaoPageDataArray];
        [cell letaoUpdateCellDataWithInfo:itemInfo];
        return cell;
    }
}

//item大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               letaoPageDataArray:(NSArray *)letaoPageDataArray {
    if(indexPath.section == XLTGoodThingSectionCycleBannerType) {
        return CGSizeMake(collectionView.bounds.size.width -20, kScreen_iPhone375Scale(115));
    }  else if(indexPath.section == XLTGoodThingSectionGoodsType) {
        NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
        CGFloat offset = 0;
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *recommend_content = itemInfo[@"recommend_content"];
            if ([recommend_content isKindOfClass:[NSString class]] && recommend_content.length > 0) {
                offset = [recommend_content sizeWithFont:[UIFont letaoRegularFontWithSize:13] maxSize:CGSizeMake(collectionView.bounds.size.width - 40, CGFLOAT_MAX)].height +20.0;
            }
        }
        return CGSizeMake(collectionView.bounds.size.width -20, 155 +ceilf(offset));
    }
    return CGSizeMake(collectionView.bounds.size.width, 35);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if (indexPath.section == XLTGoodThingSectionCycleBannerType) {
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
    }
    return cell;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSArray *sectionArray = self.letaoPageDataArray[section];
    if (sectionArray.count > 0) {
        return UIEdgeInsetsMake(0, 10, 15, 10);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;

}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self letaoSafeDataAtIndexPath:indexPath letaoPageDataArray:self.letaoPageDataArray];
    if (indexPath.section == XLTGoodThingSectionGoodsType) {
           if ([itemInfo isKindOfClass:[NSDictionary class]]) {
               NSDictionary *goodsInfo = itemInfo[@"good_info"];
               if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
                   NSString *letaoGoodsId = goodsInfo[@"_id"];
                   NSString *letaoStoreId = goodsInfo[@"seller_shop_id"];
                   XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
                   goodDetailViewController.letaoPassDetailInfo = itemInfo;
                   goodDetailViewController.letaoGoodsId = letaoGoodsId;
                   goodDetailViewController.letaoStoreId = letaoStoreId;
                   goodDetailViewController.letaoParentPlateId = self.letaoParentPlateId;
                   goodDetailViewController.letaoCurrentPlateId = @"500004";
                   goodDetailViewController.letaoIsCustomPlate = YES;
                   NSString *item_source = goodsInfo[@"item_source"];
                   goodDetailViewController.letaoGoodsSource = item_source;
                   NSString *letaoGoodsItemId = itemInfo[@"item_id"];
                   goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
                   [self.navigationController pushViewController:goodDetailViewController animated:YES];    // 汇报事件
                   [SDRepoManager xltrepo_trackPlatleGoodsSelected:goodsInfo
                                                         xlt_item_firstplatle_id:self.letaoParentPlateId
                                                      xlt_item_firstplatle_title:@"红人街"
                                                        xlt_item_secondplatle_id:nil
                                                     xlt_item_secondplatle_title:@"好物说"
                                                          xlt_item_good_position:[NSNumber numberWithInteger:indexPath.row + 1]];
               }

           }
       }
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

#pragma mark -  Request
- (void)letaoFetchFristRecommendPageData {
    [self letaoFetchRecommendPagePageDataForIndex:ktFristRecommendGoodsPageIndex pageSize:kRecommendGoodsPageSize];
}


- (void)letaoFetchRecommendPagePageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize {
     __weak typeof(self)weakSelf = self;
    [XLDStreetLogic xingletaonetwork_requestGoodItemWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull goodsArray) {
        [weakSelf letaoReceivedGoodsDataSuccess:goodsArray andIndex:index];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf letaoReceivedGoodsDataError:nil tipMessage:errorMsg];
    }];
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
        [self.letaoPageDataArray replaceObjectAtIndex:XLTGoodThingSectionGoodsType withObject:letaoPageDataArray.mutableCopy];
         [UIView performWithoutAnimation:^{
             NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XLTGoodThingSectionGoodsType];
             [self.collectionView reloadSections:reloadSet];
         }];
    }
}

- (void)letaoAddMoreRecommendData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        NSMutableArray *recommendGoods = @[].mutableCopy;
        NSArray *recommendGoodsSectionArray = self.letaoPageDataArray[XLTGoodThingSectionGoodsType];
        if ([recommendGoodsSectionArray isKindOfClass:[NSArray class]]) {
            [recommendGoods addObjectsFromArray:recommendGoodsSectionArray];
        }
        [recommendGoods addObjectsFromArray:letaoPageDataArray];
        [self.letaoPageDataArray replaceObjectAtIndex:XLTGoodThingSectionGoodsType withObject:recommendGoods];
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XLTGoodThingSectionGoodsType];
            [self.collectionView reloadSections:reloadSet];
        }];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:XLTGoodThingSectionCycleBannerType];
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
    [self.letaoPageDataArray replaceObjectAtIndex:XLTGoodThingSectionCycleBannerType withObject:sectionAdArray];
    [self.collectionView reloadData];
}

- (NSArray *)letaoBuildCycleViewImageArray {
    NSArray *cycleAdArray = self.letaoPageDataArray[XLTGoodThingSectionCycleBannerType];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
