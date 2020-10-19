//
//  XKDExplosionViewController.m
//  XingKouDai
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XKDGoodThingViewController.h"
#import "XKDGoodDetailViewController.h"
#import "XKDExplosionHeadView.h"
#import "XKDSearchViewController.h"
#import "XKDDaVContainerViewController.h"
#import "SDCycleScrollView.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XKDAdManager.h"
#import "XKDGoodThingCell.h"
#import "XKDHomeCycleBannerCell.h"
#import "XKDStreetLogic.h"
#import "NSString+Size.h"

typedef NS_ENUM(NSInteger, XKDExplosionSectionType) {
    XKDGoodThingSectionCycleBannerType = 0,
    XKDGoodThingSectionGoodsType,
};

@interface XKDGoodThingViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) XKDExplosionHeadView *homeHeadView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshNormalHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshAutoNormalFooter;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, assign) NSInteger recommendGoodsPageIndex;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation XKDGoodThingViewController
#define kRecommendGoodsPageSize 10
#define ktFristRecommendGoodsPageIndex 1

- (void)dealloc {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        for (int k =0; k <= XKDGoodThingSectionGoodsType; k ++){
            [self.dataArray addObject:@[].mutableCopy];
        }
        self.recommendGoodsPageIndex = ktFristRecommendGoodsPageIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadContentCollectionView];
    [self buildTopBgImageView];
    [self bulidHomeHeadView];
    [self showLoadingView];
    [self requestAdInfo];
    [self requestFristRecommendGoodsPageData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self xkd_hiddenNavigationBar:YES];
    
    [[XKDRepoManager shareManager] repoRedStreetWithPlate:self.rootPlateId childPlate:@"500004"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)showLoadingView {
    self.loadingViewBgColor = [UIColor clearColor];
    [super showLoadingView];
    [self.view bringSubviewToFront:self.homeHeadView];
    [self.view bringSubviewToFront:self.collectionView];
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


- (void)loadContentCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.sectionFootersPinToVisibleBounds = NO;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self registerCells:_collectionView];
    [self initRefreshNormalHeader];
    _collectionView.mj_header = _refreshNormalHeader;
    [self initRefreshAutoNormalFooter];
    _collectionView.mj_footer = _refreshAutoNormalFooter;
       // 首次隐藏
    _collectionView.mj_footer.hidden = YES;

    [self.view addSubview:_collectionView];
}



- (void)initRefreshNormalHeader {
    if (_refreshNormalHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _refreshNormalHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf triggerRefresh];
        }];
    }
}

- (void)triggerRefresh {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    
    [self requestAdInfo];
    [self requestFristRecommendGoodsPageData];
}

- (void)triggerLoadMore {
    if(_isLoading) {
        return ;
    }
    _isLoading = YES;
    NSInteger requestIndex = _recommendGoodsPageIndex +1;
    [self requestRecommendGoodsPageDataForIndex:requestIndex pageSize:kRecommendGoodsPageSize];;
}

- (void)initRefreshAutoNormalFooter {
    if (_refreshAutoNormalFooter == nil) {
        __weak __typeof(self)weakSelf = self;
        _refreshAutoNormalFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf triggerLoadMore];
        }];
        [_refreshAutoNormalFooter setTitle:@"———— 已经到底了 ————" forState:MJRefreshStateNoMoreData];
    }
}

- (void)requestAdInfo {
    __weak typeof(self)weakSelf = self;
    [[XKDAdManager shareManager] fetchAdListWithPosition:@"9" success:^(NSArray * _Nonnull adArray) {
        [weakSelf updateAdSection:adArray];
        [weakSelf removeLoadingView];
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing;
        [weakSelf removeLoadingView];
    }];
}



- (void)buildTopBgImageView {
    CGFloat bgImageViewHeight = [XKDExplosionHeadView headViewDefaultHeight];
    CGFloat bottomHeight = (42+35);
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottomHeight - bgImageViewHeight, self.view.bounds.size.width, [XKDExplosionHeadView headViewDefaultHeight])];
    
    UIImage *bgImage  = [XKDExplosionHeadView gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFF42749],[UIColor colorWithHex:0xFFF84C72]] gradientType:0 imgSize:bgImageView.bounds.size];
    bgImageView.image = bgImage;
    [self.view insertSubview:bgImageView belowSubview:self.collectionView];
    
    UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
    CGFloat bottomCircleHeight = ceilf(self.view.bounds.size.width/375*35);
    UIImageView *bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
    bottomCircleImageView.frame = CGRectMake(0, CGRectGetMaxY(bgImageView.frame) - bottomCircleHeight, self.view.bounds.size.width, bottomCircleHeight);
    [self.view insertSubview:bottomCircleImageView belowSubview:self.collectionView];

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return XKDGoodThingSectionGoodsType +1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionArray = self.dataArray[section];
    if ([sectionArray isKindOfClass:[NSArray class]]) {
       return sectionArray.count;
    } else {
       return 0;
    }
}


static NSString *const kXKDHomeCycleBannerCell = @"kXKDHomeCycleBannerCell";
//列表
static NSString *const kXKDGoodThingCell = @"XKDGoodThingCell";


- (void)registerCells:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"XKDHomeCycleBannerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXKDHomeCycleBannerCell];

    //列表
    [collectionView registerNib:[UINib nibWithNibName:kXKDGoodThingCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXKDGoodThingCell];

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                dataArray:(NSArray *)dataArray {
    if(indexPath.section == XKDGoodThingSectionCycleBannerType) {
        XKDHomeCycleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXKDHomeCycleBannerCell forIndexPath:indexPath];
        NSDictionary *itemInfo = [self safeDataAtIndexPath:indexPath dataArray:dataArray];
        [cell updateCellData:itemInfo];
        return cell;
    } else {
        XKDGoodThingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXKDGoodThingCell forIndexPath:indexPath];
        NSDictionary *itemInfo = [self safeDataAtIndexPath:indexPath dataArray:dataArray];
        [cell updateCellData:itemInfo];
        return cell;
    }
}

//item大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               dataArray:(NSArray *)dataArray {
    if(indexPath.section == XKDGoodThingSectionCycleBannerType) {
        return CGSizeMake(collectionView.bounds.size.width -20, kScreen_iPhone375Scale(115));
    }  else if(indexPath.section == XKDGoodThingSectionGoodsType) {
        NSDictionary *itemInfo = [self safeDataAtIndexPath:indexPath dataArray:self.dataArray];
        CGFloat offset = 0;
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *recommend_content = itemInfo[@"recommend_content"];
            if ([recommend_content isKindOfClass:[NSString class]] && recommend_content.length > 0) {
                offset = [recommend_content sizeWithFont:[UIFont xkd_RegularFontWithSize:13] maxSize:CGSizeMake(collectionView.bounds.size.width - 40, CGFLOAT_MAX)].height +20.0;
            }
        }
        return CGSizeMake(collectionView.bounds.size.width -20, 155 +ceilf(offset));
    }
    return CGSizeMake(collectionView.bounds.size.width, 35);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath dataArray:self.dataArray];
    if (indexPath.section == XKDGoodThingSectionCycleBannerType) {
        if (self.cycleScrollView == nil) {
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, collectionView.bounds.size.width -20, kScreen_iPhone375Scale(115)) delegate:self placeholderImage:nil];
            self.cycleScrollView.backgroundColor = [UIColor colorWithHex:0xFFF3AFAD];
            self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            self.cycleScrollView.currentPageDotColor = [UIColor whiteColor];
            self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        }
        self.cycleScrollView.imageURLStringsGroup = [self cycleImageArray];

        [cell.contentView addSubview:self.cycleScrollView];
    }
    return cell;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath dataArray:self.dataArray];
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSArray *sectionArray = self.dataArray[section];
    if (sectionArray.count > 0) {
        return UIEdgeInsetsMake(0, 10, 15, 10);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;

}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = [self safeDataAtIndexPath:indexPath dataArray:self.dataArray];
    if (indexPath.section == XKDGoodThingSectionGoodsType) {
           if ([itemInfo isKindOfClass:[NSDictionary class]]) {
               NSDictionary *goodsInfo = itemInfo[@"good_info"];
               if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
                   NSString *goodsId = goodsInfo[@"_id"];
                   NSString *storeId = goodsInfo[@"seller_shop_id"];
                   XKDGoodDetailViewController *goodDetailViewController = [[XKDGoodDetailViewController alloc] init];
                   goodDetailViewController.goodsId = goodsId;
                   goodDetailViewController.storeId = storeId;
                   goodDetailViewController.rootPlateId = self.rootPlateId;
                   goodDetailViewController.plateId = @"500004";
                   goodDetailViewController.isFromCustomPlate = YES;
                   NSString *item_source = goodsInfo[@"item_source"];
                   goodDetailViewController.item_source = item_source;
                   [self.navigationController pushViewController:goodDetailViewController animated:YES];
               }

           }
       }
}



- (NSDictionary *)safeDataAtIndexPath:(NSIndexPath *)indexPath
                            dataArray:(NSArray *)dataArray {
    if ([dataArray isKindOfClass:[NSArray class]]) {
        if (indexPath.section < dataArray.count) {
            NSArray *sectionArray = dataArray[indexPath.section];
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
- (void)requestFristRecommendGoodsPageData {
    [self requestRecommendGoodsPageDataForIndex:ktFristRecommendGoodsPageIndex pageSize:kRecommendGoodsPageSize];
}


- (void)requestRecommendGoodsPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize {
     __weak typeof(self)weakSelf = self;
    [XKDStreetLogic getGoodItemWithIndex:index pageSize:pageSize success:^(NSArray * _Nonnull goodsArray) {
        [weakSelf receivedRecommendGoodsDataSuccess:goodsArray andIndex:index];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf receivedRecommendGoodsDataError:nil tipMessage:errorMsg];
    }];
}



- (void)receivedRecommendGoodsDataError:(NSError * _Nullable)error tipMessage:(NSString * _Nullable)tipMessage {
    [self removeMJRefreshLoadingsStatus];
    [self removeLoadingView];
    if ([tipMessage isKindOfClass:[NSString class]] && tipMessage.length > 0){
        [self showTipMessage:tipMessage];
    } else {
        [self showTipMessage:NetWork_NotReachable];
    }
}

- (void)receivedRecommendGoodsDataSuccess:(NSArray *)dataArray andIndex:(NSInteger)index {
    if (index == ktFristRecommendGoodsPageIndex) {
        [self refreshRecommendGoods:dataArray];
    } else {
        [self addMoreRecommendGoods:dataArray];
    }
    
    [self removeLoadingView];
    
    [self stopRefresh];
    if (self.dataArray.count > 0) {
        if(dataArray.count < kRecommendGoodsPageSize) {
            [self stopLoadMoreWithNoMoreData];
        } else {
            [self stopLoadMore];
        }
    } else {
        [self stopLoadMore];
    }
    
    // 没有数据的时候隐藏mj_footer
    self.collectionView.mj_footer.hidden =  (self.dataArray.count == 0);
    
    self.recommendGoodsPageIndex = index;
}

- (void)endRefreshing {
    [_refreshNormalHeader endRefreshing];
}

- (void)removeMJRefreshLoadingsStatus {
    [self stopRefresh];
    [self stopLoadMore];
}

- (void)stopLoadMoreWithNoMoreData {
    [_refreshAutoNormalFooter endRefreshingWithNoMoreData];
    _isLoading = NO;
}


- (void)stopRefresh {
    [_refreshNormalHeader endRefreshing];
    _isLoading = NO;
}

- (void)stopLoadMore {
    [_refreshAutoNormalFooter endRefreshing];
    _isLoading = NO;
}

- (void)refreshRecommendGoods:(NSArray *)dataArray {
    if ([dataArray isKindOfClass:[NSArray class]]) {
        [self.dataArray replaceObjectAtIndex:XKDGoodThingSectionGoodsType withObject:dataArray.mutableCopy];
         [UIView performWithoutAnimation:^{
             NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XKDGoodThingSectionGoodsType];
             [self.collectionView reloadSections:reloadSet];
         }];
    }
}

- (void)addMoreRecommendGoods:(NSArray *)dataArray {
    if([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        NSMutableArray *recommendGoods = @[].mutableCopy;
        NSArray *recommendGoodsSectionArray = self.dataArray[XKDGoodThingSectionGoodsType];
        if ([recommendGoodsSectionArray isKindOfClass:[NSArray class]]) {
            [recommendGoods addObjectsFromArray:recommendGoodsSectionArray];
        }
        [recommendGoods addObjectsFromArray:dataArray];
        [self.dataArray replaceObjectAtIndex:XKDGoodThingSectionGoodsType withObject:recommendGoods];
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XKDGoodThingSectionGoodsType];
            [self.collectionView reloadSections:reloadSet];
        }];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:XKDGoodThingSectionCycleBannerType];
    NSArray *itemArray = (NSArray *)[self safeDataAtIndexPath:indexPath dataArray:self.dataArray];
    if ([itemArray isKindOfClass:[NSArray class]] && index < itemArray.count) {
        NSDictionary *itemInfo = itemArray[index];
        [[XKDAdManager shareManager] adJumpWithInfo:itemInfo sourceController:self];
        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *adId = itemInfo[@"_id"];
            [[XKDAdManager shareManager] repoAdClickWitdAdId:adId];
        }
    }

}

#pragma mark -  AD


- (void)updateAdSection:(NSArray *)adArray {
    NSArray *cycleAdArray = adArray;
    if (![cycleAdArray isKindOfClass:[NSArray class]]) {
        cycleAdArray = [NSArray new];
    }
    NSArray *sectionAdArray = (cycleAdArray.count == 0 ? @[] : @[cycleAdArray]);
    [self.dataArray replaceObjectAtIndex:XKDGoodThingSectionCycleBannerType withObject:sectionAdArray];
    [self.collectionView reloadData];
}

- (NSArray *)cycleImageArray {
    NSArray *cycleAdArray = self.dataArray[XKDGoodThingSectionCycleBannerType];
    NSArray *adArray = cycleAdArray.firstObject;
    if ([adArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *cycleImageArray = [NSMutableArray array];
        [adArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *image = @"";
            if ([info isKindOfClass:[NSDictionary class]]) {
                image = info[@"image"];
            }
            [cycleImageArray addObject:image];
        }];
        return cycleImageArray;
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
