//
//  XLTRootOrderVC.m
//  XingLeTao
//
//  Created by SNQU on 2020/3/6.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTRootOrderVC.h"
#import "XLTOrderContainerVC.h"
#import "XLTCustomPickDateView.h"
#import "XLTOrderSearchVC.h"
#import "HMSegmentedControl.h"
#import "XLTOrderFindVC.h"

@interface XLTRootOrderVC ()<PickerDateViewDelegate>
@property (nonatomic, strong) UIView *letaoCustomNavView;
@property (nonatomic ,strong) XLTOrderContainerVC *userOrderVC;
@property (nonatomic ,strong) XLTOrderContainerVC *teamOrderVC;
@property (nonatomic ,strong) XLTCustomPickDateView *letaoDatePickView;
@property (nonatomic ,strong) UIView *segemetControl;
@property (nonatomic, copy, nullable) NSString *letaoYearMonthText;
@property (nonatomic ,strong) UIButton *leftSegmentBtn;
@property (nonatomic ,strong) UIButton *rightSegmentBtn;
@property (nonatomic ,weak) XLTOrderContainerVC *currentVC;
@property (nonatomic ,strong) UIView *searchView;
@end

@implementation XLTRootOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupCustomNavView];
    
    self.currentVC = self.userOrderVC;
    [self.view addSubview:self.userOrderVC.view];
    [self configSearchView];
}
- (void)configSearchView{
    if (!self.searchView) {
        self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60 + kBottomSafeHeight)];
        self.searchView.backgroundColor = [UIColor colorWithHex:0xEEEBEB];
        self.searchView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goFindOrderVC)];
        [self.searchView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHex:0x25282D];
        label.text = @"找回订单";
        label.font = [UIFont fontWithName:kSDPFRegularFont size:14];
        [self.searchView addSubview:label];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 17l;
        [self.searchView addSubview:contentView];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"xinletao_home_search_image"];
        [contentView addSubview:icon];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = [UIColor colorWithHex:0xC0C2C4];
        label1.text = @"输入商品订单信息";
        label1.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        [contentView addSubview:label1];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchView);
            make.left.mas_equalTo(10);
        }];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchView);
            make.left.equalTo(label.mas_right).offset(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(34);
        }];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchView);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.centerY.equalTo(self.searchView);
        }];
        
        [self.view addSubview:self.searchView];
        
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.mas_equalTo(60 + kBottomSafeHeight);
            
        }];
    }
}
- (void)goFindOrderVC{
    XLTOrderFindVC *vc = [[XLTOrderFindVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (XLTOrderContainerVC *)userOrderVC{
    if (!_userOrderVC) {
        _userOrderVC = [[XLTOrderContainerVC alloc] init];
        _userOrderVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop, kScreenWidth, kScreenHeight - kSafeAreaInsetsTop - 60 - kBottomSafeHeight);
    }
    return _userOrderVC;
}
- (XLTOrderContainerVC *)teamOrderVC{
    if (!_teamOrderVC) {
        _teamOrderVC = [[XLTOrderContainerVC alloc] init];
        _teamOrderVC.letaoIsGroupStyle = YES;
        _teamOrderVC.view.frame = CGRectMake(0, kSafeAreaInsetsTop, kScreenWidth, kScreenHeight - kSafeAreaInsetsTop - 60 - kBottomSafeHeight);
    }
    return _teamOrderVC;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)letaoSetupCustomNavView {
    self.letaoCustomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
    self.letaoCustomNavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.letaoCustomNavView];
    
    
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, kStatusBarHeight , 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:leftButton];
    
    
    UIView *segment = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 30)];
    segment.center = CGPointMake(kScreenWidth / 2.0, kSafeAreaInsetsTop - 15 - 7);
    segment.layer.cornerRadius = 5;
    segment.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
    segment.layer.borderWidth = 1;
    segment.layer.masksToBounds = YES;
    [segment addSubview:self.leftSegmentBtn];
    [segment addSubview:self.rightSegmentBtn];
    
    
    
    [self.letaoCustomNavView addSubview:segment];
    
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
- (UIButton *)leftSegmentBtn{
    if (!_leftSegmentBtn) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, 85, 30);
        btn1.titleLabel.font = [UIFont letaoRegularFontWithSize:14];
        [btn1 setTitle:@"我的订单" forState:UIControlStateNormal];
        btn1.backgroundColor = [UIColor colorWithHex:0xFF8202];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        _leftSegmentBtn = btn1;
    }
    return _leftSegmentBtn;
}
- (UIButton *)rightSegmentBtn{
    if (!_rightSegmentBtn) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(85, 0, 85, 30);
        btn1.titleLabel.font = [UIFont letaoRegularFontWithSize:14];
        [btn1 setTitle:@"粉丝订单" forState:UIControlStateNormal];
        btn1.backgroundColor = [UIColor whiteColor];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        _rightSegmentBtn = btn1;
    }
    return _rightSegmentBtn;
}
- (void)leftAction{
    if (!self.letaoIsGroupStyle) {
        return;
    }
    [self updateSegment:YES];
    self.letaoIsGroupStyle = NO;
    [self.teamOrderVC.view removeFromSuperview];
    [self.view addSubview:self.userOrderVC.view];
    self.currentVC = self.userOrderVC;
}
- (void)rightAction{
    if (self.letaoIsGroupStyle) {
        return;
    }
    [self updateSegment:NO];
    self.letaoIsGroupStyle = YES;
    [self.userOrderVC.view removeFromSuperview];
    [self.view addSubview:self.teamOrderVC.view];
    self.currentVC = self.teamOrderVC;
}
- (void)updateSegment:(BOOL )left{
    if (left) {
        self.leftSegmentBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
        [self.leftSegmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.rightSegmentBtn.backgroundColor = [UIColor whiteColor];
        [self.rightSegmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        
        self.rightSegmentBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
        [self.rightSegmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.leftSegmentBtn.backgroundColor = [UIColor whiteColor];
        [self.leftSegmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
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
- (void)didChangedYearMonth:(NSString *)yearMonth {
    self.letaoYearMonthText = yearMonth;
    self.userOrderVC.letaoYearMonthText = yearMonth;
    [self.userOrderVC.letaoJXPagerView reloadData];
    
    self.teamOrderVC.letaoYearMonthText = yearMonth;
    [self.teamOrderVC.letaoJXPagerView reloadData];
//    [self.letaoJXPagerView reloadData];
}
@end
