//
//  XLTMyTeamVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMyTeamVC.h"
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
#import "XLTMemberDetailVC.h"
#import "XLTMyTeamMembersCell.h"
#import "XLTMyMembersUpGradePopVC.h"
#import "XLTVipTaskModel.h"
#import "XLTVipLogic.h"
#import "XLTUpdateMyInviterVC.h"

@interface XLTMyTeamVC ()<XLTMemberSortViewDelegate,XLTTeamHeaderDelegate,XLTBindWXDelegate, XLTMyTeamMembersCellDelegate>
@property (nonatomic ,strong) XLTTeamHeaderView *headerView;
@property (nonatomic ,strong) XLTMemberSortView *sortView;
@property (nonatomic ,strong) LetaoEmptyCoverView *balanceEmptyView;
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
@property (nonatomic ,strong) UIButton *addWXBtn;
@end

@implementation XLTMyTeamVC

- (void)viewDidLoad {
    self.letaoSortValueType = @"-itime";
    self.headerHeight = 400;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的粉丝";
    self.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    [self reloadView];
    
    
}


- (void)reloadView{
    [self.view insertSubview:self.navView atIndex:0];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contentTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentTableView.separatorColor = [UIColor colorWithHex:0xEBEBED];
    
    self.contentTableView.estimatedRowHeight = 200;
    self.contentTableView.estimatedSectionHeaderHeight = 0;
    self.contentTableView.estimatedSectionFooterHeight = 0;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;

    [self.navView addSubview:self.nameLabel];
    [self.navView addSubview:self.backBtn];
    self.contentTableView.backgroundView = nil;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.listView];
    [self.listView addSubview:self.contributeBtn];
    
    UIView *lineVIew = [UIView new];
    lineVIew.backgroundColor = [UIColor colorWithHex:0xEBEBED];
    [self.listView addSubview:lineVIew];

    [lineVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.listView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(60+kBottomSafeHeight);
    }];
//    [self.incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenWidth / 2.0);
//        make.height.mas_equalTo(44);
//        make.top.right.equalTo(self.listView);
//    }];
    [self.contributeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.listView);
        make.height.mas_equalTo(60);
        make.top.left.equalTo(self.listView);
    }];
    
    [self.listView addSubview:self.lineView];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(0.5);
//        make.height.mas_equalTo(20);
//        make.centerX.equalTo(self.listView);
//        make.top.mas_equalTo(12);
//    }];
    
    [self updateContentTableTop];
    
}
- (void)updateContentTableTop {
    NSString *wechat_show_uid = [XLTUserManager shareManager].curUserInfo.wechat_show_uid;
    BOOL showInputWXinView =  ([XLTUserManager shareManager].curUserInfo.level.intValue >= 3 && !([wechat_show_uid isKindOfClass:[NSString class]] && wechat_show_uid.length > 0));
    NSString *tutor_wechat_show_uid = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;
    BOOL showContactView = ([tutor_wechat_show_uid isKindOfClass:[NSString class]] && tutor_wechat_show_uid.length > 0);
    
    if (showInputWXinView || showContactView) {
        self.addWXView.hidden = NO;
        [self.view addSubview:self.addWXView];
        [self.addWXView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(kSafeAreaInsetsTop);
            make.height.mas_equalTo(45);
        }];
        [self.addWXView addSubview:self.wxImageView];
        [self.addWXView addSubview:self.wxDescribeLabel];
        [self.addWXView addSubview:self.addWXBtn];
        self.wxDescribeLabel.adjustsFontSizeToFitWidth = YES;
        if (showInputWXinView) {
            self.wxImageView.image = [UIImage imageNamed:@"mine_team_wx"];
            self.wxDescribeLabel.text = @"填写微信号，让粉丝联系我";
            [self.addWXBtn setTitle:@"立即填写" forState:UIControlStateNormal];
            [self.wxImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.addWXView);
                make.left.mas_equalTo(15);
                make.width.mas_equalTo(21.5);
                make.height.mas_equalTo(17);
            }];

            [self.addWXBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.wxImageView);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(25);
                make.right.mas_equalTo(-15);
            }];
        } else {
            self.wxImageView.image = [UIImage imageNamed:@"mine_team_tutorwx"];
            self.wxDescribeLabel.text = @"联系导师，免费指导，帮助你躺赚收益";
            [self.addWXBtn setTitle:@"添加Ta微信" forState:UIControlStateNormal];
            [self.wxImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.addWXView);
                make.left.mas_equalTo(15);
                make.width.mas_equalTo(22);
                make.height.mas_equalTo(22);
            }];

            [self.addWXBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.wxImageView);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(25);
                make.right.mas_equalTo(-15);
            }];
        }
        

        
        [self.wxDescribeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wxImageView);
            make.left.equalTo(self.wxImageView.mas_right).offset(8);
            make.height.mas_equalTo(14);
            make.right.equalTo(self.addWXBtn.mas_left).offset(-10);
        }];
        
        [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.addWXView.mas_bottom);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view).offset(-60);
            }
        }];
    }else{
        self.addWXView.hidden = YES;
        [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view).offset(-60);
            }
            make.top.mas_equalTo(kTopHeight);
        }];
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
- (UILabel *)wxDescribeLabel{
    if (!_wxDescribeLabel) {
        _wxDescribeLabel = [[UILabel alloc] init];
        _wxDescribeLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        _wxDescribeLabel.textColor = [UIColor colorWithHex:0x25282D];
        _wxDescribeLabel.text = @"填写微信号,让粉丝联系我";
    }
    return _wxDescribeLabel;
}
- (UIButton *)addWXBtn{
    if (!_addWXBtn) {
        _addWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addWXBtn setTitle:@"立即填写" forState:UIControlStateNormal];
        [_addWXBtn setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
        _addWXBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _addWXBtn.layer.cornerRadius = 12.5;
        _addWXBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        _addWXBtn.layer.borderWidth = 1;
        [_addWXBtn addTarget:self action:@selector(pushToBindWX) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addWXBtn;
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
        _contributeBtn.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:15];
        _contributeBtn.backgroundColor = [UIColor whiteColor];
        [_contributeBtn setTitle:@"粉丝贡献榜单" forState:UIControlStateNormal];
        [_contributeBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
        [_contributeBtn addTarget:self action:@selector(pushToContributeListVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contributeBtn;
}
- (void)pushToBindWX{
    NSString *wechat_show_uid = [XLTUserManager shareManager].curUserInfo.wechat_show_uid;
    BOOL showInputWXinView =  ([XLTUserManager shareManager].curUserInfo.level.intValue >= 3 && !([wechat_show_uid isKindOfClass:[NSString class]] && wechat_show_uid.length > 0));
    NSString *tutor_wechat_show_uid = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;
    BOOL showContactView = ([tutor_wechat_show_uid isKindOfClass:[NSString class]] && tutor_wechat_show_uid.length > 0);
    if (showInputWXinView) {
        XLTBindWXVC *vc = [[XLTBindWXVC alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (showContactView) {
            [UIPasteboard generalPasteboard].string = tutor_wechat_show_uid;
            [self showTipMessage:@"微信号复制成功"];
            [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"weixin://"] afterDelay:1];
            
        }
        
    
    }
    
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
        _nameLabel.text = @"我的粉丝";
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
- (XLTTeamHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[XLTTeamHeaderView alloc] initWithNib];
        _headerView.delegate = self;
        [_headerView setFrame:CGRectMake(0, 0, kScreenWidth, 290)];
//        [_headerView setTime:self.currentMonth];
        XLT_WeakSelf;
        _headerView.sortBlock = ^(NSInteger index, NSInteger status) {
            XLT_StrongSelf;
            [self reloadDataWithSort:index stauts:status searchStr:self.searchStr];
            
        };
        _headerView.searchBlock = ^(NSString * _Nonnull str) {
            XLT_StrongSelf;
            [self reloadDataWithSort:-1 stauts:self.sortStatus searchStr:str];
        };
    }
    return _headerView;
}
- (void)reloadDataWithSort:(NSInteger )letaoSortValueType stauts:(NSInteger )status searchStr:(NSString *)str{
    switch (letaoSortValueType) {
        case 0:
        {
//            if (status == 1) {
//                self.letaoSortValueType = @"-itime";
//            }else{
//                self.letaoSortValueType = @"itime";
//            }
            if (status == 1) {
                self.letaoSortValueType = @"-estimate_total";
            }else{
                self.letaoSortValueType = @"estimate_total";
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
//            if (status == 1) {
//                self.letaoSortValueType = @"-estimate_total";
//            }else{
//                self.letaoSortValueType = @"estimate_total";
//            }
            [self showSortView];
        }
            break;
//        case 2:
//            [self showSortView];
//            break;
        default:
            break;
    }
    
    self.sortStatus = status;
    self.searchStr = str;
    if (letaoSortValueType != 2) {
        [self letaoTriggerRefresh];
    }
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
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTMyTeamMembersCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTMyTeamMembersCell"];
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
    [XLTUserInfoLogic xingletaonetwork_requestTeamWithSuccess:^(id object) {
        XLT_StrongSelf;
        [self.headerView setModel:object];
    } failure:^(NSString *errorMsg) {
        
    }];
    [self letaoShowLoading];
    [XLTUserInfoLogic xingletaonetwork_requestTeamListWithUid:@"" Page:[NSString stringWithFormat:@"%ld",(long)index] row:[NSString stringWithFormat:@"%ld",(long)pageSize] sort:self.letaoSortValueType fans:self.fans search:self.searchStr success:^(id object) {
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
- (LetaoEmptyCoverView *)balanceEmptyView{
    if (_balanceEmptyView == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20 + kScreenWidth / 2.0 + 50 + 15 + 32 + 20)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xingletao_order_empty"]];
        UILabel *describeLabel = [[UILabel alloc] init];
        describeLabel.textAlignment = NSTextAlignmentCenter;
        describeLabel.text = @"您还没有记录哦~";
        describeLabel.textColor = [UIColor colorWithHex:0xA6A6A6];
        describeLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"去邀粉" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHex:0xFF8202];
        btn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        btn.layer.cornerRadius = 16;
        [btn addTarget:self
                action:@selector(invateAction) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:imageView];
        [view addSubview:describeLabel];
        [view addSubview:btn];
        
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
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(90);
            make.top.equalTo(describeLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(32);
            make.centerX.equalTo(view);
        }];
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
- (void)pushDetailVC:(XLTUserTeamItemListModel *)listModel{
    XLTMemberDetailVC *vc = [[XLTMemberDetailVC alloc] init];
    vc.listModel = listModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark datepicker delegate
- (void)pickerDateView:(XLTBasePickView *)pickerDateView selectIndex:(NSInteger )index{
    switch (index) {
        case 0:
            self.fans = @"";
            self.headerView.sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            break;
        case 1:
            self.headerView.sortBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            self.fans = @"0";
            break;
        case 2:
            self.headerView.sortBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            self.fans = @"1";
            break;
        default:
            break;
    }
    [self letaoTriggerRefresh];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTUserTeamItemListModel *model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
//    [self showDetailView:model];
    [self pushDetailVC:model];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTMyTeamMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTMyTeamMembersCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.letaoPageDataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letaoPageDataArray.count;
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 40;
    if (self.headerHeight >= 400) {
        height = self.headerHeight;
    }
    return height;
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
    [self updateContentTableTop];
}


- (void)myTeamMembersCell:(XLTMyTeamMembersCell *)cell shwoProgressWithInfo:(XLTUserTeamItemListModel *)model {
    __weak typeof(self)weakSelf = self;
    NSDictionary *user_task_Info = model.user_task_list.firstObject;
    if ([user_task_Info isKindOfClass:[NSDictionary class]]) {
        NSString *uid = user_task_Info[@"user_id"];
        if (uid) {
            [self letaoShowLoading];
            [XLTVipLogic fetchVipTaskListWithId:uid success:^(XLTVipTaskModel * model) {
                NSArray *event_rules = model.event_rules;
                NSString *explain = model.explain;
                NSString *process_explain =  model.process_explain;
                [weakSelf showMembersUpGradePopVCExplainText:explain upGradeTitleText:process_explain upGradeProgressArray:event_rules];
                [weakSelf letaoRemoveLoading];
            } failure:^(NSString * _Nonnull errorMsg) {
                [weakSelf letaoRemoveLoading];
                [weakSelf showTipMessage:errorMsg];
            }];
        }

        
    }
    

}

- (void)showMembersUpGradePopVCExplainText:(NSString * _Nullable)upGradeExplainText
                upGradeTitleText:(NSString * _Nullable)upGradeTitleText
                      upGradeProgressArray:(NSArray * _Nullable)upGradeProgressArray {
    XLTMyMembersUpGradePopVC *myMembersUpGradePopVC = [[XLTMyMembersUpGradePopVC alloc] init];
    [myMembersUpGradePopVC letaoPresentWithSourceVC:self upGradeExplainText:upGradeExplainText upGradeTitleText:upGradeTitleText upGradeProgressInfo:upGradeProgressArray];
}

@end
