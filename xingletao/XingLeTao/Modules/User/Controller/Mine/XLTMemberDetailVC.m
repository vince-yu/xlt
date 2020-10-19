//
//  XLTMemberDetailVC.m
//  XingLeTao
//
//  Created by SNQU on 2020/3/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMemberDetailVC.h"
#import "XLTTeamHeaderView.h"
#import "XLTMemberSortView.h"
#import "LetaoEmptyCoverView.h"
#import "XLTMemberDetailView.h"
#import "XLTUserInfoLogic.h"
#import "XLTUserManager.h"
#import "XLTUserInvateVC.h"
#import "XLTIncomeListVC.h"
#import "XLTContributeListVC.h"
#import "XLTBindWXVC.h"
#import "XLTMemberDetailHeader.h"
#import "XLTUserTeamIncomeModel.h"
#import "XLTMyInviteMembersCell.h"
#import "XLTUpdateMyInviterVC.h"

@interface XLTMemberDetailVC ()<XLTBindWXDelegate, XLTMemberSortViewDelegate>
@property (nonatomic ,strong) XLTMemberDetailHeader *headerView;
@property (nonatomic ,strong) XLTMemberSortView *sortView;
@property (nonatomic ,strong) UIView *balanceEmptyView;
@property (nonatomic ,strong) UIView *navView;
@property (nonatomic ,strong) UILabel *invateView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,copy) NSString *letaoSortValueType;
@property (nonatomic ,assign) NSInteger sortStatus;
@property (nonatomic ,copy) NSString *searchStr;
@property (nonatomic ,copy) NSString *fans;

@property (nonatomic ,strong) UIView *listView;
@property (nonatomic ,strong) UIButton *contributeBtn;
@property (nonatomic ,strong) UIButton *incomeBtn;
@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic ,assign) CGFloat headerHeight;

@property (nonatomic ,strong) UIView *addWXView;
@property (nonatomic ,strong) UIImageView *wxImageView;
@property (nonatomic ,strong) UILabel *wxDescribeLabel;
@property (nonatomic ,strong) UIButton *closeBtn;

@property (nonatomic ,assign) BOOL hasThreeThis;

@end

@implementation XLTMemberDetailVC

- (void)viewDidLoad {
    self.letaoSortValueType = @"-itime";
    self.headerHeight = 410;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请明细";
    self.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    self.hasThreeThis = [self hasThreeThisVC];
    [self reloadView];
    
    
}
- (void)reloadView{
    [self.view insertSubview:self.navView atIndex:0];
    [self.contentTableView setFrame:CGRectMake(0, kTopHeight, self.view.bounds.size.width, self.view.height - kTopHeight)];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    [self.navView addSubview:self.closeBtn];
    
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    
//    [self.view addSubview:self.listView];
//    [self.listView addSubview:self.incomeBtn];
//    [self.listView addSubview:self.contributeBtn];
//    UIView *lineVIew = [UIView new];
//    lineVIew.backgroundColor = [UIColor colorWithHex:0xEBEBED];
//    [self.listView addSubview:lineVIew];
//
//    [lineVIew mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.listView);
//        make.height.mas_equalTo(0.5);
//        make.top.equalTo(self.contributeBtn.mas_bottom);
//    }];
//
//    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.view);
//        make.height.mas_equalTo(44 + kBottomSafeHeight);
//    }];
//    [self.incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenWidth / 2.0);
//        make.height.mas_equalTo(44);
//        make.top.right.equalTo(self.listView);
//    }];
//    [self.contributeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenWidth / 2.0);
//        make.height.mas_equalTo(44);
//        make.top.left.equalTo(self.listView);
//    }];
//
//    [self.listView addSubview:self.lineView];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(0.5);
//        make.height.mas_equalTo(20);
//        make.centerX.equalTo(self.listView);
//        make.top.mas_equalTo(12);
//    }];
    [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
    }];
//    [self updateContentTableTop];
    
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
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"xlt_mine_close"] forState:UIControlStateNormal];
        [_closeBtn setFrame:CGRectMake(kScreenWidth - 15 - 44, kStatusBarHeight, 44, 44)];
//        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    return _closeBtn;
}
- (void)closeAction{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (UIView *)addWXView{
    if (!_addWXView) {
        _addWXView = [[UIView alloc] init];
        _addWXView.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    }
    return _addWXView;
}
- (UIImageView *)wxImageView{
    if (!_wxImageView) {
        _wxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_team_wx"]];
    }
    return _wxImageView;
}
- (UIView *)listView{
    if (!_listView) {
        _listView = [[UIView alloc] init];
        _listView.backgroundColor = [UIColor whiteColor];
    }
    return _listView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xECE8E9];
    }
    return _lineView;
}
- (UIButton *)incomeBtn{
    if (!_incomeBtn) {
        _incomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _incomeBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
//        _incomeBtn.backgroundColor = [UIColor letaomainColorSkinColor];
        [_incomeBtn setTitle:@"乐桃收入榜" forState:UIControlStateNormal];
        [_incomeBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
        [_incomeBtn addTarget:self action:@selector(pushToIncomeListVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomeBtn;
}
- (UIButton *)contributeBtn{
    if (!_contributeBtn) {
        _contributeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contributeBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        _contributeBtn.backgroundColor = [UIColor whiteColor];
        [_contributeBtn setTitle:@"粉丝贡献榜单" forState:UIControlStateNormal];
        [_contributeBtn setTitleColor:[UIColor colorWithHex:0x25282D] forState:UIControlStateNormal];
        [_contributeBtn addTarget:self action:@selector(pushToContributeListVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contributeBtn;
}
- (void)pushToBindWX{
    XLTBindWXVC *vc = [[XLTBindWXVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToContributeListVC{
    XLTContributeListVC *vc = [[XLTContributeListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToIncomeListVC{
    XLTIncomeListVC *vc = [[XLTIncomeListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(letaoPopAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeLeft;
        [_backBtn setFrame:CGRectMake(15, kStatusBarHeight, 50, 44)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
    return _backBtn;
}

- (UILabel *)invateView{
    if (!_invateView) {
        _invateView = [[UILabel alloc] init];
        _invateView.backgroundColor = [UIColor colorWithHex:0xF8E7DB];
        _invateView.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _invateView.textColor = [UIColor colorWithHex:0xE27756];
        _invateView.textAlignment = NSTextAlignmentCenter;
    }
    return _invateView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _nameLabel.text = @"邀请明细";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:19];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.center = CGPointMake(self.navView.center.x, self.backBtn.center.y);
    }
    return _nameLabel;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
//        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
//        CGFloat bottomCircleHeight = ceilf(_navView.bounds.size.width/375*35);
//        UIImageView * _bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
//        _bottomCircleImageView.frame = CGRectMake(0, _navView.bounds.size.height - bottomCircleHeight, _navView.bounds.size.width, bottomCircleHeight);
//        [self.navView addSubview:_bottomCircleImageView];
    }
    return _navView;
}
- (XLTMemberDetailHeader *)headerView{
    if (!_headerView) {
        _headerView = [[XLTMemberDetailHeader alloc] initWithNib];
//        _headerView.delegate = self;
        [_headerView setFrame:CGRectMake(0, 0, kScreenWidth, 565+21)];
//        [_headerView setTime:self.currentMonth];
        XLT_WeakSelf;
        _headerView.sortBlock = ^(NSInteger index, NSInteger status) {
            XLT_StrongSelf;
            [self reloadDataWithSort:index stauts:status searchStr:self.searchStr];
            
        };
    }
    return _headerView;
}
- (void)reloadDataWithSort:(NSInteger )letaoSortValueType stauts:(NSInteger )status searchStr:(NSString *)str{
    switch (letaoSortValueType) {
        case 0:
        {
            if (status == 1) {
                self.letaoSortValueType = @"-itime";
            }else{
                self.letaoSortValueType = @"itime";
            }
            
        }
            break;
        case 1:
        {
            if (status == 1) {
                self.letaoSortValueType = @"-fans_all";
            }else{
                self.letaoSortValueType = @"fans_all";
            }
            
        }
            break;
        case 2:
        {
            if (status == 1) {
                self.letaoSortValueType = @"-estimate_total";
            }else{
                self.letaoSortValueType = @"estimate_total";
            }
            
        }
            break;
        default:
            break;
    }
    
    self.sortStatus = status;
    self.searchStr = str;
//    if (letaoSortValueType != 2) {
        [self letaoTriggerRefresh];
//    }
}
- (void)showSortView{
    [self.sortView show];
}
- (XLTMemberSortView *)sortView{
    if (!_sortView) {
//        XLT_WeakSelf;
        _sortView = [[XLTMemberSortView alloc] initWithSortArray:@[@"全部",@"专属粉丝",@"其他粉丝"]];
        [_sortView.confirmButton setTitleColor:[UIColor colorWithHex:0xD22C2F] forState:UIControlStateNormal];
        _sortView.titleLabel.text = @"筛选";
        _sortView.delegate = self;
        
    }
    return _sortView;
}

- (void)pickerDateView:(XLTBasePickView *)pickerDateView selectIndex:(NSInteger )index {
    
}
- (void)letaoPopAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popSelectView{
    [self.sortView show];
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
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTMyInviteMembersCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyInviteMembersCell"];
}

- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)customLetaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed{
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestUserIncomeWithId:self.listModel.itemId Success:^(id object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        XLTUserIncomeModel *income = (XLTUserIncomeModel *)object;
        income.canCopy = self.listModel.can_copy;
        income.phone = self.listModel.phone;
        income.tip = self.listModel.tip;
        income.recent = self.listModel.recent;
        income.level = self.listModel.level;
        income.itemId = self.listModel.itemId;
        self.headerView.model = income;
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
    }];
    [self letaoShowLoading];
    [XLTUserInfoLogic xingletaonetwork_requestTeamListWithUid:self.listModel.itemId Page:[NSString stringWithFormat:@"%ld",(long)index] row:[NSString stringWithFormat:@"%ld",(long)pageSize] sort:self.letaoSortValueType fans:self.fans search:self.searchStr success:^(id object) {
        XLT_StrongSelf;
        success(object);
        [self letaoRemoveLoading];
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self showToastMessage:errorMsg];
        [self letaoRemoveLoading];
    }];
}
- (void)letaoShowEmptyView{
    if (self.balanceEmptyView == nil) {
        XLT_WeakSelf;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xingletao_order_empty"
                                                                   titleStr:@"您还没有记录哦~"
                                                                  detailStr:@""
                                                                btnTitleStr:@"去邀粉"
                                                              btnClickBlock:^(){
            XLT_StrongSelf;
            [self invateAction];
        }];
        letaoEmptyCoverView.actionBtnFont = [UIFont fontWithName:kSDPFRegularFont size:15];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.actionBtnHeight = 35;
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor whiteColor];
        letaoEmptyCoverView.actionBtnCornerRadius = 17.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = [UIColor colorWithHex:0xFF8202];
        letaoEmptyCoverView.contentViewOffset =  180;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        letaoEmptyCoverView.userInteractionEnabled = YES;
        self.balanceEmptyView = letaoEmptyCoverView;
    }
//    self.contentTableView.contentSize = CGSizeMake(kScreenWidth, self.headerHeight + 200);
//    [self.contentTableView insertSubview:self.balanceEmptyView atIndex:0];

}
- (void)invateAction{
    if (![XLTUserManager shareManager].isInvited) {
        if ([XLTAppPlatformManager shareManager].checkEnable) {
            // 邀请页面
            [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
            XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
            [self.navigationController pushViewController:updateMyInviterVC animated:YES];
            return;
        }
    }
    XLTUserInvateVC *vc = [[XLTUserInvateVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushDetailVC:(XLTUserTeamItemListModel *)listModel{
    XLTMemberDetailVC *vc = [[XLTMemberDetailVC alloc] init];
    vc.listModel = listModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)balanceEmptyView{
    if (_balanceEmptyView == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20 + kScreenWidth / 2.0 + 50 + 15 + 32 + 20)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xingletao_order_empty"]];
        UILabel *describeLabel = [[UILabel alloc] init];
        describeLabel.textAlignment = NSTextAlignmentCenter;
        describeLabel.text = @"您还没有记录哦~";
        describeLabel.textColor = [UIColor colorWithHex:0xA6A6A6];
        describeLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"去邀粉" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor colorWithHex:0xFF8202];
//        btn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
//        btn.layer.cornerRadius = 16;
//        [btn addTarget:self
//                action:@selector(invateAction) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:imageView];
        [view addSubview:describeLabel];
//        [view addSubview:btn];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.equalTo(view);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenWidth / 2.5);
        }];
        [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(-10);
            make.centerX.equalTo(view);
            make.height.mas_equalTo(15);
        }];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(90);
//            make.top.equalTo(describeLabel.mas_bottom).offset(20);
//            make.height.mas_equalTo(32);
//            make.centerX.equalTo(view);
//        }];
        _balanceEmptyView = view;
//        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xingletao_mine_team_empty"
//                                                                   titleStr:@"您还没有记录哦~"
//                                                                  detailStr:@""
//                                                                btnTitleStr:@"去邀粉"
//                                                              btnClickBlock:^(){
//                                                                    XLT_StrongSelf;
//                                                                    XLTUserInvateVC *vc = [[XLTUserInvateVC alloc] init];
//                                                                    [self.navigationController pushViewController:vc animated:YES];
//                                                              }];
//        letaoEmptyCoverView.actionBtnFont = [UIFont fontWithName:kSDPFRegularFont size:15];
//        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
//        letaoEmptyCoverView.actionBtnHeight = 35;
//        letaoEmptyCoverView.actionBtnTitleColor = [UIColor whiteColor];
//        letaoEmptyCoverView.actionBtnCornerRadius = 17.5;
//        letaoEmptyCoverView.actionBtnBackGroundColor = [UIColor colorWithHex:0xFF8202];
//        letaoEmptyCoverView.contentViewOffset =  180;
//        letaoEmptyCoverView.subViewMargin = 14.f;
//        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
//        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
//        letaoEmptyCoverView.userInteractionEnabled = YES;
//        _balanceEmptyView = letaoEmptyCoverView;
    }
    return _balanceEmptyView;
}
- (void)letaoRemoveEmptyView {
    [self.balanceEmptyView removeFromSuperview];
}
- (void)showDetailView:(XLTUserTeamItemListModel *)userInfo{
    [self customLetaoShowLoading];
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestUserIncomeWithId:userInfo.itemId Success:^(id object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        XLTUserIncomeModel *income = (XLTUserIncomeModel *)object;
        XLTMemberDetailView *view = [[XLTMemberDetailView alloc] initWithNib];
        income.canCopy = userInfo.can_copy;
        income.phone = userInfo.phone;
        income.tip = userInfo.tip;
        view.model = income;
        [view show];
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
    }];
    
}
- (BOOL )hasThreeThisVC{
    int i = 0;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XLTMemberDetailVC class]]) {
            i ++ ;
        }
    }
    if (i >= 3) {
        return YES;
    }
    return NO;
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if ([XLTUserManager shareManager].curUserInfo.level.intValue == 1 || [XLTUserManager shareManager].curUserInfo.level.intValue == 2) {
        [self showTipMessage:@"升级后可查看详细数据"];
    }else{
        if ([XLTUserManager shareManager].curUserInfo.level.intValue  == 3 && self.hasThreeThis ) {
            [self showTipMessage:@"升级后可查看详细数据"];
        }else{
            XLTUserTeamItemListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
            [self pushDetailVC:model];
        }
        
    }*/
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTMyInviteMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyInviteMembersCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    cell.arrowImageView.hidden = ([XLTUserManager shareManager].curUserInfo.level.intValue == 1 || [XLTUserManager shareManager].curUserInfo.level.intValue == 2) || ([XLTUserManager shareManager].curUserInfo.level.intValue  == 3 && self.hasThreeThis );
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letaoPageDataArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 565+21;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!self.letaoPageDataArray.count) {
        return self.balanceEmptyView.height + 20;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.letaoPageDataArray.count) {
        return [UIView new];
    }else{
        return self.balanceEmptyView;
    }
    
}
#pragma mark XLTTeamHeaderDelegate
-(void)reloadHeader:(CGFloat)height{
    self.headerHeight = height;
    [self.contentTableView reloadData];
}
#pragma mark XLTBindWXDelegate

- (void)reloadSettingVC{
    
}
@end

