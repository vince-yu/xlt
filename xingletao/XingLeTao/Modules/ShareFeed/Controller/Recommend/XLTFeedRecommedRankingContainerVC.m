//
//  XLTFeedRecommedRankingContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedRecommedRankingContainerVC.h"
#import "XLTScrolledPageView.h"
#import "HMSegmentedControl.h"
#import "XLTFeedRecommedRankingListVC.h"
#import "LetaoEmptyCoverView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "XLTMyRecommendVC.h"
#import "XLTUserManager.h"

@interface XLTFeedRecommedRankingContainerVC () <XLTFeedRecommedRankingListVCDelagate>
@property (nonatomic, strong) UIView *customBarView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) XLTScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic,strong) NSArray *channelInfoArray;
@property (nonatomic, strong) UIButton *myRecommedButton;

@end

@implementation XLTFeedRecommedRankingContainerVC

- (void)dealloc {
    [[XLTUserManager shareManager] removeObserver:self forKeyPath:@"curUserInfo.level"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
       [[XLTUserManager shareManager] addObserver:self forKeyPath:@"curUserInfo.level" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL hasChild = NO;
       if (self.channelInfoArray.count > 0) {
           NSDictionary *firstChannel = self.channelInfoArray.firstObject;
           if ([firstChannel isKindOfClass:[NSDictionary class]]) {
               NSString *pid = firstChannel[@"pid"];
               if ([pid isKindOfClass:[NSString class]] && pid.length > 0) {
                   // 存在二级分类
                   [self buildCustomBarView];
                   hasChild = YES;
               }
           }
       }
       // 重新构建channelInfoArray信息
       if (!hasChild) {

       }
    
    NSMutableDictionary *channelInfo = [NSMutableDictionary dictionary];
    channelInfo[@"title"] = @"实时推荐榜";
    channelInfo[@"_id"] = @"today";
    
    NSMutableDictionary *channelInfo2 = [NSMutableDictionary dictionary];
    channelInfo2[@"title"] = @"昨日推荐榜";
    channelInfo2[@"day-type"] = @"pre";
    channelInfo2[@"_id"] = @"yesterday";
    
    self.channelInfoArray = @[channelInfo,channelInfo2];
    
    [self buildCustomBarView];
    [self updateHomePages];
    [self buildMyRecommedButton];
}

- (void)buildMyRecommedButton {
    UIButton *myRecommedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myRecommedButton setTitle:@" 我的推荐" forState:UIControlStateNormal];
    [myRecommedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myRecommedButton setImage:[UIImage imageNamed:@"feed_recommend_white"] forState:UIControlStateNormal];
    myRecommedButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:15];
    myRecommedButton.layer.masksToBounds = YES;
    myRecommedButton.layer.cornerRadius = 20.0;
    UIImage *bgNormal = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFFAD01]] gradientType:1 imgSize:CGSizeMake(120, 40)];
    [myRecommedButton setBackgroundImage:bgNormal forState:UIControlStateNormal];
    [myRecommedButton addTarget:self action:@selector(myRecommedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    myRecommedButton.frame = CGRectMake(ceilf((kScreenWidth - 120)/2), (self.view.bounds.size.height - 40), 120, 40);
    myRecommedButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:myRecommedButton];
    self.myRecommedButton = myRecommedButton;
    [self showMyRecommedButtonIfNeed];
}

- (void)showMyRecommedButtonAnimate {
//    CGFloat tx = 0;
//    CGFloat ty = self.userNameTextField.frame.origin.y - self.welcomeLabel.frame.origin.y;
//    self.welcomeLabel.transform = CGAffineTransformMakeTranslation(tx, ty);
//    self.wishLabel.alpha = 0;
//
//    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.welcomeLabel.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.wishLabel.alpha = 1.0;
//        } completion:^(BOOL finished) {
//        }];
//    }];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.myRecommedButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeMyRecommedButtonAnimate {
    CGFloat tx = 0;
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        safeAreaInsetsBottom = keyWindow.safeAreaInsets.bottom;
    }
    CGFloat ty = safeAreaInsetsBottom + self.myRecommedButton.bounds.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.myRecommedButton.transform = CGAffineTransformMakeTranslation(tx, ty);
    } completion:^(BOOL finished) {
    }];
}

                         
- (void)myRecommedButtonAction {
    XLTMyRecommendVC *myRecommendVC = [[XLTMyRecommendVC alloc] init];
    [self.navigationController pushViewController:myRecommendVC animated:YES];
}

- (void)xlt_scrollPageViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        [self removeMyRecommedButtonAnimate];
    }
}

- (void)xlt_scrollPageViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self showMyRecommedButtonAnimate];
}

- (void)xlt_scrollPageViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self showMyRecommedButtonAnimate];
}

- (void)xlt_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
     [self showMyRecommedButtonAnimate];
}

- (void)buildCustomBarView {
    self.customBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.customBarView.backgroundColor = [UIColor whiteColor];
    self.customBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview: self.customBarView];
    
    // 配置`菜单视图`
    CGFloat segmentedControlWidth = self.customBarView.bounds.size.width - 40;
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(ceilf((self.customBarView.bounds.size.width - segmentedControlWidth)/2), 0, segmentedControlWidth, 40)];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.selectionIndicatorHeight = 2.5;
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
//    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:13.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF333333]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:13.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    _segmentedControl.sectionTitles = [self letaoSegmentTitlesArray];
    [_segmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.customBarView addSubview:_segmentedControl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.customBarView.bounds.size.height - 0.5, self.customBarView.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xFFEEEEF0];
    [self.customBarView addSubview:line];
    
}

- (void)reloadSegmentedControlData {
    _segmentedControl.sectionTitles = [self letaoSegmentTitlesArray];
    _segmentedControl.selectedSegmentIndex = 0;
}

- (NSArray *)letaoSegmentTitlesArray {
    if (self.channelInfoArray.count > 0 ) {
        NSMutableArray *channelArray = [[NSMutableArray alloc] init];
        [self.channelInfoArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *channelTitle = @"未知";
            if ([obj isKindOfClass:[NSDictionary class]] && [obj[@"title"] isKindOfClass:[NSString class]]) {
                channelTitle = obj[@"title"];
            }
            [channelArray addObject:channelTitle];
        }];
        return channelArray;
    } else {
        return @[@"全部"];
    }
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
}


- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor letaolightgreyBgSkinColor];
    [super letaoShowLoading];
    
}


- (void)requestChannelData {

//    if (self.channelInfoArray == nil) {
//        [self letaoShowLoading];
//    }
//    __weak typeof(self)weakSelf = self;
//    [XLTShareFeedLogic xingletaonetwork_requestChannelListSuccess:^(NSArray * _Nonnull channelArray) {
//        weakSelf.channelInfoArray = channelArray;
//        [weakSelf updateHomePages];
//        [weakSelf letaoRemoveLoading];
//        [weakSelf allChannelControllerEndRefreshing];
//    } failure:^(NSString * _Nonnull errorMsg) {
//        [weakSelf showTipMessage:errorMsg];
//        [weakSelf letaoRemoveLoading];
//        if (weakSelf.channelInfoArray == nil) {
//            [weakSelf letaoShowErrorView];
//        } else {
//            [weakSelf allChannelControllerEndRefreshing];
//        }
//    }];
}

- (void)updateHomePages {
    [self reloadSegmentedControlData];
    [self bulidPages];
}

- (void)letaoClearPageViews {
    for (XLTFeedRecommedRankingListVC *vc in self.childViewControllers) {
        // 推荐保留
        if(![vc isKindOfClass:[XLTFeedRecommedRankingListVC class]]) {
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
        }
    }
    
    if (_scrolledPageView != nil)  {
        _scrolledPageView.delegate = nil;
        _scrolledPageView.dataSource = nil;
        [_scrolledPageView removeFromSuperview];
        _scrolledPageView = nil;
    }
}

- (void)bulidPages {
    [self letaoClearPageViews];
    CGRect pageRect = CGRectMake(0, CGRectGetMaxY(self.customBarView.frame), self.view.bounds.size.width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.customBarView.frame));
    _scrolledPageView = [[XLTScrolledPageView alloc] initWithFrame:pageRect];
    _scrolledPageView.backgroundColor = [UIColor whiteColor];
    _scrolledPageView.shouldPreLoadSiblings = NO;
    _scrolledPageView.delegate = (id)self;
    _scrolledPageView.dataSource = (id)self;
    _scrolledPageView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrolledPageView];
}


- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    [_scrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.currentPageIndex = segmentedControl.selectedSegmentIndex;
}


- (NSString *)letaoChannelIdForPageIndex:(NSUInteger)pageIndex  {
    if (pageIndex < self.channelInfoArray.count) {
        NSDictionary *channelInfo = self.channelInfoArray[pageIndex];
        if ([channelInfo isKindOfClass:[NSDictionary class]] && [channelInfo[@"_id"] isKindOfClass:[NSString class]]) {
            return channelInfo[@"_id"];
        }
    }
    return @"0";
}

- (NSArray * _Nullable)letaoChildrenChannelListForPageIndex:(NSUInteger)pageIndex  {
    if (pageIndex < self.channelInfoArray.count) {
        NSDictionary *channelInfo = self.channelInfoArray[pageIndex];
        if ([channelInfo isKindOfClass:[NSDictionary class]] && [channelInfo[@"children"] isKindOfClass:[NSArray class]]) {
            return channelInfo[@"children"];
        }
    }
    return nil;
}


#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    return self.channelInfoArray.count;
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    NSString *letaoChannelId = [NSString stringWithFormat:@"recommed_%lu",(unsigned long)pageIndex];
    NSArray *tagArray = [self letaoChildrenChannelListForPageIndex:pageIndex];
    XLTFeedRecommedRankingListVC *viewController = [self pageViewControllerForChannelCode:letaoChannelId];

    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId tagArray:tagArray];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    
    if (pageIndex == 0) {
        viewController.rankingType = nil;
    } else {
        viewController.rankingType = @"pre";
    }
    return viewController;
}

- (XLTFeedRecommedRankingListVC *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTFeedRecommedRankingListVC *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTFeedRecommedRankingListVC class]]) {
            viewController = obj;
            if ([viewController.letaoChannelId isEqualToString:letaoChannelId]) {
                *stop = YES;
            } else {
                viewController = nil;
            }
        }
    }];
    return viewController;
}

- (XLTFeedRecommedRankingListVC *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId tagArray:(NSArray *)tagArray {
    return [self letaoCreateCategoryPageviewControllerForChannelCode:letaoChannelId tagArray:tagArray];
}

- (XLTFeedRecommedRankingListVC *)letaoCreateCategoryPageviewControllerForChannelCode:(NSString *)letaoChannelId tagArray:(NSArray *)tagArray {
    XLTFeedRecommedRankingListVC *listViewController = [[XLTFeedRecommedRankingListVC alloc] init];
    listViewController.delegate = self;
    listViewController.letaoChannelId = letaoChannelId;
    return listViewController;
}

- (NSString * _Nullable)fristTagForTagArray:(NSArray *)tagArray {
    NSDictionary *fristInfo = tagArray.firstObject;
    if ([fristInfo isKindOfClass:[NSDictionary class]]) {
        return fristInfo[@"_id"];
    }
    return nil;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrolledPageView.currentPageIndex < self.segmentedControl.sectionTitles.count) {
        [self.segmentedControl setSelectedSegmentIndex:_scrolledPageView.currentPageIndex animated:YES];
        self.currentPageIndex = _scrolledPageView.currentPageIndex;
    }
}



- (void)letaoShowEmptyView {
    if (self.letaoEmptyCoverView == nil) {
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无数据"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];
}

- (void)letaoRemoveEmptyView {
    [self.letaoEmptyCoverView removeFromSuperview];
}

- (void)letaoShowErrorView {
    if (self.letaoErrorView == nil) {
        __weak typeof(self)weakSelf = self;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xinletao_page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf letaoRemoveErrorView];
                                                                  [weakSelf requestChannelData];
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 28.f;
        letaoEmptyCoverView.contentViewOffset = - 50;
        
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:14.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        letaoEmptyCoverView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnHeight = 40.f;
        letaoEmptyCoverView.actionBtnHorizontalMargin = 62.f;
        letaoEmptyCoverView.actionBtnCornerRadius = 20.f;
        //        letaoEmptyCoverView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
        letaoEmptyCoverView.actionBtnBorderColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnBorderWidth = 0.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.letaoErrorView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoErrorView];
}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"curUserInfo.level"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMyRecommedButtonIfNeed];
        });
    }
}

- (void)showMyRecommedButtonIfNeed {
    BOOL show = [[XLTUserManager shareManager].curUserInfo.level isKindOfClass:[NSNumber class]] && [[XLTUserManager shareManager].curUserInfo.level integerValue] >2;
    self.myRecommedButton.hidden = !show;
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
