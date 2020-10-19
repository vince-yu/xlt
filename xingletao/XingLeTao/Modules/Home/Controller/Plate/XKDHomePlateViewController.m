//
//  XKDHomePlateViewController.m
//  XingKouDai
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XKDHomePlateContainerViewController.h"
#import "XKDHeadBgView.h"
#import "XKDScrolledPageView.h"
#import "XKDHomeLogic.h"
#import "XKDHomePlateListViewController.h"
#import "XKDEmptyView.h"
#import "HMSegmentedControl.h"

@interface XKDHomePlateContainerViewController () <XKDScrolledPageViewViewDelegate, XKDScrolledPageViewDataSource>
@property (nonatomic, strong) XKDHeadBgView *homeHeadView;
@property (nonatomic, strong) XKDScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;

@property (nonatomic, strong) XKDHomeLogic *homeLogic;
@property (nonatomic, strong) NSArray *plateArray;

@property (nonatomic, strong) XKDEmptyView *emptyView;
@property (nonatomic, strong) XKDEmptyView *retryView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

@implementation XKDHomePlateContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = self.plateName;
    [self requestHomePagesLayoutData];
    [self bulidHomeHeadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self qqw_configTranslucentNavigation];
}

- (void)requestHomePagesLayoutData {
    if (self.homeLogic == nil) {
        self.homeLogic = [[XKDHomeLogic alloc] init];
    }
    if (self.plateArray.count == 0) {
        [self showLoadingView];
    }
    [self.homeLogic fetchHomePlateDataForPlateId:self.plateId success:^(NSArray * _Nonnull plateArray) {
        if (plateArray.count > 0) {
            self.plateArray = plateArray;
            [self updateHomePages];
        } else {
            [self showEmptView];
        }
        [self removeLoadingView];
    } failure:^(NSString * _Nonnull errorMsg) {
        [self showTipMessage:errorMsg];
        [self removeLoadingView];
        [self showRetryView];
    }];
}

- (void)updateHomePages {
    [self bulidSegmentedControl];
    [self bulidPages];
}

- (void)bulidHomeHeadView {
    XKDHeadBgView *homeHeadView = [[XKDHeadBgView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XKDHomeHeadView headViewDefaultHeight])];
    [self.view addSubview:homeHeadView];
    
}

- (NSArray *)segmentedControlSectionTitles {
    NSMutableArray *sectionTitles = [NSMutableArray array];
    [self.plateArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = nil;
        if ([obj isKindOfClass:[NSDictionary class]]) {
             title = obj[@"title"];
        }
        if (![title isKindOfClass:[NSString class]]) {
            title = @"未知";
        }
        [sectionTitles addObject:title];
    }];
    return sectionTitles;
}

- (NSString *)plateCodeForIndex:(NSUInteger)index {
     NSString *plateCode = nil;
    if (index < self.plateArray.count) {
        NSDictionary *plate = self.plateArray[index];
        if ([plate isKindOfClass:[NSDictionary class]]) {
             plateCode = plate[@"_id"];
        }
    }
    if (![plateCode isKindOfClass:[NSString class]]) {
        plateCode = [NSString stringWithFormat:@"未知%luld",(unsigned long)index];
    }
    return plateCode;
}


- (void)bulidSegmentedControl {
    // 配置`菜单视图`
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, kSafeAreaInsetsTop, self.view.bounds.size.width-20, 44)];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.useCustomIndicatorBox = YES;
    _segmentedControl.selectionIndicatorHeight = 0.0;
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segmentedControl.selectionIndicatorBoxColor = [UIColor whiteColor];
    _segmentedControl.selectionIndicatorBoxOpacity = 1.0;
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont xkd_RegularFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont xkd_MediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor xkd_mainColorSkinColor]};
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.sectionTitles = [self segmentedControlSectionTitles];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];

}


- (void)bulidPages {
    CGRect pageRect = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), self.view.bounds.size.width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.segmentedControl.frame));
    _scrolledPageView = [[XKDScrolledPageView alloc] initWithFrame:pageRect];
    _scrolledPageView.backgroundColor = [UIColor whiteColor];
    _scrolledPageView.shouldPreLoadSiblings = YES;
    _scrolledPageView.delegate = (id)self;
    _scrolledPageView.dataSource = (id)self;
    _scrolledPageView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrolledPageView];
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [_scrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.currentPageIndex = segmentedControl.selectedSegmentIndex;
}

#pragma mark - QQWScrolledPageViewViewDelegate & QQWScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    return self.plateArray.count;
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    NSString *channelCode = [self plateCodeForIndex:pageIndex];
    UIViewController *viewController = [self pageViewControllerForChannelCode:channelCode];
    
    if (viewController == nil) {
        viewController = [self createViewControllerForChannelCode:channelCode];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)channelCode {
    __block XKDHomePlateListViewController *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XKDHomePlateListViewController class]]) {
            viewController = obj;
            if ([viewController.plateCode isEqualToString:channelCode]) {
                *stop = YES;
            } else {
                viewController = nil;
            }
        }
    }];
    return viewController;
}

- (UIViewController *)createViewControllerForChannelCode:(NSString *)channelCode {
    XKDHomePlateListViewController *listViewController = [[XKDHomePlateListViewController alloc] init];
    listViewController.plateCode = channelCode;
    return listViewController;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrolledPageView.currentPageIndex < self.segmentedControl.sectionTitles.count) {
        [self.segmentedControl setSelectedSegmentIndex:_scrolledPageView.currentPageIndex animated:YES];
        self.currentPageIndex = _scrolledPageView.currentPageIndex;
    }
}


- (void)showEmptView {
    if (self.emptyView == nil) {
        XKDEmptyView *emptyView = [XKDEmptyView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无数据"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        emptyView.emptyViewIsCompleteCoverSuperView = YES;
        emptyView.subViewMargin = 14.f;
        emptyView.titleLabFont = [UIFont systemFontOfSize:15.f];
        emptyView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        self.emptyView = emptyView;
    }
    [self.view addSubview:self.emptyView];
}

- (void)removeEmptView {
    [self.emptyView removeFromSuperview];
}

- (void)showRetryView {
    if (self.retryView == nil) {
        __weak typeof(self)weakSelf = self;
        XKDEmptyView *emptyView = [XKDEmptyView emptyActionViewWithImageStr:@"page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf removeRetryView];
                                                                  [weakSelf requestHomePagesLayoutData];
                                                              }];
        emptyView.emptyViewIsCompleteCoverSuperView = YES;
        emptyView.subViewMargin = 28.f;
        emptyView.contentViewOffset = - 50;
        
        emptyView.titleLabFont = [UIFont systemFontOfSize:14.f];
        emptyView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        emptyView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        emptyView.actionBtnTitleColor = [UIColor xkd_mainColorSkinColor];
        emptyView.actionBtnHeight = 40.f;
        emptyView.actionBtnHorizontalMargin = 62.f;
        emptyView.actionBtnCornerRadius = 2.f;
        emptyView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
        emptyView.actionBtnBorderWidth = 0.5;
        emptyView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.retryView = emptyView;
    }
    [self.view addSubview:self.retryView];
}

- (void)removeRetryView {
    [self.retryView removeFromSuperview];
}

- (void)homeRecommendTriggerRefreshAction {
    [self requestHomePagesLayoutData];
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
