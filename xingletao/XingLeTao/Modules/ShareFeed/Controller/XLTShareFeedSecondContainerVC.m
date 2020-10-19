//
//  XLTShareFeedSecondContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTShareFeedSecondContainerVC.h"
#import "XLTScrolledPageView.h"
#import "HMSegmentedControl.h"
#import "XLTShareFeedLogic.h"
#import "XLTShareFeedListVC.h"
#import "XLTShareAllChanelFeedListVC.h"
#import "LetaoEmptyCoverView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface XLTShareFeedSecondContainerVC ()
@property (nonatomic, strong) UIView *customBarView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) XLTScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;
@end

@implementation XLTShareFeedSecondContainerVC

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
        NSMutableDictionary *channelInfo = [NSMutableDictionary dictionary];
        channelInfo[@"_id"] = self.letaoChannelId;
        self.channelInfoArray = @[channelInfo];
    }
    [self updateHomePages];
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
    for (XLTShareFeedListVC *vc in self.childViewControllers) {
        // 推荐保留
        if(![vc isKindOfClass:[XLTShareAllChanelFeedListVC class]]) {
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
    NSString *letaoChannelId = [self letaoChannelIdForPageIndex:pageIndex];
    NSArray *tagArray = [self letaoChildrenChannelListForPageIndex:pageIndex];
    UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
    
    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId tagArray:tagArray];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTShareFeedListVC *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTShareFeedListVC class]]
            || [obj isKindOfClass:[XLTShareAllChanelFeedListVC class]]){
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

- (UIViewController *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId tagArray:(NSArray *)tagArray {
    if ([letaoChannelId isEqualToString:@"0"]) {
        return [self letaoCreateRecommendVCForChannelCode:letaoChannelId tagArray:tagArray];
    } else {
        return [self letaoCreateCategoryPageviewControllerForChannelCode:letaoChannelId tagArray:tagArray];
    }
}

- (XLTShareAllChanelFeedListVC *)letaoCreateRecommendVCForChannelCode:(NSString *)letaoChannelId tagArray:(NSArray *)tagArray {
    XLTShareAllChanelFeedListVC *listViewController = [[XLTShareAllChanelFeedListVC alloc] init];
    listViewController.rootChannelId = self.letaoChannelId;
    listViewController.letaoChannelId = @"0";
    listViewController.tagArray = tagArray;
    listViewController.currentTag = [self fristTagForTagArray:tagArray];
    return listViewController;
}

- (XLTShareFeedListVC *)letaoCreateCategoryPageviewControllerForChannelCode:(NSString *)letaoChannelId tagArray:(NSArray *)tagArray {
    XLTShareFeedListVC *listViewController = [[XLTShareFeedListVC alloc] init];
    listViewController.rootChannelId = self.letaoChannelId;
    listViewController.letaoChannelId = letaoChannelId;
    listViewController.tagArray = tagArray;
    listViewController.currentTag = [self fristTagForTagArray:tagArray];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
