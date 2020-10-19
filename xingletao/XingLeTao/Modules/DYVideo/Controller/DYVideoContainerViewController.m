//
//  DYVideoContainerViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYVideoContainerViewController.h"
#import "HMSegmentedControl.h"
#import "XLTVideoListModel.h"
#import "XLTVideoLogic.h"
#import "LetaoEmptyCoverView.h"
#import "DYVideoListViewController.h"
#import "JXPagerView.h"
#import "JXCategoryTitleView.h"
#import "JXPagerListRefreshView.h"
#import "JXCategoryIndicatorLineView.h"

@interface DYVideoContainerViewController ()<JXCategoryViewDelegate,JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIScrollViewDelegate>
@property (nonatomic ,strong)  JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerView *letaoJXPagerView;
@property (nonatomic ,strong) UIView *pageView;

@property (nonatomic ,strong) NSArray *cidArray;
@property (nonatomic ,strong) NSArray *cTitleArray;
@property (nonatomic ,strong) NSArray *categaryArray;
@property (nonatomic ,strong) LetaoEmptyCoverView *letaoEmptyCoverView;

@property (nonatomic ,strong) UIView *navView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;

//@property (nonatomic ,strong) NSMutableArray *childrenVC;
@end

@implementation DYVideoContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:0x17151C];
    [self.view addSubview:self.letaoJXPagerView];
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.backBtn];
    [self.navView addSubview:self.nameLabel];
//    [self.view addSubview:self.pageView];
    
    
    [self.pageView addSubview:self.categoryView];
    
    
    self.pageView.backgroundColor = [UIColor colorWithHex:0x17151C];
    self.letaoJXPagerView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
    self.letaoJXPagerView.backgroundColor = [UIColor colorWithHex:0x17151C];
    self.letaoJXPagerView.mainTableView.backgroundColor = [UIColor colorWithHex:0x17151C];
    self.letaoJXPagerView.mainTableView.tableHeaderView.backgroundColor = [UIColor colorWithHex:0x17151C];
    self.letaoJXPagerView.listContainerView.collectionView.backgroundColor = [UIColor colorWithHex:0x17151C];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor whiteColor];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
    lineView.indicatorLineWidth = 40;
    lineView.indicatorLineViewHeight = 1;
    self.categoryView.indicators = @[lineView];

    
    [self requstCategary];
    
}
- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}
#pragma mark Lazy
- (UIView *)pageView{
    if (!_pageView) {
        _pageView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, 35)];
        _pageView.backgroundColor = [UIColor colorWithHex:0x17151C];
    }
    return _pageView;
}
- (JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
//        _categoryView.defaultSelectedIndex = self.letaoDefaultSelectedIndex;
        
//        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
//        [array addObjectsFromArray:self.plateNameArray];
//
//        _categoryView.titles =  array;;
        _categoryView.backgroundColor = [UIColor colorWithHex:0x17151C];;
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = [UIColor whiteColor];
        _categoryView.titleColor = [UIColor colorWithWhite:1 alpha:0.4];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleFont = [UIFont letaoRegularFontWithSize:16.0];
    //    _categoryView.titleLabelStrokeWidthEnabled = YES;
        _categoryView.contentScrollView = _letaoJXPagerView.listContainerView.collectionView;
    }
    return _categoryView;
}
- (JXPagerView *)letaoJXPagerView{
    if (!_letaoJXPagerView) {
        _letaoJXPagerView = [self preferredPagingView];
//        _letaoJXPagerView.defaultSelectedIndex = self.letaoDefaultSelectedIndex;
        _letaoJXPagerView.pinSectionHeaderVerticalOffset = 0;
        _letaoJXPagerView.mainTableView.gestureDelegate = self;
    }
    return _letaoJXPagerView;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeLeft;
        [_backBtn setFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _backBtn;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _nameLabel.text = @"抖券";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:19];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.center = CGPointMake(self.navView.center.x, self.backBtn.center.y);
    }
    return _nameLabel;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopHeight)];
        _navView.backgroundColor = [UIColor colorWithHex:0x17151C];;
//        UIImageView *_letaobgImageView = [[UIImageView alloc] initWithFrame:_navView.bounds];
//        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFF8A28],[UIColor colorWithHex:0xFF5221]] gradientType:1 imgSize:_letaobgImageView.bounds.size];
//        _letaobgImageView.image = bgImage;
//        [_navView addSubview:_letaobgImageView];
        
    }
    return _navView;
}
- (void)requstCategary{
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTVideoLogic getVideoCategarySuccess:^(id object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        if ([object isKindOfClass:[NSArray class]]) {
            [self handleCategary:object];
        }else{
            [self letaoShowEmptyView];
        }
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self letaoShowEmptyView];
        [self letaoRemoveLoading];
    }];
}
- (void)handleCategary:(NSArray *)array{
    self.categaryArray = array;
    NSMutableArray *cidArray = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];

    for (XLTVideoCategaryModel *model in self.categaryArray) {
        NSString *cid = model.cid;
        NSString *title = model.title;
        if (cid.length && title.length) {
            [cidArray addObject:cid];
            [titleArray addObject:title];
        }
    }
    self.cidArray = cidArray;
    self.cTitleArray = titleArray;
    self.categoryView.titles = self.cTitleArray;
    [self.categoryView reloadData];
    [self.letaoJXPagerView reloadData];
//    [self configSegment];
}
- (void)configSegment{
    for (NSInteger i = 0; i < self.cidArray.count; i ++) {
        NSString *cid = [self.cidArray objectAtIndex:i];
        DYVideoListViewController *vc = [[DYVideoListViewController alloc] init];
        vc.cid = cid;
        vc.xlt_navigationController = self.navigationController;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight - kTopHeight - 30);
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
    [self.letaoJXPagerView.mainTableView addSubview:self.letaoEmptyCoverView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"srollview x is ....");
}
#pragma mark JXPageView
- (JXPagerView *)preferredPagingView {
    return [[JXPagerListRefreshView alloc] initWithDelegate:self];
}
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
- (NSUInteger)letaoTopHeaderHeight {
    return 0.001;
}
//
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:0x17151C];
    return view;
}
//
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
 
    return 0.0001;
}
//
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return  35;
}
//
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithHex:0x17151C];
//    return view;
    return self.pageView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    NSArray *plateArray = self.cidArray;
    NSString *plate = @"";
    if (index >=0 && (index < [plateArray count])) {
        plate = [self.cidArray objectAtIndex:index];
    }
//    self.letaoOrderSource = plate;
    DYVideoListViewController *orderListViewController = [[DYVideoListViewController alloc] init];
    orderListViewController.cid = plate;
    orderListViewController.xlt_navigationController = self.navigationController;
    
    
    return orderListViewController;
   
}
@end
