//
//  XLTHomeRecommendVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeRecommendVC.h"
#import "XLTHomeCustomHeadView.h"
#import "XLTHomeCellsFactory.h"
#import "XLTHomePageModel.h"
#import "XLTHomePageLogic.h"
#import "MJRefreshNormalHeader.h"
#import "XLTHomeSourceHeaderView.h"
#import "MJRefreshAutoNormalFooter.h"
#import "XLTHomePlateContainerVC.h"
#import "XLTHomePlateFilterListVC.h"
#import "SDCycleScrollView.h"
#import "XLTGoodsDetailVC.h"
#import "XLTAdManager.h"
#import "XLTHomeCycleDailyCell.h"
#import "XLTHomeCycleBannerCollectionViewCell.h"
#import "XLTWKWebViewController.h"
#import "XLTStreetTabBarController.h"
#import "XLTUserManager.h"
#import "XLTAliManager.h"
#import "XLTHomeKingKongCell.h"
#import "XLTNineYuanNineContainerVC.h"
#import "UIImage+WebP.h"
#import "XLTHomePageTopHeadView.h"
#import "NSArray+Bounds.h"
#import "SKAutoScrollLabel.h"

@interface XLTHomeRecommendVC () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate, XLTHomeKingKongCellDelegate, XLTHomePageCycleScrollViewDelegate>
@property (nonatomic, strong) XLTHomeCellsFactory *letaoCellFactory;
@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MJRefreshNormalHeader *letaoRefreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *letaoRefreshAutoFooter;

@property (nonatomic, copy) NSString *letaoRecommendGoodsSource;
@property (nonatomic, assign) NSInteger letaoCurrentPageIndex;
@property (nonatomic, strong) HMSegmentedControl *retaoSegmentedControl;
@property (nonatomic, strong) NSArray *letaoRecommendChannelArray;
@property (nonatomic, strong) NSArray *retaoRecommendChannelCodeArray;
@property (nonatomic, strong) XLTHomePageCycleScrollView *letaoCycleScrollView;
@property (nonatomic, strong) XLTHomeModuleModel *letaoCycleModuleModel;
@property (nonatomic, strong) NSMutableArray *letaoTaskArray;

@property (nonatomic, strong) UIView *tbAuthView;
@property (nonatomic, strong) UIView *loginBannerView;

@property (nonatomic, strong, nullable) UIImage *redPacketImage;
@property (nonatomic, strong) UIButton *redPacketButton;
@property (nonatomic, strong) NSDictionary *redPacketAdInfo;

@property (nonatomic, assign) NSInteger homePageVCIndex;

//消息UI
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic ,strong) UIButton *messageBtn;
@property (nonatomic ,strong) SKAutoScrollLabel *pmdLabel;
@property (nonatomic ,strong) UIView *messageContentView;
@end


@implementation XLTHomeRecommendVC
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[XLTUserManager shareManager] removeObserver:self forKeyPath:@"curUserInfo.has_bind_tb"];
    [[XLTUserManager shareManager] removeObserver:self forKeyPath:@"isLogined"];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.letaoCurrentPageIndex = [self fristRecommendGoodsPageIndex];
        self.letaoTaskArray = [NSMutableArray array];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(supportGoodsPlatformValueNotification) name:@"kSupportGoodsPlatformValueNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoCheckEnableChangedNotification) name:kLetaoCheckEnableChangedNotification object:nil];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLoginSuccessNotification) name:kXLTNotifiLoginSuccess object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLogoutSuccessNotification) name:kXLTNotifiLogoutSuccess object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleItemClickedNotification:) name:XLTHomeModuleItemClickedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsItemClickedNotification:) name:XLTHomeGoodsItemClickedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageVCIndexChangedNotification:) name:@"XLTHomePageVCIndexChangedNotification" object:nil];

        

                
        [[XLTUserManager shareManager] addObserver:self forKeyPath:@"curUserInfo.has_bind_tb" options:NSKeyValueObservingOptionNew context:nil];
        [[XLTUserManager shareManager] addObserver:self forKeyPath:@"isLogined" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)homePageVCIndexChangedNotification:(NSNotification *)notification {
    NSNumber *pageIndex = notification.object;
    if ([pageIndex isKindOfClass:[NSNumber class]]) {
        self.homePageVCIndex = [pageIndex integerValue];
        [self adjustCycleScrollViewInfiniteLoopState];
    }
}

- (void)letaoLoginSuccessNotification {
    [self letaoFetchFristRecommendPageData];
}


- (void)letaoLogoutSuccessNotification {
    [self letaoFetchFristRecommendPageData];
}

- (void)supportGoodsPlatformValueNotification {
    // 重新设置平台
    [self reloadRecommendChannelData];

    [_retaoSegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)letaoCheckEnableChangedNotification {
    // 重新设置平台
    [self reloadRecommendChannelData];
    [self letaoTriggerRefresh];
    
    [self requestRedPacketAdIfNeed];
    [self showRedPacketIfNeed];
}

- (void)reloadRecommendChannelData {
    // 重新设置平台title
    _letaoRecommendChannelArray = nil;
    _retaoSegmentedControl.sectionTitles = self.letaoRecommendChannelArray;
    // 重新设置平台code
    _retaoRecommendChannelCodeArray = nil;
    [self retaoRecommendChannelCodeArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self letaoSetupContentCollectionView];
    
    __weak __typeof(self)weakSelf = self;
    [self setXltBackToTopButtonCallback:^{
        [weakSelf.collectionView setContentOffset:CGPointZero animated:YES];
    }];
    
    [self showTBAuthViewIfNeed];
    [self showLoginBannerViewIfNeed];
    [self requestRedPacketAdIfNeed];
    [self showRedPacketIfNeed];
}


//推荐header
static NSString *const kXLTHomeSourceHeaderView = @"XLTHomeSourceHeaderView";

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
    [self.letaoCellFactory registerCellsForCollectionView:_collectionView];;
    [self letaoSetupRefreshHeader];
    _collectionView.mj_header = _letaoRefreshHeader;
    [self letaoSetupRefreshAutoFooter];
    _collectionView.mj_footer = _letaoRefreshAutoFooter;
       // 首次隐藏
    _collectionView.mj_footer.hidden = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XLTHomeSourceHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTHomeSourceHeaderView];
    
    [self.view addSubview:_collectionView];
}


#pragma mark - RefreshHeader & RefreshAutoFooter


- (void)letaoSetupRefreshHeader {
    if (_letaoRefreshHeader == nil) {
        __weak __typeof(self)weakSelf = self;
        _letaoRefreshHeader =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf letaoTriggerRefresh];
        }];
    }
}

- (void)letaoTriggerRefresh {
    if ([self.delegate respondsToSelector:@selector(letaoHomeTriggerRefreshAction)]) {
        [self.delegate letaoHomeTriggerRefreshAction];
    }
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



#pragma mark - 更新页面数据


- (void)setPageModel:(XLTHomePageModel *)pageModel {
    // 数据更新，结束Refreshing
      [_letaoRefreshHeader endRefreshing];
      if (_pageModel != pageModel) {
          
          // 更新数据是保存老的推荐商品和每日推荐
          NSArray *recommendGoodsArray = [_pageModel.recommendGoodsArray copy];
          pageModel.recommendGoodsArray = recommendGoodsArray;
          _pageModel = pageModel;
        
          [self collectionViewReloadData];
          
          if (!pageModel.isLocalCacheData) {
              // 刷新推荐数据
              self.letaoCurrentPageIndex = [self fristRecommendGoodsPageIndex];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self letaoFetchFristRecommendPageData];
                  
                  // 刷新每日推荐
                  [self requestHomeDailyRecommendData];
                  
                  // 刷新弹窗广告
                  [self requestHomeAdData];
                  
                  // 刷新底部红包视图广告
                  [self requestRedPacketAdIfNeed];
                  [self showRedPacketIfNeed];
              });
          }
      }
}

- (void)collectionViewReloadData {
    
    
    if (self.pageModel.modulesArray.count > 0) {
        XLTHomeModuleModel *moduleModel = self.pageModel.modulesArray[0];
        
        // 存在顶部banner
        if([moduleModel.moduleType isKindOfClass:[NSString class]] && [moduleModel.moduleType isEqualToString:XLTHomeTopCycleBannerModuleType]) {
            // do noting
        } else {
            // 清理letaoCycleScrollView
            [self.letaoCycleScrollView removeFromSuperview];
            self.letaoCycleScrollView.delegate = nil;
            self.letaoCycleScrollView.mainScrollViewDelegate = nil;
            self.letaoCycleScrollView = nil;
        }
    }
    
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
}

- (XLTHomeCellsFactory *)letaoCellFactory {
    if (_letaoCellFactory == nil) {
        _letaoCellFactory = [[XLTHomeCellsFactory alloc] init];
    }
    return _letaoCellFactory;
}


#pragma mark - UICollectionViewDelegate


-(BOOL)isDailyRecommendModuleSection:(NSInteger)section {
    NSUInteger modulesArrayCount = self.pageModel.modulesArray.count;
    if (section < modulesArrayCount) {
        XLTHomeModuleModel *moduleModel = self.pageModel.modulesArray[section];
        return ([moduleModel.moduleType isKindOfClass:[NSString class]] && [moduleModel.moduleType isEqualToString:XLTHomeDailyRecommendModuleType]);
    }
    return NO;
}

-(BOOL)isRecommendGoodsSection:(NSInteger)section {
    NSUInteger modulesArrayCount = self.pageModel.modulesArray.count;
    return !(section < modulesArrayCount);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSUInteger modulesArrayCount = self.pageModel.modulesArray.count;
    if (self.pageModel.recommendGoodsArray.count > 0) {
        modulesArrayCount ++ ;
    }
    return modulesArrayCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger modulesArrayCount = self.pageModel.modulesArray.count;
    if (section < modulesArrayCount) {
        return 1;
    } else {
        return self.pageModel.recommendGoodsArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.letaoCellFactory collectionView:collectionView cellForItemAtIndexPath:indexPath pageModel:self.pageModel];
    NSUInteger modulesArrayCount = self.pageModel.modulesArray.count;
    if (indexPath.section < modulesArrayCount) {
        XLTHomeModuleModel *moduleModel = self.pageModel.modulesArray[indexPath.section];
        if (indexPath.section == 0 && ([cell isKindOfClass:[XLTHomeCycleBannerCollectionViewCell class]])) {
            if (self.letaoCycleScrollView == nil) {
                self.letaoCycleScrollView = [XLTHomePageCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, collectionView.bounds.size.width -20, kTopBannerContentHeight) delegate:self placeholderImage:nil];
                self.letaoCycleScrollView.mainScrollViewDelegate = self;
                self.letaoCycleScrollView.layer.masksToBounds = YES;
                self.letaoCycleScrollView.layer.cornerRadius = 15.0;
                UIColor *bgColor = [UIColor letaolightgreyBgSkinColor];
                self.letaoCycleScrollView.backgroundColor = bgColor;
                self.letaoCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
                self.letaoCycleScrollView.currentPageDotColor = [UIColor whiteColor];
                self.letaoCycleScrollView.pageDotColor = [UIColor colorWithWhite:1.0 alpha:0.48];
                self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
                self.letaoCycleScrollView.backgroundImageView.backgroundColor = bgColor;
            }
            NSArray *buildCycleImageArray = [self buildCycleImageArray:moduleModel];
            if (![self.letaoCycleScrollView.imageURLStringsGroup isEqualToArray:buildCycleImageArray]) {
                self.letaoCycleScrollView.imageURLStringsGroup = buildCycleImageArray;
            }
            self.letaoCycleModuleModel = moduleModel;
            [cell.contentView addSubview:self.letaoCycleScrollView];
            int itemIndex = [self.letaoCycleScrollView currentIndex];
            int indexOnPageControl = [self.letaoCycleScrollView pageControlIndexWithCurrentCellIndex:itemIndex];
            
            [self changeStyleForBannerInfoAtIndex:indexOnPageControl];
        }
        
        if ([cell isKindOfClass:[XLTHomeKingKongCell class]]) {
            XLTHomeKingKongCell *kingKongAreaCell = (XLTHomeKingKongCell *)cell;
            kingKongAreaCell.delegate = self;
        }
    }

    return cell;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.letaoCellFactory collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath pageModel:self.pageModel];
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
     return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self isRecommendGoodsSection:section]){
        return CGSizeMake(collectionView.bounds.size.width, 44);
    } else {
        return CGSizeZero;
    }
}

 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if ([self isRecommendGoodsSection:indexPath.section]) {
         if (kind == UICollectionElementKindSectionHeader) {
             XLTHomeSourceHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTHomeSourceHeaderView forIndexPath:indexPath];
             [headerView addSubview:self.retaoSegmentedControl];
             return headerView;
         }
     }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger modulesArrayCount = self.pageModel.modulesArray.count;
    if (!(indexPath.section < modulesArrayCount)) {
        if(indexPath.item < self.pageModel.recommendGoodsArray.count) {
            NSDictionary *goodsInfo = self.pageModel.recommendGoodsArray[indexPath.item];
            [self goGoodDetailViewController:goodsInfo indexPath:indexPath];
            
            //汇报
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"_id"]];
            dic[@"good_name"] = [SDRepoManager repoResultValue:goodsInfo[@"item_title"]];
            NSString *title = [self.retaoSegmentedControl.sectionTitles by_ObjectAtIndex:self.retaoSegmentedControl.selectedSegmentIndex];
            dic[@"xlt_item_place"] = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            dic[@"xlt_item_source"] = [SDRepoManager repoResultValue:goodsInfo[@"item_source"]];
            dic[@"xlt_item_firstcate_title"] = @"null";
            dic[@"xlt_item_thirdcate_title"] = @"null";
            dic[@"xlt_item_secondcate_title"] = @"null";
            [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_RECOMMEND properties:dic];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self xlt_scrollViewDidScroll:scrollView needAutoShowBackToTop:YES];
    [self adjustBackToTopButtonFrame];
    
    if ([self.delegate respondsToSelector:@selector(homeRecommendVCScrollViewDidScroll:)]) {
        [self.delegate homeRecommendVCScrollViewDidScroll:scrollView];
    }
    
    [self adjustCycleScrollViewInfiniteLoopState];
}

#pragma mark -  推荐商品

#define kRecommendGoodsPageSize 10
#define kFristRecommendGoodsPageIndex 1

- (NSInteger)fristRecommendGoodsPageIndex {
    return kFristRecommendGoodsPageIndex;
}


- (NSArray *)letaoRecommendChannelArray {
    if (!_letaoRecommendChannelArray) {
        NSMutableArray *recommendChannelArray = [NSMutableArray array];
        [recommendChannelArray addObject:@"为你推荐"];
        NSArray *supportGoodsPlatformArray = [[XLTAppPlatformManager shareManager] supportGoodsPlatformArrayForHome];
        NSMutableArray *supportGoodsPlatformNameArray = [NSMutableArray array];
        [supportGoodsPlatformArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull platformInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([platformInfo isKindOfClass:[NSDictionary class]]) {
                NSString *name = platformInfo[@"name"];
                NSString *code = platformInfo[@"code"];
                if (name && code) {
                    [supportGoodsPlatformNameArray addObject:name];
                }
            }
        }];
        
        [recommendChannelArray addObjectsFromArray:supportGoodsPlatformNameArray];
        _letaoRecommendChannelArray = recommendChannelArray;
    }
    return _letaoRecommendChannelArray;
}

- (NSArray *)retaoRecommendChannelCodeArray {
    if (!_retaoRecommendChannelCodeArray) {
        NSMutableArray *recommendChannelCodeArray = [NSMutableArray array];
        [recommendChannelCodeArray addObject:@""];

        NSArray *supportGoodsPlatformArray = [[XLTAppPlatformManager shareManager] supportGoodsPlatformArrayForHome];
        NSMutableArray *supportGoodsPlatformCodeArray = [NSMutableArray array];
        [supportGoodsPlatformArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull platformInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([platformInfo isKindOfClass:[NSDictionary class]]) {
                NSString *name = platformInfo[@"name"];
                NSString *code = platformInfo[@"code"];
                if (name && code) {
                    [supportGoodsPlatformCodeArray addObject:code];
                }
            }
        }];
        [recommendChannelCodeArray addObjectsFromArray:supportGoodsPlatformCodeArray];
        _retaoRecommendChannelCodeArray = recommendChannelCodeArray;
    }
    return _retaoRecommendChannelCodeArray;
}


- (HMSegmentedControl *)retaoSegmentedControl {
    if (!_retaoSegmentedControl) {
        _retaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, 0, self.collectionView.bounds.size.width - 20,  44)];
        _retaoSegmentedControl.backgroundColor = [UIColor whiteColor];
        _retaoSegmentedControl.selectionIndicatorHeight = 0.0;
        _retaoSegmentedControl.userDraggable = YES;
        _retaoSegmentedControl.sectionTitles = self.letaoRecommendChannelArray;
        _retaoSegmentedControl.type = HMSegmentedControlTypeText;
        _retaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _retaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _retaoSegmentedControl.selectionIndicatorBoxColor = [UIColor whiteColor];
        _retaoSegmentedControl.selectionIndicatorBoxOpacity = 1.0;
        _retaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]};
        _retaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
        [_retaoSegmentedControl addTarget:self action:@selector(recommendSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _retaoSegmentedControl;
    
}

- (void)recommendSegmentedControlValueChanged:(id)sender {
    NSInteger index = self.retaoSegmentedControl.selectedSegmentIndex;
    if(index < self.retaoRecommendChannelCodeArray.count) {
        NSString *source = self.retaoRecommendChannelCodeArray[index];
        [self letaoChangeRecommendGoodsSource:source];
    }
    
//    // 汇报事件
//    if(index < self.letaoRecommendChannelArray.count) {
//        NSMutableDictionary *properties = @{}.mutableCopy;
//        properties[@"xlt_item_title"] = self.letaoRecommendChannelArray[index];
//        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_RECOMMEND properties:properties];
//    }
}

- (void)letaoClearRecommendGoodsPageData {
    /*
    // 清楚老数据
     [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    self.collectionView.mj_footer.hidden = YES;
    NSArray *recommendGoodsSectionArray = self.letaoPageDataArray[XLTHomePagesSectionRecommendGoodsType];
    if ([recommendGoodsSectionArray isKindOfClass:[NSArray class]] && recommendGoodsSectionArray.count > 0) {
        [self.letaoPageDataArray replaceObjectAtIndex:XLTHomePagesSectionRecommendGoodsType withObject:@[]];
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:XLTHomePagesSectionRecommendGoodsType];
            [self.collectionView reloadSections:reloadSet];
        }];
    }
    self.letaoCurrentPageIndex = [self fristRecommendGoodsPageIndex];*/
}

- (void)letaoChangeRecommendGoodsSource:(NSString *)goodsSource {
    self.letaoRecommendGoodsSource = goodsSource;
    self.letaoCurrentPageIndex = [self fristRecommendGoodsPageIndex];
    [self letaoFetchFristRecommendPageData];
}

- (void)letaoTriggerLoadMore {
    NSInteger requestIndex = _letaoCurrentPageIndex +1;
    [self letaoFetchRecommendPagePageDataForIndex:requestIndex pageSize:kRecommendGoodsPageSize];
}

- (void)letaoFetchFristRecommendPageData {
    [self letaoClearRecommendGoodsPageData];
    [self letaoFetchRecommendPagePageDataForIndex:[self fristRecommendGoodsPageIndex] pageSize:kRecommendGoodsPageSize];
}

- (void)letaoFetchRecommendPagePageDataForIndex:(NSInteger)index
                                     pageSize:(NSInteger)pageSize {
   
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    [self letaoCancelAllTaks];
     __weak __typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [self.letaoHomeLogic requestHomeRecommendGoodsDataForIndex:index pageSize:pageSize item_source:self.letaoRecommendGoodsSource success:^(NSArray * _Nonnull goodsArray,NSURLSessionDataTask * task) {
        if ([weakSelf.letaoTaskArray containsObject:task]) {
            [weakSelf.letaoTaskArray removeObject:task];
            [weakSelf letaoReceivedGoodsDataSuccess:goodsArray andIndex:index];

        }
    } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
        if ([weakSelf.letaoTaskArray containsObject:task]) {
            [weakSelf.letaoTaskArray removeObject:task];
            [weakSelf.letaoRefreshAutoFooter endRefreshing];
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



- (void)letaoReceivedGoodsDataSuccess:(NSArray *)letaoPageDataArray andIndex:(NSInteger)index {
    if (index == [self fristRecommendGoodsPageIndex]) {
        [self letaoReloadRecommendData:letaoPageDataArray];
    } else {
        [self letaoAddMoreRecommendData:letaoPageDataArray];
    }
    NSArray *recommendGoodsArray = self.pageModel.recommendGoodsArray;
    if(letaoPageDataArray.count < 1) {
        [_letaoRefreshAutoFooter endRefreshingWithNoMoreData];
    } else {
        [_letaoRefreshAutoFooter endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat emptyHeight = MAX(0, self.collectionView.bounds.size.height - recommendGoodsArray.count * 157  -44);
            if ((emptyHeight > 0)
                || (self.collectionView.mj_insetT + self.collectionView.mj_contentH <= self.collectionView.mj_h)) {
                [self.letaoRefreshAutoFooter beginRefreshing];
            } else {
                [self.letaoRefreshAutoFooter endRefreshing];
            }
        });
    }
    // 没有数据的时候隐藏mj_footer
    self.collectionView.mj_footer.hidden =  (recommendGoodsArray.count == 0);
    self.letaoCurrentPageIndex = index;
}

- (void)letaoEndRefreshState {
    [_letaoRefreshHeader endRefreshing];
}

- (void)letaoReloadRecommendData:(NSArray *)letaoPageDataArray {
    if ([letaoPageDataArray isKindOfClass:[NSArray class]] && letaoPageDataArray.count) {
        self.pageModel.recommendGoodsArray = letaoPageDataArray;
        [self collectionViewReloadData];
        
        // 回到第一条数据
        NSUInteger recommendGoodsSection = self.pageModel.modulesArray.count;
         UICollectionViewLayoutAttributes *headeraAttributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:recommendGoodsSection]];
        if (headeraAttributes) {
            CGRect rect = headeraAttributes.frame;
            if (self.collectionView.contentOffset.y + 44 >= rect.origin.y) {
                NSIndexPath *fristIndexPath = [NSIndexPath indexPathForItem:0 inSection:recommendGoodsSection];
                UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:fristIndexPath];
                if (attributes) {
                    CGRect rect = attributes.frame;
                    [self.collectionView setContentOffset:CGPointMake(0, rect.origin.y  - 44) animated:NO];
                }
            }
        }
    }
}

- (void)letaoAddMoreRecommendData:(NSArray *)letaoPageDataArray {
    if([letaoPageDataArray isKindOfClass:[NSArray class]] && [letaoPageDataArray count] > 0) {
        NSMutableArray *recommendGoodsArray = nil;
        if ([self.pageModel.recommendGoodsArray isKindOfClass:[NSArray class]]) {
            recommendGoodsArray = self.pageModel.recommendGoodsArray.mutableCopy;
        } else {
            recommendGoodsArray = @[].mutableCopy;
        }
        [recommendGoodsArray addObjectsFromArray:letaoPageDataArray];
        self.pageModel.recommendGoodsArray = recommendGoodsArray;
        [self collectionViewReloadData];
    }
}


#pragma mark - SDCycleScrollViewDelegate

- (void)adjustCycleScrollViewInfiniteLoopState {
    BOOL infiniteLoop_offset = self.collectionView.contentOffset.y < 50;
    BOOL infiniteLoop_homePageIndex = (self.homePageVCIndex == 0);
    BOOL autoScroll = (infiniteLoop_offset && infiniteLoop_homePageIndex && self.letaoCycleScrollView.imageURLStringsGroup.count > 1);
    if (self.letaoCycleScrollView.autoScroll != autoScroll) {
        self.letaoCycleScrollView.autoScroll  = autoScroll;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSArray *modulesItemArray = self.letaoCycleModuleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
           XLTHomeModuleItemModel *item = modulesItemArray.firstObject;
        if ([item.itemData isKindOfClass:[NSArray class]]) {
            if (index < item.itemData.count) {
                NSDictionary *itemInfo = item.itemData[index];
                [self modulJumpWithInfo:itemInfo];
                if ([itemInfo isKindOfClass:[NSDictionary class]]) {
                    NSString *adId = itemInfo[@"_id"];
                    [[XLTAdManager shareManager] repoAdClickWitdAdId:adId];

                     // 汇报事件
                    NSMutableDictionary *properties = @{}.mutableCopy;
                    properties[@"banner_id"] = itemInfo[@"_id"] ? itemInfo[@"_id"] : @"null";
                    properties[@"banner_name"] = itemInfo[@"name"]? itemInfo[@"name"] : @"null";
                    properties[@"url"] = itemInfo[@"link_url"] ? itemInfo[@"link_url"] : @"null";
                    properties[@"banner_rank"] = [NSNumber numberWithInteger:index + 1];
                    properties[@"activity_time"] = @"null";
                    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_BANNER properties:properties];
                }
            }
        }
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    [self changeStyleForBannerInfoAtIndex:index];
}

- (void)cycleMainScrollViewDidScroll:(UIScrollView *)scrollView offset:(NSInteger)offset {
    if (self.letaoCycleScrollView.imageURLStringsGroup.count > 1) {
        NSInteger offsetCurrent = offset % (NSInteger)self.letaoCycleScrollView.bounds.size.width ;
        float rate = offsetCurrent / self.letaoCycleScrollView.bounds.size.width ;
        NSInteger currentPage = offset / (NSInteger)self.letaoCycleScrollView.bounds.size.width;
        NSArray *modulesItemArray = self.letaoCycleModuleModel.modulesItemArray;
        if ([modulesItemArray isKindOfClass:[NSArray class]]) {
            XLTHomeModuleItemModel *item = modulesItemArray.firstObject;
            if ([item.itemData isKindOfClass:[NSArray class]]) {
                NSDictionary *startBanner = nil;
                NSDictionary *endBanner = nil;
                
                if (currentPage == item.itemData.count - 1) {
                    startBanner = item.itemData[currentPage];
                    endBanner = item.itemData[0];
                } else {
                    if (currentPage >= item.itemData.count) {
                        return;
                    }
                    startBanner = item.itemData[currentPage];
                    endBanner = item.itemData[currentPage + 1];
                }
                if ([self.delegate respondsToSelector:@selector(scrollBanner:toBanner:rate:)]) {
                    [self.delegate scrollBanner:startBanner toBanner:endBanner rate:rate];
                }
            }
        }

    }
}

- (void)changeStyleForBannerInfoAtIndex:(NSInteger)index {
    NSArray *modulesItemArray = self.letaoCycleModuleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        XLTHomeModuleItemModel *item = modulesItemArray.firstObject;
        if ([item.itemData isKindOfClass:[NSArray class]]) {
            if (index < item.itemData.count) {
                NSDictionary *itemInfo = item.itemData[index];
                if ([self.delegate respondsToSelector:@selector(scrollBanner:toBanner:rate:)]) {
                    [self.delegate scrollBanner:itemInfo toBanner:nil rate:0];
                }
            }
        }
    }
}



- (NSArray *)buildCycleImageArray:(XLTHomeModuleModel *)moduleModel {
    NSArray *modulesItemArray = moduleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        XLTHomeModuleItemModel *item = modulesItemArray.firstObject;
        if ([item.itemData isKindOfClass:[NSArray class]]) {
            NSMutableArray *cycleImageArray = [NSMutableArray array];
            [item.itemData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *image = nil;
                if ([info isKindOfClass:[NSDictionary class]]) {
                    image = info[@"image"];
                }
                if ([image isKindOfClass:[NSString class]]) {
                    [cycleImageArray addObject:[image letaoConvertToHttpsUrl]];
                } else {
                    [cycleImageArray addObject:@""];
                }
            }];
            return cycleImageArray;
        }
    }
    return @[];
}


#pragma mark -  每日推荐

- (void)requestHomeDailyRecommendData {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoHomeLogic xingletaonetwork_requestHomeDailyRecommendDataSuccess:^(NSArray * _Nonnull dailyRecommendArray) {
        [weakSelf updateHomeDailyRecommendData:dailyRecommendArray];
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing;
    }];
}

- (void)updateHomeDailyRecommendData:(NSArray *)dailyRecommendArray {
    [self.pageModel updateDailyRecommendData:dailyRecommendArray];
    [self collectionViewReloadData];
}

#pragma mark -  弹窗AD


- (void)requestHomeAdData {
    __weak typeof(self)weakSelf = self;
    [[XLTAdManager shareManager] xingletaonetwork_requestHomeAdSuccess:^(NSDictionary  * _Nonnull adInfo) {
        [weakSelf letaoUpdateAdSectionData:adInfo];
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing;
    }];
}


- (void)letaoUpdateAdSectionData:(NSDictionary *)adInfo {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        NSArray *popAdArray = adInfo[@"11"];
        [[XLTAdManager shareManager] popAdWithInfo:popAdArray];
        //消息数据
        NSArray *messageArray = adInfo[@"19"];
        [self.messageArray removeAllObjects];
        if (messageArray.count) {
            [self.messageArray addObjectsFromArray:messageArray];
            [self showMessageViewIfNeed];
        }
        [self showMessageViewIfNeed];
    }
}


- (void)homeKingKongCell:(XLTHomeKingKongCell *)cell  didSelectItem:(NSDictionary *)itemInfo index:(NSInteger )index{
    [self modulJumpWithInfo:itemInfo];
    if (itemInfo) {
        
        NSString *xlt_item_id = itemInfo[@"_id"] ? itemInfo[@"_id"] : @"null";
        NSString *xlt_item_title = [itemInfo[@"name"] isKindOfClass:[NSString class]] ? itemInfo[@"name"] : @"null";
        NSMutableDictionary *dic = @{}.mutableCopy;
        dic[@"xlt_item_id"] = xlt_item_id;
        dic[@"xlt_item_title"] = xlt_item_title;
        dic[@"jgq_rank"] = [NSNumber numberWithInteger:index + 1];
        dic[@"activity_time"] = @"null";
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_JGQ properties:dic];
    }
    
}

//messageView
- (void)showMessageViewIfNeed {
    BOOL show = [[XLTUserManager shareManager] isLogined] && [XLTUserManager shareManager].curUserInfo.has_bind_tb.boolValue && self.messageArray.count;
    if (show) {
        if (self.messageView == nil) {
            UIView *loginBannerView = [[UIView alloc] init];
            loginBannerView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:loginBannerView];
            [loginBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(40);
                make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(-15);
            }];
            loginBannerView.clipsToBounds = NO;
            self.messageView = loginBannerView;
            
            UIView *bgView = [[UIView alloc] init];
            [self.messageView addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.equalTo(self.messageView);
            }];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.alpha = 0.6;
            bgView.layer.cornerRadius = 5;
            bgView.clipsToBounds = YES;
            
            
            [self.messageView addSubview:self.messageContentView];
            [self.messageView addSubview:self.messageBtn];
            [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.messageView);
                make.width.mas_equalTo(70);
                make.right.equalTo(self.messageView);
            }];
            
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageView).offset(15);
                make.right.equalTo(self.messageBtn.mas_left);
                make.top.bottom.equalTo(self.messageView);
            }];
            
            
//            [contentView addSubview:self.pmdLabel];
//            [self.pmdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.top.bottom.equalTo(contentView);
//                make.width.mas_equalTo(kScreenWidth - 30 - 90);
//            }];
            
            
            
            [self.messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
        }
        self.messageView.hidden = NO;
        [self startAnimation];
    } else {
//        [self.messageArray removeAllObjects];
        self.messageView.hidden = YES;
        [self stopAnimation];
    }
//    [self adjustBackToTopButtonFrame];
}
- (void)updateMessageViewStatus{
    NSDictionary *dic = self.messageArray.firstObject;
    if (!dic) {
        self.messageView.hidden = YES;
        return;
    }
    NSString *text = dic[@"show_text"];
    NSNumber *status = dic[@"direct"];
//    _pmdLabel.pauseScroll = NO;
    [_pmdLabel removeFromSuperview];
    _pmdLabel = nil;
    
    [self configPmdWithContent:text];
    if (!status.intValue) {
        [self.messageBtn setTitle:@"知道了" forState:UIControlStateNormal];
    }else{
        [self.messageBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    self.messageView.hidden = NO;
}
- (void)configPmdWithContent:(NSString *)str{
    _pmdLabel = [[SKAutoScrollLabel alloc] initWithTextContent:str direction:SK_AUTOSCROLL_DIRECTION_LEFT];
    _pmdLabel.backgroundColor = [UIColor clearColor];
    _pmdLabel.textColor = [UIColor whiteColor];
    _pmdLabel.font = [UIFont letaoRegularFontWithSize:14];
    _pmdLabel.textAlignment = NSTextAlignmentLeft;
    _pmdLabel.frame = CGRectMake(0, 0, kScreenWidth - 120, 40);
    _pmdLabel.labelSpacing = 0;
    [self.messageContentView addSubview:_pmdLabel];
}
- (void)messageClick{
    NSDictionary *dic = self.messageArray.firstObject;
    NSNumber *status = dic[@"direct"];
    NSString *adId = dic[@"_id"];
    if (status.intValue == 0) {
        [self removeFirstMessage];
    }else if (status.intValue == 1){
//        [self removeFirstMessage];
        [[XLTAdManager shareManager] adJumpWithInfo:dic sourceController:self];
    }else if (status.intValue == 2){
//        [self removeFirstMessage];
        [[XLTAdManager shareManager] adJumpWithInfo:dic sourceController:self];
    }
    [[XLTAdManager shareManager] repoAdClickWitdAdId:adId];
}
- (void)removeFirstMessage{
    [self stopAnimation];
    [self.messageArray by_removeObjectAtIndex:0];
    [self updateMessageViewStatus];
    [self startAnimation];
}
- (void)clearMessageView{
    self.messageView.hidden = YES;
    [self stopAnimation];
}
- (void)stopAnimation{
    
}
- (void)startAnimation{
//    self.timeCount = 0;
    [self updateMessageViewStatus];
    [self.pmdLabel continueScroll];
}
- (void)pagerViewScrolToTop {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
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


#pragma mark -  底部快捷入口

@implementation XLTHomeRecommendVC (QuickEntryView)

- (void)showTBAuthViewIfNeed {
    
    BOOL show = ([[XLTUserManager shareManager] isLogined] && ![[XLTUserManager shareManager].curUserInfo.has_bind_tb boolValue]);
    CGFloat offset = show ? 45 : 0;
    self.backToTopButton.frame = CGRectMake(self.collectionView.bounds.size.width - 42 - 22 , self.collectionView.bounds.size.height - 56 -30 - offset + self.collectionView.contentOffset.y, 56, 56);
    if (show) {
        if (self.tbAuthView == nil) {
            UIView *tbAuthView = [[UIView alloc] init];
            [self.view addSubview:tbAuthView];
            [tbAuthView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(44);
                make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(-15);
            }];
            tbAuthView.clipsToBounds = NO;
            tbAuthView.layer.cornerRadius = 22.0;
            tbAuthView.layer.shadowColor = [UIColor blackColor].CGColor;
            tbAuthView.layer.shadowOpacity = 0.15;
            tbAuthView.layer.shadowOffset = CGSizeMake(2, 2);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tbAuthBtnAction)];
            [tbAuthView addGestureRecognizer:tap];
            tbAuthView.backgroundColor = [UIColor whiteColor];
            self.tbAuthView = tbAuthView;
            
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"home_taobaoauth_icon"];
            [tbAuthView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(@10);
                make.width.height.equalTo(@24);
            }];
            
            
            UIButton *goButton = [[UIButton alloc] init];
            goButton.userInteractionEnabled = NO;
            goButton.backgroundColor = [UIColor letaomainColorSkinColor];
            [tbAuthView addSubview:goButton];
            [goButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@9);
                make.right.equalTo(@-10);
                make.height.equalTo(@26);
                make.width.equalTo(@79);
            }];
            [goButton setTitle:@"淘宝授权" forState:UIControlStateNormal];
            [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            goButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:13];
            [goButton addTarget:self action:@selector(tbAuthBtnAction) forControlEvents:UIControlEventTouchUpInside];
            goButton.layer.masksToBounds = YES;
            goButton.layer.cornerRadius = 13.0;
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithHex:0xFF333333];
            label.font = [UIFont letaoRegularFontWithSize:13];
            label.text = @"一键授权，立享优惠权益";
            [tbAuthView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_right).offset(6);
                make.centerY.equalTo(imageView.mas_centerY);
            }];
        }
        self.tbAuthView.hidden = NO;
    } else {
        self.tbAuthView.hidden = YES;
    }
    [self adjustBackToTopButtonFrame];
}

- (void)showRedPacketIfNeed {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        BOOL show = ((self.tbAuthView.hidden || self.tbAuthView == nil)
                     && (self.loginBannerView.hidden || self.loginBannerView == nil)
                     && self.redPacketImage != nil);
        if (show) {
            if (self.redPacketButton == nil) {
                UIButton *redPacketButton = [UIButton buttonWithType:UIButtonTypeCustom];
                redPacketButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [redPacketButton addTarget:self action:@selector(redPacketBtnAction) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:redPacketButton];
                [redPacketButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-5);
                    make.height.mas_equalTo(70);
                    make.width.mas_equalTo(70);
                    make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(-(65+30));
                }];
                self.redPacketButton = redPacketButton;
            }
            [self.redPacketButton setImage:self.redPacketImage forState:UIControlStateNormal];
            self.redPacketButton.hidden = NO;
        } else {
            self.redPacketButton.hidden = YES;
        }
    } else {
        self.redPacketButton.hidden = YES;
    }
}


- (void)redPacketBtnAction {
    [self modulJumpWithInfo:self.redPacketAdInfo];
}


- (void)tbAuthBtnAction {
    [self requestTaoBaoAuthWithSourceController:self];
}

- (void)requestTaoBaoAuthWithSourceController:(XLTBaseViewController *)sourceController {
    [[XLTAliManager shareManager] xingletaonetwork_requestTaoBaoAuthUrlSuccess:^(NSString * _Nonnull authUrl, NSURLSessionDataTask * _Nonnull task) {
        [[XLTAliManager shareManager] openAliTrandPageWithURLString:authUrl sourceController:sourceController authorized:NO];

    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
    }];
}



- (void)showLoginBannerViewIfNeed {
    BOOL show = ![[XLTUserManager shareManager] isLogined];
    if (show) {
        if (self.loginBannerView == nil) {
            UIView *loginBannerView = [[UIView alloc] init];
            [self.view addSubview:loginBannerView];
            [loginBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(44);
                make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(-15);
            }];
            loginBannerView.clipsToBounds = NO;
            loginBannerView.layer.cornerRadius = 22.0;
            loginBannerView.layer.shadowColor = [UIColor blackColor].CGColor;
            loginBannerView.layer.shadowOpacity = 0.15;
            loginBannerView.layer.shadowOffset = CGSizeMake(2, 2);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginBannerBtnAction)];
            [loginBannerView addGestureRecognizer:tap];
            loginBannerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
            self.loginBannerView = loginBannerView;
            
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"home_loginbanner_icon"];
            [loginBannerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(@10);
                make.width.height.equalTo(@24);
            }];
            
            
            UIButton *goButton = [[UIButton alloc] init];
            goButton.userInteractionEnabled = NO;
            goButton.backgroundColor = [UIColor letaomainColorSkinColor];
            [loginBannerView addSubview:goButton];
            [goButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@9);
                make.right.equalTo(@-10);
                make.height.equalTo(@26);
                make.width.equalTo(@79);
            }];
            [goButton setTitle:@"登录/注册" forState:UIControlStateNormal];
            [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            goButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:13];
            goButton.layer.masksToBounds = YES;
            goButton.layer.cornerRadius = 13.0;
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont letaoRegularFontWithSize:13];
            label.text = @"登录领取京东、淘宝大额优惠券";
            [loginBannerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_right).offset(6);
                make.centerY.equalTo(imageView.mas_centerY);
            }];
        }
        self.loginBannerView.hidden = NO;
    } else {
        self.loginBannerView.hidden = YES;
    }
    [self adjustBackToTopButtonFrame];
}

- (void)adjustBackToTopButtonFrame {
    BOOL showTBAuthView = ![[XLTUserManager shareManager] isLogined];
    BOOL showLoginBannerView = ([[XLTUserManager shareManager] isLogined] && ![[XLTUserManager shareManager].curUserInfo.has_bind_tb boolValue]);
    CGFloat offset = (showTBAuthView || showLoginBannerView) ? 45 : 0;
    self.backToTopButton.frame = CGRectMake(self.collectionView.bounds.size.width - 42 - 22 , self.collectionView.bounds.size.height - 56 -30 - offset + self.collectionView.contentOffset.y, 56, 56);
}

- (void)loginBannerBtnAction {
    if ([[XLTUserManager shareManager] isLogined]) {
        [self showLoginBannerViewIfNeed];
    } else {
        [[XLTUserManager shareManager] displayLoginViewController];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"curUserInfo.has_bind_tb"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showTBAuthViewIfNeed];
            
            [self requestRedPacketAdIfNeed];
            [self showRedPacketIfNeed];
        });
    } else if ([keyPath isEqualToString:@"isLogined"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoginBannerViewIfNeed];
            
            [self requestRedPacketAdIfNeed];
            [self showRedPacketIfNeed];
        });
    }
}

- (void)requestRedPacketAdIfNeed {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        BOOL shouldRequest = ((self.tbAuthView.hidden || self.tbAuthView == nil)
                              && (self.loginBannerView.hidden || self.loginBannerView == nil));
        if (shouldRequest) {
            __weak __typeof(self)weakSelf = self;
            [[XLTAdManager shareManager] xingletaonetwork_requestAdListWithPosition:@"17" success:^(NSArray * _Nonnull adArray) {
                [weakSelf downLaodRedPacketAdIWithInfo:adArray];
            } failure:^(NSString * _Nonnull errorMsg) {
                
            }];
        }
    }
}

- (void)downLaodRedPacketAdIWithInfo:(NSArray *)adArray {
    NSString *imageUrl = nil;
    if ([adArray isKindOfClass:[NSArray class]]) {
        NSDictionary *adInfo = adArray.firstObject;
        if ([adInfo isKindOfClass:[NSDictionary class]]) {
            imageUrl = adInfo[@"image"];
            self.redPacketAdInfo = adInfo;
        }
    }
    if ([imageUrl isKindOfClass:[NSString class]] && imageUrl.length > 0) {
        __weak typeof(self)weakSelf = self;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [weakSelf updateRedPacketImage:image];
        }];
    } else {
        [self updateRedPacketImage:nil];
    }
}

- (void)updateRedPacketImage:(UIImage * _Nullable)image {
    self.redPacketImage = image;
    [self showRedPacketIfNeed];
}
@end

#pragma mark -  首页模块点击事件

@implementation XLTHomeRecommendVC (ModelClickEvent)

- (void)moduleItemClickedNotification:(NSNotification *)notification {
    NSDictionary *info = notification.object;
    [self modulJumpWithInfo:info];
}

- (void)modulJumpWithInfo:(NSDictionary *)info {
    [[XLTAdManager shareManager] adJumpWithInfo:info sourceController:self];
    // 汇报事件

    NSString *xlt_item_id = info[@"_id"] ? info[@"_id"] : @"null";
    NSString *xlt_item_title = [info[@"name"] isKindOfClass:[NSString class]] ? info[@"name"] : @"null";
    NSString *xlt_item_source = info[@"item_source"] ? info[@"item_source"] : @"null";
    [SDRepoManager xltrepo_trackHomeModulClickEvent:xlt_item_id xlt_item_title:xlt_item_title xlt_item_source:xlt_item_source];
    
    [XLTHomePageLogic xinletaoRepoHomeModulClickWithId:xlt_item_id];
}


- (void)goodsItemClickedNotification:(NSNotification *)notification {
    NSDictionary *itemInfo = notification.object;
    [self goGoodDetailViewController:itemInfo indexPath:nil];
}

- (void)goGoodDetailViewController:(NSDictionary *)itemInfo indexPath:(nullable NSIndexPath *)indexPath{
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSString *letaoGoodsId = itemInfo[@"_id"];
        NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
        NSString *item_source = itemInfo[@"item_source"];
        XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
        goodDetailViewController.letaoPassDetailInfo = itemInfo;
        goodDetailViewController.letaoGoodsId = letaoGoodsId;
        goodDetailViewController.letaoStoreId = letaoStoreId;
        goodDetailViewController.letaoGoodsSource = item_source;
        NSString *letaoGoodsItemId = itemInfo[@"item_id"];
        goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
        [self.navigationController pushViewController:goodDetailViewController animated:YES];
        
        // 汇报事件
        NSNumber *index = nil;
        if (indexPath !=nil) {
            index = [NSNumber numberWithInteger:indexPath.row];
        }
        [SDRepoManager xltrepo_trackGoodsSelectedWithInfo:itemInfo xlt_item_place:nil xlt_item_good_position:index];
    }
}
#pragma mark - Lazy
- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}
- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = [UIFont letaoRegularFontWithSize:14];
    }
    return _messageBtn;
}
//- (SKAutoScrollLabel *)pmdLabel{
//    if (!_pmdLabel) {
//
////        _pmdLabel.enab
////        _pmdLabel.
//    }
//    return _pmdLabel;
//}
- (UIView *)messageContentView{
    if (!_messageContentView) {
        _messageContentView = [[UIView alloc] init];
    }
    return _messageContentView;
}
@end
