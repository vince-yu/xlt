//
//  XLTUserCentreVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserCentreVC.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "XLTUserHeaderView.h"
#import "XLTUserSettingVC.h"
#import "XLTUserWithDrawVC.h"
#import "XLTUserBalanceDrawVC.h"
#import "XLTUserGoodsRecommendVC.h"
#import "XLTUserFootPrintGoodsVC.h"
#import "JXCategoryView.h"
#import "MJRefresh.h"
#import "XLTUserManager.h"
#import "XLTAdManager.h"
#import "XLTUserInfoLogic.h"
#import "XLTOrderContainerVC.h"
#import "XLTOrderFindVC.h"
#import "XLTMyTeamVC.h"
#import "XLTUserInvateVC.h"
#import "XLTCollectVC.h"
#import "XLTIncomeVC.h"
#import "XLTVipOrderViewController.h"
#import "XLTRootOrderVC.h"
#import "XLTActivityVC.h"
#import "DYVideoContainerViewController.h"
#import "XLTUpdateMyInviterVC.h"

@interface XLTUserCentreVC () <JXCategoryViewDelegate,XLTUserHeaderViewDelegate>
@property (nonatomic ,strong) XLTUserHeaderView *userHeaderView;
@property (nonatomic, strong) UIView *letaoCustomNavView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) XLTUserGoodsRecommendVC *recommendViewController;
@property (nonatomic, strong) XLTUserFootPrintGoodsVC *footprintViewController;
@property (nonatomic, strong) NSArray *adInfo;

@end

@implementation XLTUserCentreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubViews];
    [self updateAdInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:kXLTNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessAction) name:kXLTNotifiLogoutSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(supportGoodsPlatformValueNotification) name:@"kSupportGoodsPlatformValueNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkEnableReloadAction) name:kLetaoCheckEnableChangedNotification object:nil];
}

- (void)pagerViewScrolToTop {
    [self.pagerView.currentScrollingListView setContentOffset:CGPointZero animated:YES];
//    [self.pagerView.mainTableView setContentOffset:CGPointZero animated:YES];
}
- (void)checkEnableReloadAction{
    [self.pagerView.currentScrollingListView setContentOffset:CGPointZero animated:NO];
    [self.pagerView.mainTableView setContentOffset:CGPointZero animated:NO];
    
    [self.userHeaderView reloadView:[XLTUserManager shareManager].isLogined];
    
    // reload categoryView
    [self setupCategoryViewTitles];
    [self.categoryView reloadData];
    
    
    [self.pagerView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginSuccessAction{
    [self requestDataWithLoading:YES];
    [self.pagerView reloadData];
}

- (void)supportGoodsPlatformValueNotification {
    if (!self.viewLoaded) {
        return;
    }
    [self requestDataWithLoading:YES];
    [self.pagerView reloadData];
}


- (void)memberClick:(NSInteger )index{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    switch (index) {
        case 0:
            [self pushToIncomeVC];
            break;
        case 1:
            [self pushToGroupOrderContainerViewController:0];
            break;
        case 2:
            [self pushToTeamVC];
            break;
        case 3:
            [self pushInvateVC];
            break;
        default:
            break;
    }
}
- (void)pushInvateVC{
    if (![XLTUserManager shareManager].isInvited) {
        if ([XLTAppPlatformManager shareManager].checkEnable) {
            // 邀请页面
            [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
            XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
            [self.navigationController pushViewController:updateMyInviterVC animated:YES];
            return;
        }
    }
    XLTUserInvateVC *vc = [[XLTUserInvateVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToTeamVC{
    if (![XLTUserManager shareManager].isInvited) {
        if ([XLTAppPlatformManager shareManager].checkEnable) {
            // 邀请页面
            [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
            XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
            [self.navigationController pushViewController:updateMyInviterVC animated:YES];
            return;
        }
    }
    XLTMyTeamVC *vc = [[XLTMyTeamVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)logoutSuccessAction {
    [self.userHeaderView reloadView:NO];
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.categoryView selectItemAtIndex:0];
    [self.pagerView reloadData];
}

- (void)requestDataWithLoading:(BOOL)showLoading {
    __weak typeof(self)weakSelf = self;
    [[XLTAdManager shareManager] xingletaonetwork_requestAdListWithPosition:@"7" success:^(NSArray * _Nonnull adArray) {
      [weakSelf updateAdInfo:adArray];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf updateAdInfo:nil];
    }];
    if (![XLTUserManager shareManager].isLogined) {
//        [self letaoShowLoading];
    } else {
        if (showLoading) {
            [self letaoShowLoading];
        }
        [self getUserInfo];
        [self getBalanceInfo];
        [self getIncomeInfo];
      /*
        dispatch_group_t group = dispatch_group_create();
        XLT_WeakSelf;
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            XLT_StrongSelf;
            [self getUserInfo];
            
        });
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            XLT_StrongSelf;
            [self getBalanceInfo];
        });
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            XLT_StrongSelf;
            XLT_WeakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                XLT_StrongSelf;
                [self.userHeaderView reloadView:YES];
                [self letaoRemoveLoading];
            });
            
        });*/
    }
}


- (void)getUserInfo{
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestUserInfoSuccess:^(id balance) {
        XLT_StrongSelf;
        self.userHeaderView.userInfo = balance;
        [self.userHeaderView reloadView:YES];
        [self letaoRemoveLoading];
    } failure:^(NSString *errorMsg) {
        [self letaoRemoveLoading];
    }];
}
- (void)getBalanceInfo{
    [XLTUserInfoLogic xingletaonetwork_requestBalanceDetailSuccess:^(id balance) {
        self.userHeaderView.balanceInfo = balance;
        [self.userHeaderView reloadView:YES];
        [self letaoRemoveLoading];
    } failure:^(NSString *errorMsg) {
        [self letaoRemoveLoading];
    }];
}
- (void)getIncomeInfo{
    [XLTUserInfoLogic xingletaonetwork_requestUserIncomeWithId:[XLTUserManager shareManager].curUserInfo._id Success:^(id balance) {
        self.userHeaderView.income = balance;
        [self.userHeaderView reloadView:YES];
        [self letaoRemoveLoading];
    } failure:^(NSString *errorMsg) {
        [self letaoRemoveLoading];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [[XLTAppPlatformManager shareManager] xingletaonetwork_requestLimitModelStatus:nil];
    [[XLTAppPlatformManager shareManager] requestSupportGoodsPlatform];
    [self requestDataWithLoading:NO];
}

- (void)updateAdInfo:(NSArray * _Nullable)adInfo {
    if ([adInfo isKindOfClass:[NSArray class]]) {
        self.adInfo = adInfo;
    } else {
        self.adInfo = nil;
    }
    [self.userHeaderView setAdModel:self.adInfo];
}

- (BOOL)haveValidAd {
    return self.adInfo != nil;
}


- (void)adBannerClickAction:(NSDictionary *)ad {
    [[XLTAdManager shareManager] adJumpWithInfo:ad sourceController:self];
    if ([self.adInfo isKindOfClass:[NSArray class]]) {
//        NSString *adId = self.adInfo[@"_id"];
//        [[XLTAdManager shareManager] repoAdClickWitdAdId:adId];
//
//        // 汇报事件
//        NSMutableDictionary *properties = @{}.mutableCopy;
//        properties[@"xlt_item_id"] = self.adInfo[@"_id"];
//        properties[@"xlt_item_title"] = self.adInfo[@"title"];
//        properties[@"xlt_item_ad_platform"] = self.adInfo[@"platform"];
//        properties[@"xlt_item_ad_position"] = self.adInfo[@"show_position"];
//        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_AD properties:properties];
    }
}

- (void)initSubViews {
//    XLT_WeakSelf;
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
//        _userHeaderView = (XLTUserHeaderView *)[[XLTUserLimitHeaderView alloc] initWithNib];
//        _userHeaderView.orderButtonClickBlock = ^(NSInteger index) {
//             XLT_StrongSelf;
//            XLTLimitOrderContainerVC *orderContainerViewController = [[XLTLimitOrderContainerVC alloc] init];
//            orderContainerViewController.letaoDefaultSelectedIndex = index;
//            [self.navigationController pushViewController:orderContainerViewController animated:YES];
//        };
    } else {
        _userHeaderView = [[XLTUserHeaderView alloc] initWithNib];
        _userHeaderView.delegate = self;
    }
    
    
    [self setBlocks];
    
    // pagerView
    self.pagerView = [self preferredPagingView];
    self.pagerView.pinSectionHeaderVerticalOffset = (NSInteger)kSafeAreaInsetsTop;
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    
    __weak typeof(self)weakSelf = self;
    self.pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.recommendViewController = nil;
        self.footprintViewController = nil;
        self.categoryView.defaultSelectedIndex = 0;
        [self.categoryView reloadData];
        [self.pagerView reloadData];
        [self requestDataWithLoading:NO];
        [[XLTAppPlatformManager shareManager] xingletaonetwork_requestLimitModelStatus:nil];
        [[XLTAppPlatformManager shareManager] requestSupportGoodsPlatform];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.pagerView.mainTableView.mj_header endRefreshing];
        });
    }];
    
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [self setupCategoryViewTitles];
    
     self.categoryView.backgroundColor = self.view.backgroundColor;
     self.categoryView.delegate = self;
     self.categoryView.titleColor = [UIColor colorWithHex:0xFF333333];
     self.categoryView.titleColorGradientEnabled = YES;
     self.categoryView.titleLabelZoomEnabled = NO;
     self.categoryView.titleLabelZoomEnabled = NO;
     self.categoryView.titleFont = [UIFont letaoMediumBoldFontWithSize:16.0];
     self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.hidden = ([XLTAppPlatformManager shareManager].isLimitModel);
    [self letaoSetupCustomNavView];

}

- (void)setupCategoryViewTitles {
    if (XLTAppPlatformManager.shareManager.checkEnable) {
        self.categoryView.titles = @[@"专属推荐",@"我的足迹"];
        self.categoryView.titleSelectedColor = [UIColor letaomainColorSkinColor];
    } else {
        self.categoryView.titles = @[@"— 猜你喜欢  —"];
        self.categoryView.titleSelectedColor = [UIColor colorWithHex:0xFF333333];
    }
}

- (void)setBlocks{
    XLT_WeakSelf;
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
        
//        _userHeaderView.orderButtonClickBlock = ^(NSInteger index) {
//            XLT_StrongSelf;
//            XLTLimitOrderContainerVC *orderContainerViewController = [[XLTLimitOrderContainerVC alloc] init];
//            orderContainerViewController.letaoDefaultSelectedIndex = index;
//            [self.navigationController pushViewController:orderContainerViewController animated:YES];
//        };
    }else{
        _userHeaderView.orderButtonClickBlock = ^(NSInteger index) {
             XLT_StrongSelf;
            if (![XLTUserManager shareManager].isLogined) {
                [[XLTUserManager shareManager] displayLoginViewController];
                return;
            }
            if (index == 4) {
                // 汇报事件
                [SDRepoManager xltrepo_trackEvent:XLT_EVENT_GETBACK_ORDER properties:nil];
                [self pushToOrderSeeksViewController];
            } else {
                [self pushToOrderContainerViewController:index];
            }
        };
    }
    _userHeaderView.pushVipOderVCBlock = ^{
        XLT_StrongSelf;
        [self pushToVipOrderVC];
    };
    _userHeaderView.merberClickBlock = ^(NSInteger index) {
        XLT_StrongSelf;
        [self memberClick:index];
    };
    _userHeaderView.pushSettingBlock = ^{
        XLT_StrongSelf;
        [self pushToSettingVC];
    };
    _userHeaderView.pushWithDrawBlock = ^{
        XLT_StrongSelf;
        [self pushToWithDrawVC];
    };
    _userHeaderView.pushWithBalanceBlock = ^{
        XLT_StrongSelf;
        [self pushToBalanceVC];
    };
    _userHeaderView.pushCollectionBlock = ^{
        XLT_StrongSelf;
        [self pushToCollectVC];
    };
    _userHeaderView.adClickBlock = ^(NSDictionary *ad){
        XLT_StrongSelf;
        [self adBannerClickAction:ad];
    };
}


- (void)letaoSetupCustomNavView {
    self.letaoCustomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
    self.letaoCustomNavView.alpha = 0;
    self.letaoCustomNavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.letaoCustomNavView];
    
    
    UILabel *letaoNavTitleLabel = [[UILabel alloc] init];
    letaoNavTitleLabel.text = @"我的";
    letaoNavTitleLabel.font = [UIFont letaoMediumBoldFontWithSize:18.0];
    letaoNavTitleLabel.textAlignment = NSTextAlignmentCenter;
    letaoNavTitleLabel.frame = CGRectMake(0, kStatusBarHeight, self.letaoCustomNavView.bounds.size.width, 44);
    [self.letaoCustomNavView addSubview:letaoNavTitleLabel];

//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(12, kStatusBarHeight +2, 40, 40);
////    [leftButton setImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"] forState:UIControlStateNormal];
//    leftButton.tag = 45564;
//    [leftButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.letaoCustomNavView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.letaoCustomNavView.bounds.size.width - 44 , kStatusBarHeight, 44, 44);
    [rightButton setImage:[UIImage imageNamed:@"xingletao_mine_header_setting"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:rightButton];
}

- (void)loginButtonAction {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
    }
}

- (void)settingButtonAction {
    [self pushToSettingVC];
}

- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
//    if (categoryView.selectedIndex != index) {
//        if (index == 0) {
//            [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_CATEGORY properties:@{@"xlt_item_title":@"专属推荐"}];
//        } else {
//            [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_CATEGORY properties:@{@"xlt_item_title":@"我的足迹"}];
//        }
//    }
    
    if (index == 1) {
        if ([XLTUserManager shareManager].isLogined) {
            return YES;
        } else {
            [[XLTUserManager shareManager] displayLoginViewController];
            return NO;
        }
    }
    return YES;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    //请务必实现该方法
    //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
    //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
    //如此一来就丧失了延迟加载的功能
    //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
    /*
    NSInteger diffIndex = labs(categoryView.selectedIndex - index);
     if (diffIndex > 1) {
         [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
     }else {
         [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
     }
     */
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = 80 + kSafeAreaInsetsTop;
    if (scrollView.contentOffset.y >= thresholdDistance) {
        self.letaoCustomNavView.alpha = 1.0;

    } else {
        if (scrollView.contentOffset.y >= thresholdDistance -kSafeAreaInsetsTop) {
            CGFloat percent = (scrollView.contentOffset.y -( thresholdDistance -kSafeAreaInsetsTop))/kSafeAreaInsetsTop;
            percent = MAX(0, MIN(1, percent));
            self.letaoCustomNavView.alpha = percent;
        } else {
            self.letaoCustomNavView.alpha = 0;
        }
    }
}


- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}


#pragma mark Action
- (void)pushToSettingVC {
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_SETTING properties:nil];

    if (![XLTAppPlatformManager shareManager].debugModel) {
        if (![XLTUserManager shareManager].isLogined) {
            [[XLTUserManager shareManager] displayLoginViewController];
            return;
        }
    }
    XLTUserSettingVC *setvc = [[XLTUserSettingVC alloc] init];
    [self.navigationController pushViewController:setvc animated:YES];
}
- (void)pushToWithDrawVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTUserWithDrawVC *setvc = [[XLTUserWithDrawVC alloc] init];
    [self.navigationController pushViewController:setvc animated:YES];
}
- (void)pushToBalanceVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTUserBalanceDrawVC *setvc = [[XLTUserBalanceDrawVC alloc] init];
    setvc.balanceModel = self.userHeaderView.balanceInfo;
    [self.navigationController pushViewController:setvc animated:YES];
}
- (void)pushToVipOrderVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTVipOrderViewController *setvc = [[XLTVipOrderViewController alloc] init];
    [self.navigationController pushViewController:setvc animated:YES];
}
- (void)pushToCollectVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTCollectVC *setvc = [[XLTCollectVC alloc] init];
//    setvc.balanceModel = self.userHeaderView.balanceInfo;
    [self.navigationController pushViewController:setvc animated:YES];
    
    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_COLLECTION properties:nil];
}
- (void)pushToIncomeVC{
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        return;
    }
    XLTIncomeVC *setvc = [[XLTIncomeVC alloc] init];
//    setvc.balanceModel = self.userHeaderView.balanceInfo;
    [self.navigationController pushViewController:setvc animated:YES];
}
- (NSUInteger)headerViewHeight {
    return self.userHeaderView.headerHeight;
}


- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
 
    return [self headerViewHeight];;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 44;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    if ([XLTUserManager shareManager].isLogined) {
        return self.categoryView.titles.count;
    } else {
        return 1;
    }
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        if (self.recommendViewController == nil) {
            XLTUserGoodsRecommendVC *recommendViewController = [[XLTUserGoodsRecommendVC alloc] init];
            recommendViewController.letaonavigationController = self.navigationController;
            self.recommendViewController = recommendViewController;
        }
        return self.recommendViewController;
    } else {
        if (self.footprintViewController == nil) {
            XLTUserFootPrintGoodsVC *footprintViewController = [[XLTUserFootPrintGoodsVC alloc] init];
            footprintViewController.letaonavigationController = self.navigationController;
            self.footprintViewController = footprintViewController;
          }
        return self.footprintViewController;
    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)pushToOrderContainerViewController:(NSInteger)index {
    XLTOrderContainerVC *orderContainerViewController = [[XLTOrderContainerVC alloc] init];
    orderContainerViewController.letaoDefaultSelectedIndex = index;
    [self.navigationController pushViewController:orderContainerViewController animated:YES];
}
- (void)pushToGroupOrderContainerViewController:(NSInteger)index{
//    XLTOrderContainerVC *orderContainerViewController = [[XLTOrderContainerVC alloc] init];
//    orderContainerViewController.letaoDefaultSelectedIndex = index;
//    orderContainerViewController.letaoIsGroupStyle = YES;
//    [self.navigationController pushViewController:orderContainerViewController animated:YES];
    XLTRootOrderVC *vc = [[XLTRootOrderVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_USER_ORDER properties:nil];
}

- (void)pushToOrderSeeksViewController {

    XLTOrderFindVC *orderSeeksViewController = [[XLTOrderFindVC alloc] initWithNibName:@"XLTOrderFindVC" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:orderSeeksViewController animated:YES];
}
#pragma mark - UserHeaderDelegate
- (void)reloadUserHeadView:(CGFloat)height{
    [self.pagerView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:UIViewAnimationCurveEaseInOut];
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
