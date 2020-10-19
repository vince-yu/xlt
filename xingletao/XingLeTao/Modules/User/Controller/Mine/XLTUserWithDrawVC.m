//
//  XLTUserWithDrawVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserWithDrawVC.h"
#import "XLTUserWithDrawView.h"
#import "XLTUserInfoLogic.h"
#import "XLTUserBindAliPayTableViewCell.h"
#import "XLTUserWithDrawTableViewCell.h"
#import "XLTUserAliPayListTableViewCell.h"
#import "XLTUserManager.h"
#import "XLTUserBindAliPayVC.h"
#import "XLTUserTipMessageView.h"
#import "XLTBalanceInfoModel.h"
#import "NSArray+Bounds.h"
#import "XLTNomalAlterView.h"
#import "XLTWKWebViewController.h"
#import "NSString+XLTMD5.h"

@interface XLTUserWithDrawVC ()
@property (nonatomic ,strong) XLTUserWithDrawView *submitFooterView;
@property (nonatomic ,strong) NSString *maxPrice;
@property (nonatomic ,strong) NSString *minPrice;
@property (nonatomic ,copy) NSString *withDrawPrice;
@property (nonatomic ,copy) NSString *checkAgreementUrl;
@end

@implementation XLTUserWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view).offset(-40);
        }
    }];
    self.view.backgroundColor = self.contentTableView.backgroundColor;
    [self showCheckAgreementFooterIfNeed];
}

- (void)showCheckAgreementFooterIfNeed {
    [XLTUserInfoLogic requestPigContractWithAmount:@"0" success:^(NSDictionary * _Nonnull info) {
        NSString *checkAgreementUrl = info[@"url"];
        if ([checkAgreementUrl isKindOfClass:[NSString class]] && checkAgreementUrl.length > 0) {
            self.checkAgreementUrl = checkAgreementUrl;
            [self showCheckAgreementFooter];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
    }];
}

- (void)showCheckAgreementFooter {
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerBtn addTarget:self action:@selector(openPayAgreementAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerBtn];
    [footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    footerBtn.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont letaoRegularFontWithSize:12.0];
    label.textColor = [UIColor letaomainColorSkinColor];
    label.text = @"提现服务协议签订>>";
    label.textAlignment = NSTextAlignmentCenter;
    [footerBtn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerBtn);
    }];
}

- (void)openPayAgreementAction {
    [self openPayAgreementWithUrl:self.checkAgreementUrl];
}

- (void)initSubView{
    self.title = @"立即提现";
    NSString *str = [NSString stringWithFormat:@"%@",[XLTUserManager shareManager].curUserInfo.config.xlt_min_withdraw_amount];
    self.minPrice = [str priceStr];
}
- (NSString *)getDateMonthWith:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    [self letaoTriggerRefresh];
    
}
- (void)letaoSetupRefreshAutoFooter {

}
- (void)letaoSetupRefreshHeader {

}
//    [self letaoTriggerRefresh];

- (XLTUserWithDrawView *)submitFooterView{
    if (!_submitFooterView) {
        _submitFooterView = [[XLTUserWithDrawView alloc] initWithNib];
        XLT_WeakSelf;
        _submitFooterView.submitBlock = ^{
            XLT_StrongSelf;
            [self withDrawAction];
        };
    }
    return _submitFooterView;
}




- (void)withDrawAction {
    if(![[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue]) {
        [self showToastMessage:@"先完善真实姓名和支付宝账号"];
    } else {
        [self letaoShowLoading];
        __weak typeof(self)weakSelf = self;
        NSString *amount = [self.withDrawPrice yuanToTransfer];
        [XLTUserInfoLogic requestPigContractWithAmount:amount success:^(NSDictionary * _Nonnull info) {
            NSNumber *requireCheck = info[@"requireCheck"];
            BOOL needSign =  (([requireCheck isKindOfClass:[NSNumber class]] || [requireCheck isKindOfClass:[NSString class]]) && [requireCheck integerValue] == 1);
            if (needSign) {
                NSString *tips = [NSString stringWithFormat:@"%@",info[@"tips"]];
                NSString *url = [NSString stringWithFormat:@"%@",info[@"url"]];
                [weakSelf showPayAgreementAlert:tips agreementUrl:url];
            } else {
                [weakSelf stratWithDraw];
            }
            [weakSelf letaoRemoveLoading];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showToastMessage:errorMsg];
        }];
    }
}

- (void)stratWithDraw {
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTUserInfoLogic xingletaonetwork_requestWithDrawWith:[self.withDrawPrice yuanToTransfer] totalAmount:self.maxPrice  success:^(NSString *msg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showAlterViewWithMessage:msg];
        [self letaoTriggerRefresh];
        self.withDrawPrice = @"";
        [self.submitFooterView resetView];
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showToastMessage:errorMsg];
    }];
}

- (void)showAlterViewWithMessage:(NSString *)message {
    XLTUserTipMessageView *alter = [[XLTUserTipMessageView alloc] initWithNib];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"到账金额：￥%@%@",self.withDrawPrice,[message isKindOfClass:[NSString class]] ? message : @""]];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 14], NSForegroundColorAttributeName: [UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, attStr.length)];
    if ([self.withDrawPrice isKindOfClass:[NSString class]]) {
        [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 14], NSForegroundColorAttributeName: [UIColor letaomainColorSkinColor]} range:NSMakeRange(5, self.withDrawPrice.length +1)];
    }
    alter.describeStr = (NSString *)attStr;
    [alter show];
}
// registerTableViewCells should overwrite by sub class
- (void)registerTableViewCells{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTUserAliPayListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTUserAliPayListTableViewCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTUserWithDrawTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTUserWithDrawTableViewCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTUserBindAliPayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTUserBindAliPayTableViewCell"];
}

- (void)letaoShowLoading{
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}
- (void)letaoShowEmptyView{
    
}
// should overwrite by sub class
- (void)letaoFetchPageDataForIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(XLTBaseListRequestSuccess)success
                         failed:(XLTBaseListRequestFailed)failed {
    
//    [XLTUserInfoLogic getMiniAmountWithDrawSuccess:^(id balance) {
//        self.minPrice = [[NSString stringWithFormat:@"%@",balance] priceStr];
//        [self.contentTableView reloadData];
//    } failure:^(NSString *errorMsg) {
//    }];
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTUserInfoLogic xingletaonetwork_requestBalanceDetailSuccess:^(id balance) {
        XLT_StrongSelf;
        XLTBalanceInfoModel *info = (XLTBalanceInfoModel *)balance;
        self.maxPrice = [NSString stringWithFormat:@"%@",info.amountUseable];
        XLT_WeakSelf;
        [XLTUserInfoLogic xingletaonetwork_requestAlipayInfoWithSuccess:^(id balance) {
            XLT_StrongSelf;
            [self letaoRemoveLoading];
            if (!balance) {
                success(@[]);
                return ;
            }
            success(@[balance]);
        } failure:^(NSString *errorMsg) {
            XLT_StrongSelf;
            [self letaoRemoveLoading];
            success(@[]);
        }];
        [self showCheckAgreementFooterIfNeed];
    } failure:^(NSString *errorMsg) {
//        [XLTUserInfoLogic xingletaonetwork_requestAlipayInfoWithSuccess:^(id balance) {
//            XLT_StrongSelf;
//            [self letaoRemoveLoading];
//            if (!balance) {
//                success(@[]);
//                return ;
//            }
//            success(@[balance]);
//        } failure:^(NSString *errorMsg) {
//            XLT_StrongSelf;
//            [self letaoRemoveLoading];
//            success(@[]);
//        }];
//        [self letaoShowEmptyView];
        failed(nil ,errorMsg);
    }];
    
    
}

- (void)showPayAgreementAlert:(NSString *)text agreementUrl:(NSString *)url {
    __weak typeof(self)weakSelf = self;
    [XLTNomalAlterView showNamalAlterWithTitle:@"提现服务协议签订" content:text leftBlock:^{
    } rightBlock:^{
        [weakSelf openPayAgreementWithUrl:url];
    }];
}

- (void)openPayAgreementWithUrl:(NSString *)url {
    XLTWKWebViewController *web  = [[XLTWKWebViewController alloc] init];
    web.jump_URL = url;
    [self.navigationController pushViewController:web animated:YES];
}


- (void)pushToBindAlipayVC{
    XLTUserBindAliPayVC *aboutvc = [[XLTUserBindAliPayVC alloc] init];
    aboutvc.infoDic = [self.letaoPageDataArray by_ObjectAtIndex:0];
    [self.navigationController pushViewController:aboutvc animated:YES];
}
- (void)handelCurrentMoney:(NSString *)text{

    NSString *warnStr = nil;
    if (text.length) {
        if (text.doubleValue < self.minPrice.doubleValue) {
            warnStr = [NSString stringWithFormat:@"提现金额不能少于%@元",self.minPrice];
        }else if (text.doubleValue > self.maxPrice.doubleValue){
            warnStr = @"余额不足";
        }else{
            self.withDrawPrice = text;
        }
    }
    
    [self.submitFooterView showWarningStr:warnStr contentStr:text];
    
}
- (void)pushToCreatAlipayVC{
    XLTUserBindAliPayVC *aboutvc = [[XLTUserBindAliPayVC alloc] init];
    
    [self.navigationController pushViewController:aboutvc animated:YES];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue] && indexPath.section == 0) {
        [self pushToCreatAlipayVC];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue]) {
            XLTUserAliPayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTUserAliPayListTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XLT_WeakSelf;
            
            cell.model = [self.letaoPageDataArray by_ObjectAtIndex:indexPath.row];
            
            cell.editBlock = ^{
                XLT_StrongSelf;
                [self pushToBindAlipayVC];
            };
            return cell;
        }else{
            XLTUserBindAliPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTUserBindAliPayTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        XLTUserWithDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTUserWithDrawTableViewCell"];
        cell.maxPrice = self.maxPrice;
        XLT_WeakSelf;
        cell.textFieldChange = ^(NSString * _Nonnull text) {
            XLT_StrongSelf;
            [self handelCurrentMoney:text];
        };
        if (!self.withDrawPrice.length) {
            [cell clearTextField];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.maxPrice == nil) {
        return 0;
    }
    if ([[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue]) {
        if ([self.letaoPageDataArray count]) {
            return 2;
        }else{
            return 0;
        }
    }else{
        return 2;
    }
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([[XLTUserManager shareManager].curUserInfo.bind_alipay boolValue]){
            return 80;
        }else{
            return 50;
        }
    }else{
        return 172;
    }
    return 80;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 25;
    }else {
        return 15;
    }
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.submitFooterView;
    }
    return [UIView new];
}

@end
