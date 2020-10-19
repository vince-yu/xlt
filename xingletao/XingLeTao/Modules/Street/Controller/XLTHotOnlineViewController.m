//
//  XLTHotOnlineViewController.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHotOnlineViewController.h"
#import "XLTHotOnlineHeadView.h"
#import "XLTScrolledPageView.h"
#import "XLDStreetLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTHotOnlineAllViewController.h"
#import "XLTHotOnlineCategoryViewController.h"
#import "XLTSearchViewController.h"

@interface XLTHotOnlineViewController ()
@property (nonatomic, strong) XLTHotOnlineHeadView *letaoTopHeadView;
@property (nonatomic, strong) XLTScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;
@property (nonatomic, strong) NSMutableArray *letaoPageDataArray;
@end

@implementation XLTHotOnlineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestCelebrityPageData];
    [self letaoSetupTopHeadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    
    [[XLTRepoDataManager shareManager] repoRedStreetWithPlate:self.letaoParentPlateId childPlate:@"500001"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)requestCelebrityPageData {
    if (self.letaoPageDataArray == nil) {
        [self letaoShowLoading];
    }
    __weak typeof(self)weakSelf = self;
    [XLDStreetLogic xingletaonetwork_requestRedCateListSuccess:^(id  _Nonnull balance) {
        weakSelf.letaoPageDataArray = balance;
        [weakSelf reloadLetaoPages];
        [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showTipMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
        if (weakSelf.letaoPageDataArray == nil) {
            [weakSelf letaoShowErrorView];
        } else {
            [weakSelf letaoEndRefreshState];
        }
    }];
}

- (void)reloadLetaoPages {
    [self letaoSetupSegmentedControl];
    [self bulidPages];
}

- (void)letaoEndRefreshState {
    for (XLTHotOnlineAllViewController *vc in self.childViewControllers) {
         if([vc isKindOfClass:[XLTHotOnlineAllViewController class]]) {
             [vc letaoEndRefreshState];
         }
     }
}

- (void)letaoPopAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)letaoSearchAction {
    XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:NO];
}


- (void)letaoSetupTopHeadView {
    XLTHotOnlineHeadView *letaoTopHeadView = [[XLTHotOnlineHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XLTHotOnlineHeadView headViewDefaultHeight])];
    [letaoTopHeadView.leftButton addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
    [letaoTopHeadView.searchButton addTarget:self action:@selector(letaoSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [letaoTopHeadView letaoSetupSegmentedControl];
    [self.view addSubview:letaoTopHeadView];
    self.letaoTopHeadView = letaoTopHeadView;
    self.letaoTopHeadView.segmentedControl.sectionTitles = @[@"全部"];
    self.letaoTopHeadView.segmentedControl.hidden = YES;
    [self.letaoTopHeadView.segmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSArray *)letaoSegmentTitlesArray {
    if (self.letaoPageDataArray.count > 0 ) {
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        [self.letaoPageDataArray enumerateObjectsUsingBlock:^(XLTHomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name) {
                [categoryArray addObject:obj.name];
            } else {
                [categoryArray addObject:@"未知"];
            }
        }];
        return categoryArray;
    } else {
        XLTHomeCategoryModel *defualtCategory = [XLDStreetLogic letaoDefualtCategory];
        return @[defualtCategory.name];
    }
}




- (void)letaoSetupSegmentedControl {
    self.letaoTopHeadView.segmentedControl.sectionTitles = [self letaoSegmentTitlesArray];
    self.letaoTopHeadView.segmentedControl.selectedSegmentIndex = 0;
    self.letaoTopHeadView.segmentedControl.hidden = NO;
}

- (void)letaoClearPageViews {
    for (XLTHotOnlineAllViewController *vc in self.childViewControllers) {
        // 推荐保留
        if(![vc isKindOfClass:[XLTHotOnlineAllViewController class]]) {
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
    CGRect pageRect = CGRectMake(0, CGRectGetMaxY(self.letaoTopHeadView.segmentedControl.frame), self.view.bounds.size.width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.letaoTopHeadView.segmentedControl.frame));
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

#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    return self.letaoPageDataArray.count;
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    XLTHomeCategoryModel *category = [self.letaoPageDataArray objectAtIndex:pageIndex];
    NSString *letaoChannelId = category._id;
    UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
    
    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTHotOnlineCategoryViewController *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTHotOnlineAllViewController class]]
            || [obj isKindOfClass:[XLTHotOnlineCategoryViewController class]]){
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

- (UIViewController *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId {
    XLTHomeCategoryModel *defualtCategory = [XLDStreetLogic letaoDefualtCategory];
    if ([letaoChannelId isEqualToString:defualtCategory._id]) {
        return [self letaoCreateRecommendVCForChannelCode:letaoChannelId];
    } else {
        return [self letaoCreateCategoryPageviewControllerForChannelCode:letaoChannelId];
    }
}

- (XLTHotOnlineAllViewController *)letaoCreateRecommendVCForChannelCode:(NSString *)letaoChannelId {
    XLTHotOnlineAllViewController *listViewController = [[XLTHotOnlineAllViewController alloc] init];
    listViewController.letaoChannelId = letaoChannelId;
    listViewController.letaoParentPlateId = self.letaoParentPlateId;
    return listViewController;
}

- (XLTHotOnlineCategoryViewController *)letaoCreateCategoryPageviewControllerForChannelCode:(NSString *)letaoChannelId {
    XLTHotOnlineCategoryViewController *listViewController = [[XLTHotOnlineCategoryViewController alloc] init];
    listViewController.letaoChannelId = letaoChannelId;
    listViewController.letaoParentPlateId = self.letaoParentPlateId;
    return listViewController;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrolledPageView.currentPageIndex < self.letaoTopHeadView.segmentedControl.sectionTitles.count) {
        [self.letaoTopHeadView.segmentedControl setSelectedSegmentIndex:_scrolledPageView.currentPageIndex animated:YES];
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
                                                                  [weakSelf requestCelebrityPageData];
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
