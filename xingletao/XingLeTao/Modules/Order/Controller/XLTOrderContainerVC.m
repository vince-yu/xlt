//
//  XLTOrderContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderContainerVC.h"
#import "JXPagerListRefreshView.h"
#import "JXCategoryTitleView.h"
#import "XLTOrderListVC.h"
#import "JXCategoryIndicatorLineView.h"
#import "XLTHomePageLogic.h"
#import "XLTOrderSearchVC.h"
#import "XLTCustomPickDateView.h"
#import "XLTAppPlatformManager.h"


@interface XLTOrderContainerVC () <JXCategoryViewDelegate,JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, PickerDateViewDelegate>

@property (nonatomic, strong) UIView *letaoCustomNavView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, copy, nullable) NSString *letaoOrderSource;

@property (nonatomic ,strong) XLTCustomPickDateView *letaoDatePickView;
@property (nonatomic ,strong) UIView *pageView;
@property (nonatomic ,strong) UIView *orderStatusView;
@property (nonatomic ,strong) NSNumber *orderStatus;
//@property (nonatomic ,strong) NSString *orderPlate;

@property (nonatomic ,strong) NSMutableArray *plateCodeArray;
@property (nonatomic ,strong) NSMutableArray *plateNameArray;


@end

@implementation XLTOrderContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.letaoOrderSource = @"";
    [self configPlateArray];
//    [self loadTopOrdeSourceView];
    
    // pagerView
    self.letaoJXPagerView = [self preferredPagingView];
    self.letaoJXPagerView.defaultSelectedIndex = self.letaoDefaultSelectedIndex;
    self.letaoJXPagerView.pinSectionHeaderVerticalOffset = 0;
    self.letaoJXPagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.letaoJXPagerView];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.categoryView.defaultSelectedIndex = self.letaoDefaultSelectedIndex;
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    [array addObjectsFromArray:self.plateNameArray];
    
    self.categoryView.titles =  array;;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor letaomainColorSkinColor];
    self.categoryView.titleColor = [UIColor colorWithHex:0xFF25282D];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleFont = [UIFont letaoRegularFontWithSize:16.0];
//    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.contentScrollView = self.letaoJXPagerView.listContainerView.collectionView;
  
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor letaomainColorSkinColor];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    self.categoryView.indicators = @[lineView];
    if (![XLTAppPlatformManager shareManager].checkEnable) {
        [self letaoSetupCustomNavView];
    }
    self.pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    [self.pageView addSubview:self.categoryView];
    [self.pageView addSubview:self.orderStatusView];
    
    
    
}

- (NSMutableArray *)plateCodeArray{
    if (!_plateCodeArray) {
        _plateCodeArray = [[NSMutableArray alloc] init];
    }
    return _plateCodeArray;
}
- (NSMutableArray *)plateNameArray{
    if (!_plateNameArray) {
        _plateNameArray = [[NSMutableArray alloc] init];
    }
    return _plateNameArray;
}
- (void)configPlateArray{
    [self.plateNameArray removeAllObjects];
    [self.plateCodeArray removeAllObjects];
    for (NSDictionary *dic in [XLTAppPlatformManager shareManager].supportGoodsPlatformArrayForOrder) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *title = [dic objectForKey:@"name"];
            NSString *code = [dic objectForKey:@"code"];
            if (title && code) {
                [self.plateNameArray addObject:title];
                [self.plateCodeArray addObject:code];
            }
        }
    }
}

- (UIView *)orderStatusView{
    if (!_orderStatusView) {
        _orderStatusView = [[UIView alloc] init];
        _orderStatusView.frame = CGRectMake(15, 30, kScreenWidth - 30, 80);
        NSArray *statusArray = @[@"全部",@"即将到账",@"已到账",@"已失效"];
        CGFloat space = (kScreenWidth - 80 * statusArray.count - 30) / 4.0;
        for (int i = 0; i < statusArray.count; i ++) {
            NSString *title = [statusArray objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 12000 + i;
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
            btn.layer.cornerRadius = 15;
            [btn addTarget:self action:@selector(selectOrderStatusBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(i * space + 80 * i, 30, 80, 30);
            [_orderStatusView addSubview:btn];
        }
        [self selectOrderStatus:0];
    }
    return _orderStatusView;
}
- (void)selectOrderStatusBtn:(UIButton *)btn{
    NSInteger selectIndex = btn.tag - 12000;
    if (selectIndex == self.orderStatus.intValue) {
        return;
    }
    if (selectIndex == 3) {
        self.orderStatus = @10;
    }else{
        self.orderStatus = @(selectIndex);
    }
    [self selectOrderStatus:selectIndex];
    [self.letaoJXPagerView reloadData];
}
- (void)selectOrderStatus:(NSInteger )index{
    for (UIView *view in self.orderStatusView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag - 12000 == index) {
                btn.backgroundColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:2/255.0 alpha:0.1];
                [btn setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
                btn.layer.borderWidth = 1;
            }else{
                [btn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHex:0xF5F4F4];
                btn.layer.borderWidth = 0;
                
            }
        }
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (![XLTAppPlatformManager shareManager].checkEnable) {
        self.letaoJXPagerView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.view.bounds.size.width, self.view.bounds.size.height - kSafeAreaInsetsTop);
    }else{
        self.letaoJXPagerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
}


- (JXPagerView *)preferredPagingView {
    return [[JXPagerListRefreshView alloc] initWithDelegate:self];
}

- (void)letaoSetupCustomNavView {
    self.letaoCustomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
    self.letaoCustomNavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.letaoCustomNavView];
    
    
    UILabel *letaoNavTitleLabel = [[UILabel alloc] init];
    if (self.letaoIsGroupStyle) {
        letaoNavTitleLabel.text = @"粉丝订单";
    }else{
        letaoNavTitleLabel.text = @"我的订单";
    }
    
    letaoNavTitleLabel.font = [UIFont letaoMediumBoldFontWithSize:18.0];
    letaoNavTitleLabel.textAlignment = NSTextAlignmentCenter;
    letaoNavTitleLabel.frame = CGRectMake(0, kStatusBarHeight, self.letaoCustomNavView.bounds.size.width, 44);
    [self.letaoCustomNavView addSubview:letaoNavTitleLabel];

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, kStatusBarHeight , 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:leftButton];
    
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calendarButton.frame = CGRectMake(self.letaoCustomNavView.bounds.size.width - 44 -12, kStatusBarHeight , 44, 44);
    [calendarButton setImage:[UIImage imageNamed:@"xingletao_order_calendar_icon"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(calendarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:calendarButton];


    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(calendarButton.frame.origin.x - 44, kStatusBarHeight , 44, 44);
    [searchButton setImage:[UIImage imageNamed:@"xingletao_order_search_icon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:searchButton];
    
}

- (void)searchButtonAction {
    XLTOrderSearchVC *searchViewController = [[XLTOrderSearchVC alloc] init];
    searchViewController.letaoShowSegment = YES;
    [self.navigationController pushViewController:searchViewController animated:NO];
}


- (void)calendarButtonAction {
    [self.letaoDatePickView show];
}


- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSUInteger)letaoTopHeaderHeight {
    return 0;
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return [[UIView alloc] init];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
 
    return [self letaoTopHeaderHeight];
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 110;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.pageView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    NSArray *plateArray = self.plateNameArray;
    NSString *plate = @"";
    if (index >=1 && (index - 1 < [plateArray count])) {
        plate = [self.plateCodeArray objectAtIndex:index - 1];
    }
    self.letaoOrderSource = plate;
    XLTOrderListVC *orderListViewController = [[XLTOrderListVC alloc] init];
    orderListViewController.isGroup = self.letaoIsGroupStyle;
    orderListViewController.letaoOrderSource = self.letaoOrderSource;
    orderListViewController.letaoYearMonthText = self.letaoYearMonthText;
    orderListViewController.status = self.orderStatus;
    orderListViewController.title =  self.categoryView.titles[index];
    orderListViewController.letaonavigationController = self.navigationController;
    
    
    return orderListViewController;
   
}
#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)didChangedYearMonth:(NSString *)yearMonth {
    self.letaoYearMonthText = yearMonth;
    [self.letaoJXPagerView reloadData];
}

- (XLTCustomPickDateView *)letaoDatePickView {
        if (!_letaoDatePickView) {
    //        XLT_WeakSelf;
            _letaoDatePickView = [[XLTCustomPickDateView alloc] init];
            [_letaoDatePickView setIsAddYetSelect:NO];//是否显示至今选项
            [_letaoDatePickView setIsShowDay:NO];//是否显示日信息
            _letaoDatePickView.delegate = self;
            [_letaoDatePickView setDefaultTSelectYear:[NSDate date].year defaultSelectMonth:[NSDate date].month defaultSelectDay:10];//设定默认显示的日期
            [_letaoDatePickView.confirmButton setTitleColor:[UIColor colorWithHex:0xFF25282D] forState:UIControlStateNormal];
        }
        return _letaoDatePickView;
}

- (void)pickerDateView:(XLTBasePickView *)pickerDateView selectYear:(NSInteger)year selectMonth:(NSInteger)month selectDay:(NSInteger)day {
    NSString *monthString = nil;
    if (month > 9) {
        monthString = [NSString stringWithFormat:@"%ld",(long)month];
    } else {
        monthString = [NSString stringWithFormat:@"0%ld",(long)month];

    }
    NSString * yearMonth = [NSString stringWithFormat:@"%ld-%@",(long )year,monthString];
    [self didChangedYearMonth:yearMonth];
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
