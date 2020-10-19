//
//  XLTNineYuanNineSecondContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/20.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNineYuanNineSecondContainerVC.h"
#import "XLTScrolledPageView.h"
#import "LetaoEmptyCoverView.h"
#import "HMSegmentedControl.h"
#import "XLTNineYuanNineListVC.h"
#import "XLTHomePageLogic.h"

@interface XLTNineYuanNineSecondContainerVC ()
@property (nonatomic, strong) XLTScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;

@property (nonatomic, strong) XLTHomePageLogic *letaoHomeLogic;
@property (nonatomic, strong) NSArray *plateArray;

@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic,strong) NSArray *channelInfoArray;
@end

@implementation XLTNineYuanNineSecondContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
    // Do any additional setup after loading the view.
    self.channelInfoArray = @[@{@"id":@"-1",@"name":@"精选"},
                              @{@"id":@"1",@"name":@"居家百货"},
                              @{@"id":@"2",@"name":@"美食"},
                              @{@"id":@"3",@"name":@"服饰"},
                              @{@"id":@"4",@"name":@"配饰"},
                              @{@"id":@"5",@"name":@"美妆"},
                              @{@"id":@"6",@"name":@"内衣"},
                              @{@"id":@"7",@"name":@"母婴"},
                              @{@"id":@"8",@"name":@"箱包"},
                              @{@"id":@"9",@"name":@"数码配件"},
                              @{@"id":@"10",@"name":@"文娱车品"}];
    [self buildSegmentedControl];
    [self updateHomePages];
}


- (void)buildSegmentedControl {
    // 配置`菜单视图`
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 44)];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.useCustomIndicatorBox = YES;
    _segmentedControl.selectionIndicatorHeight = 0.0;
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segmentedControl.selectionIndicatorBoxColor = [UIColor letaomainColorSkinColor];
    _segmentedControl.selectionIndicatorBoxOpacity = 1.0;
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF151513]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [_segmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.sectionTitles = [self letaoSegmentTitlesArray];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];

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
            if ([obj isKindOfClass:[NSDictionary class]] && [obj[@"name"] isKindOfClass:[NSString class]]) {
                channelTitle = obj[@"name"];
            }
            [channelArray addObject:channelTitle];
        }];
        return channelArray;
    } else {
        return @[@"全部"];
    }
}



- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor letaolightgreyBgSkinColor];
    [super letaoShowLoading];
}


- (void)requestChannelData {
}

- (void)updateHomePages {
    [self reloadSegmentedControlData];
    [self bulidPages];
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


- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    [_scrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.currentPageIndex = segmentedControl.selectedSegmentIndex;
}


- (NSString *)letaoChannelIdForPageIndex:(NSUInteger)pageIndex  {
    if (pageIndex < self.channelInfoArray.count) {
        NSDictionary *channelInfo = self.channelInfoArray[pageIndex];
        if ([channelInfo isKindOfClass:[NSDictionary class]] && [channelInfo[@"id"] isKindOfClass:[NSString class]]) {
            return channelInfo[@"id"];
        }
    }
    return @"0";
}

#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    return self.channelInfoArray.count;
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    NSString *letaoChannelId = [self letaoChannelIdForPageIndex:pageIndex];
    UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
    
    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTNineYuanNineListVC *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTNineYuanNineListVC class]]){
            viewController = obj;
            if ([viewController.nine_cid isEqualToString:letaoChannelId]) {
                *stop = YES;
            } else {
                viewController = nil;
            }
        }
    }];
    return viewController;
}

- (UIViewController *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId {
    return [self letaoCreateCategoryPageviewControllerForChannelCode:letaoChannelId];
}

- (XLTNineYuanNineListVC *)letaoCreateCategoryPageviewControllerForChannelCode:(NSString *)letaoChannelId {
    XLTNineYuanNineListVC *listViewController = [[XLTNineYuanNineListVC alloc] init];
    listViewController.nine_cid = letaoChannelId;
    listViewController.item_source = self.item_source;
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

@end
