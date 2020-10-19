//
//  XLTHomePlateContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomePlateContainerVC.h"
#import "XLTHomeCustomHeadBgView.h"
#import "XLTScrolledPageView.h"
#import "XLTHomePageLogic.h"
#import "XLTHomePlateListVC.h"
#import "LetaoEmptyCoverView.h"
#import "HMSegmentedControl.h"

@interface XLTHomePlateContainerVC () <XLTScrolledPageViewViewDelegate, XLTScrolledPageViewDataSource>
@property (nonatomic, strong) XLTHomeCustomHeadBgView *letaoTopHeadView;
@property (nonatomic, strong) XLTScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;

@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@property (nonatomic, strong) NSArray *plateArray;

@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

@implementation XLTHomePlateContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = self.plateName;
    [self requestHomePlateData];
    [self letaoSetupTopHeadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoconfigTranslucentNavigation];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)requestHomePlateData {
    if (self.letaoHomeLogic == nil) {
        self.letaoHomeLogic = [[XLTHomePageLogic alloc] init];
    }
    if (self.plateArray.count == 0) {
        [self letaoShowLoading];
    }
    __weak typeof(self)weakSelf = self;
    [self.letaoHomeLogic xingletaonetwork_requestHomePlateDataForPlateId:self.letaoCurrentPlateId success:^(NSArray * _Nonnull plateArray) {
        if (plateArray.count > 0) {
            weakSelf.plateArray = plateArray;
            [weakSelf updateHomePages];
        } else {
            [weakSelf letaoShowEmptyView];
        }
        [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
        [weakSelf letaoShowErrorView];
    }];
}

- (void)updateHomePages {
    [self letaoSetupSegmentedControl];
    [self bulidPages];
}

- (void)letaoSetupTopHeadView {
    XLTHomeCustomHeadBgView *letaoTopHeadView = [[XLTHomeCustomHeadBgView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XLTHomeCustomHeadView letaoDefaultHeight])];
    [self.view addSubview:letaoTopHeadView];
    
}

- (NSArray *)letaoSegmentTitlesArray {
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



- (void)letaoSetupSegmentedControl {
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
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.sectionTitles = [self letaoSegmentTitlesArray];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];

}


- (void)bulidPages {
    CGRect pageRect = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), self.view.bounds.size.width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.segmentedControl.frame));
    _scrolledPageView = [[XLTScrolledPageView alloc] initWithFrame:pageRect];
    _scrolledPageView.backgroundColor = [UIColor whiteColor];
    _scrolledPageView.shouldPreLoadSiblings = NO;
    _scrolledPageView.delegate = (id)self;
    _scrolledPageView.dataSource = (id)self;
    _scrolledPageView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrolledPageView];
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [_scrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.currentPageIndex = segmentedControl.selectedSegmentIndex;
}

#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    return self.plateArray.count;
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    NSString *letaoChannelId = [self plateCodeForIndex:pageIndex];
    UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
    
    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    if ([viewController isKindOfClass:[XLTHomePlateListVC class]]) {
        XLTHomePlateListVC *vc = (XLTHomePlateListVC *)viewController;
        vc.letaoParentPlateName = self.plateName;
        vc.plateName = [self plateNameForIndex:pageIndex];
        [vc repoViewPage];
    }
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTHomePlateListVC *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTHomePlateListVC class]]) {
            viewController = obj;
            if ([viewController.plateCode isEqualToString:letaoChannelId]) {
                *stop = YES;
            } else {
                viewController = nil;
            }
        }
    }];
    return viewController;
}

- (UIViewController *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId {
    XLTHomePlateListVC *listViewController = [[XLTHomePlateListVC alloc] init];
    listViewController.plateCode = letaoChannelId;
    listViewController.plateType = self.plateType;
    listViewController.letaoParentPlateId = self.letaoCurrentPlateId;
    return listViewController;
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
        letaoEmptyCoverView.backgroundColor = [UIColor clearColor];
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];

}

- (NSString *)plateNameForIndex:(NSUInteger)index {
     NSString *plateName = nil;
    if (index < self.plateArray.count) {
        NSDictionary *plate = self.plateArray[index];
        if ([plate isKindOfClass:[NSDictionary class]]) {
             plateName = plate[@"title"];
        }
    }
    if (![plateName isKindOfClass:[NSString class]]) {
        plateName = [NSString stringWithFormat:@"未知%luld",(unsigned long)index];
    }
    return plateName;
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
                                                                  [weakSelf requestHomePlateData];
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
        letaoEmptyCoverView.backgroundColor = [UIColor clearColor];
        self.letaoErrorView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoErrorView];

}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}

- (void)homeRecommendTriggerRefreshAction {
    [self requestHomePlateData];
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
