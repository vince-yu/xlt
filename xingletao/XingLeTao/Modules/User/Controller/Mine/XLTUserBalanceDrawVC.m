//
//  XLTUserBalanceDrawVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserBalanceDrawVC.h"
#import "XLTUserBalaneCellTableViewCell.h"
#import "XLTUserBalanceHeadView.h"
#import "XLTUserInfoLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTCustomPickDateView.h"
#import "MJRefresh.h"
#import "XLTHomeCustomHeadView.h"
#import "UIView+Extension.h"
#import "XLTBalanceDetailModel.h"
#import "XLTAlertViewController.h"
#import "XLTNomalAlterView.h"

@interface XLTUserBalanceDrawVC ()<PickerDateViewDelegate>
@property (nonatomic ,strong) XLTUserBalanceHeadView* headerView;
@property (nonatomic ,strong) NSString *currentMonth;
//@property (nonatomic ,strong) NSArray *letaoPageDataArray;
@property (nonatomic ,strong) LetaoEmptyCoverView *balanceEmptyView;
@property (nonatomic ,strong) XLTCustomPickDateView *timeView;
@property (nonatomic ,strong) UIView *navView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,assign) NSInteger type;
@end

@implementation XLTUserBalanceDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadView];
    
    [self fetchBalanceTips];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)fetchBalanceTips {
    XLT_WeakSelf;
    [XLTUserInfoLogic requestAccountTipsInfoSuccess:^(NSDictionary * _Nonnull info) {
        XLT_StrongSelf;
        NSDictionary *tips = info[@"tips"];
        if ([tips isKindOfClass:[NSDictionary class]]) {
            NSString *title = tips[@"title"];
            NSString *msg = tips[@"msg"];
            [self showDrawFailedAlert:title message:msg];
        }

    } failure:^(NSString *errorMsg) {
        
    }];
}

- (void)showDrawFailedAlert:(NSString * _Nullable)title message:(NSString *) message {
    if ([message isKindOfClass:[NSString class]] && message.length > 0) {
        if (!([title isKindOfClass:[NSString class]] && title.length > 0)) {
            title = @"提现失败";
        }
        XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
        alertViewController.messageFont = [UIFont letaoRegularFontWithSize:12.0];
        [alertViewController letaoPresentWithSourceVC:self title:title message:message messageTextAlignment:NSTextAlignmentCenter sureButtonText:@"知道了" cancelButtonText:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void)reloadView{
    [self.view insertSubview:self.navView atIndex:0];
    [self.contentTableView setFrame:CGRectMake(0, kTopHeight, self.view.bounds.size.width, self.view.height - kTopHeight)];
    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeLeft;
        [_backBtn setFrame:CGRectMake(15, kStatusBarHeight + 12, 50, 18)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    return _backBtn;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _nameLabel.text = @"我的余额";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:19];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.center = CGPointMake(self.navView.center.x, self.backBtn.center.y);
    }
    return _nameLabel;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [XLTHomeCustomHeadView letaoDefaultHeight])];
        UIImageView *_letaobgImageView = [[UIImageView alloc] initWithFrame:_navView.bounds];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFF6E02],[UIColor colorWithHex:0xFFAE01]] gradientType:0 imgSize:_letaobgImageView.bounds.size];
        _letaobgImageView.image = bgImage;
        [_navView addSubview:_letaobgImageView];
        
        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
        CGFloat bottomCircleHeight = ceilf(_navView.bounds.size.width/375*35);
        UIImageView * _bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
        _bottomCircleImageView.frame = CGRectMake(0, _navView.bounds.size.height - bottomCircleHeight, _navView.bounds.size.width, bottomCircleHeight);
        [self.navView addSubview:_bottomCircleImageView];
    }
    return _navView;
}
- (XLTUserBalanceHeadView *)headerView{
    if (!_headerView) {
        _headerView = [[XLTUserBalanceHeadView alloc] initWithNib];
        [_headerView setTime:self.currentMonth];
        XLT_WeakSelf;
        _headerView.selectTimeBlock = ^{
            XLT_StrongSelf;
            [self popSelectView];
        };
        _headerView.selectTypeBlock = ^(NSInteger type) {
            
        };
    }
    return _headerView;
}
- (void)reloadDataWithType:(NSInteger )type{
    self.type = type;
    [self letaoTriggerRefresh];
}
- (XLTCustomPickDateView *)timeView{
    if (!_timeView) {
//        XLT_WeakSelf;
        _timeView = [[XLTCustomPickDateView alloc] init];
        [_timeView setIsAddYetSelect:NO];//是否显示至今选项
        [_timeView setIsShowDay:NO];//是否显示日信息
        _timeView.delegate = self;
        [_timeView setDefaultTSelectYear:[NSDate date].year defaultSelectMonth:[NSDate date].month defaultSelectDay:10];//设定默认显示的日期
    }
    return _timeView;
}
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popSelectView{
    [self.timeView show];
}
- (NSString *)currentMonth{
    if (!_currentMonth) {
        
        _currentMonth = [self getDateMonthWith:[NSDate date]];
    }
    return _currentMonth;
}
- (NSString *)getDateMonthWith:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}
// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTUserBalaneCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTUserBalaneCellTableViewCell"];
}

- (void)letaoShowLoading{
    
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestBalanceDetailSuccess:^(id balance) {
        XLT_StrongSelf;
        self.headerView.balanceInfo = balance;
    } failure:^(NSString *errorMsg) {
        
    }];
    NSString *str = @"";
    switch (self.type) {
        case 0:
            str = @"";
            break;
        case 1:
            str = @"100";
            break;
        case 2:
            str = @"20";
            break;
        default:
            break;
    }
    [XLTUserInfoLogic xingletaonetwork_requestBalanceDetailWith:self.currentMonth type:str page:[NSString stringWithFormat:@"%ld",index] limit:[NSString stringWithFormat:@"%ld",pageSize] success:^(id balance) {
        
        success(balance);
    } failure:^(NSString *errorMsg) {
        
    }];
}
- (void)letaoShowEmptyView{
    if (self.balanceEmptyView == nil) {
        LetaoEmptyCoverView *emptyView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"您还没有账户记录哦~"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        emptyView.contentViewOffset =  100;
        emptyView.subViewMargin = 14.f;
        emptyView.titleLabFont = [UIFont systemFontOfSize:15.f];
        emptyView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        emptyView.userInteractionEnabled = NO;
        self.balanceEmptyView = emptyView;
    }
    [self.contentTableView addSubview:self.balanceEmptyView];
}

- (void)letaoRemoveEmptyView {
    [self.balanceEmptyView removeFromSuperview];
}

#pragma makr datepicker delegate
- (void)pickerDateView:(XLTCustomPickDateView *)pickerDateView selectYear:(NSInteger)year selectMonth:(NSInteger)month selectDay:(NSInteger)day{
    self.currentMonth = [NSString stringWithFormat:@"%ld-%ld",(long)year,(long)month];
    [self.headerView setTime:self.currentMonth];
    [self.contentTableView.mj_header beginRefreshing];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.letaoPageDataArray.count) {
        XLTBalanceDetailModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
        if (model.reason.length) {
            [self showDrawFailedAlert:nil message:model.reason];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTUserBalaneCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTUserBalaneCellTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 387;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
@end
