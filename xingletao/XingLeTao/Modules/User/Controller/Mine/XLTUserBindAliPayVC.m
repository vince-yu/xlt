//
//  XLTUserBindAliPayVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserBindAliPayVC.h"
#import "XLTUserAliPayTableViewCell.h"
#import "XLTUserManager.h"
#import "XLTUserInfoLogic.h"
#import "XLTFeedBackLogic.h"

@interface XLTUserBindAliPayVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *contentView;
@property (nonatomic ,strong) NSArray *dataDic;
@property (nonatomic ,strong) UIButton *submitBtn;
@property (nonatomic ,strong) UIView *warningView;
@property (nonatomic ,strong) UIImageView *warningImageView;
@property (nonatomic ,strong) UILabel *warningLabel;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UILabel *kfTtlelLabel;
@property (nonatomic ,strong) UILabel *kfContentLabel;
@property (nonatomic ,strong) UIButton *storeBtn;
@property (nonatomic ,strong) UIImageView *kfImageView;
@property (nonatomic ,strong) UIView *kfContentView;

@property (nonatomic ,assign) BOOL hasRealName;
@property (nonatomic ,assign) BOOL hasAlipayCode;
@property (nonatomic ,assign) BOOL hasCode;

@property (nonatomic ,copy) NSString *realName;
@property (nonatomic ,copy) NSString *alipayCode;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *kfStr;

@end

@implementation XLTUserBindAliPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
    [self requestKefuData];
}
- (void)initSubView{
    self.title = @"绑定支付宝";
    
//    [self.view addSubview:self.submitBtn];

    [self.view addSubview:self.contentView];
    
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(kScreenHeight - kTopHeight - 10);
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];

    
}
- (void)requestKefuData{
    XLT_WeakSelf;
    [XLTFeedBackLogic requestCustomerServiceSuccess:^(NSDictionary * _Nonnull info, NSURLSessionDataTask * _Nonnull task) {
        XLT_StrongSelf;
        self.kfStr = info[@"wx"];
        self.kfContentLabel.text = [NSString stringWithFormat:@"若有疑问，请联系客服微信：%@",info[@"wx"]];
        [self updateKFContentWidth];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        
    }];
}
#pragma mark Lazy
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        [_footerView addSubview:self.submitBtn];
        [_footerView addSubview:self.warningView];
        [self.warningView addSubview:self.warningImageView];
        [self.warningView addSubview:self.warningLabel];
        
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
            make.top.equalTo(self.warningView.mas_bottom).offset(30);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        [self.warningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(12);
            make.top.mas_equalTo(15);
        }];
        [self.warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(13, 13));
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
        [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.warningImageView.mas_right).offset(7);
    //        make.centerY.equalTo(self.warningImageView);
            make.top.equalTo(self.warningView);
            make.right.equalTo(@0);
        }];
        
        [_footerView addSubview:self.kfTtlelLabel];
        [_footerView addSubview:self.kfContentView];
        [_footerView addSubview:self.kfImageView];
        
        [self.kfTtlelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.submitBtn.mas_bottom).offset(40);
            make.centerX.equalTo(_footerView);
        }];
        [self.kfContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kfTtlelLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(24);
            make.centerX.equalTo(_footerView);
        }];
        CGFloat imageWidth = kScreenWidth - 70;
        CGFloat imageHeight = imageWidth / self.kfImageView.image.size.width * self.kfImageView.image.size.height;
        [self.kfImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kfContentView.mas_bottom).offset(25);
            make.width.mas_equalTo(imageWidth);
            make.height.mas_equalTo(imageHeight);
            make.centerX.equalTo(_footerView);
        }];
        
        [self.kfContentView addSubview:self.kfContentLabel];
        [self.kfContentView addSubview:self.storeBtn];
        
        [self.storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.kfContentView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(24);
            make.centerY.equalTo(self.kfContentView);
        }];
        [self.kfContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kfContentView);
            make.right.equalTo(self.storeBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.kfContentView);
        }];
        [self updateKFContentWidth];
    }
    return _footerView;
}
- (void)updateKFContentWidth{
    CGSize size = [self.kfContentLabel.text sizeWithFont:[UIFont fontWithName:kSDPFRegularFont size:13] maxSize:CGSizeMake(kScreenWidth, 40)];
    CGFloat height = size.width + 10 + 60 + 5;
    [self.kfContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(height);
    }];
}
- (UILabel *)kfTtlelLabel{
    if (!_kfTtlelLabel) {
        _kfTtlelLabel = [[UILabel alloc] init];
        _kfTtlelLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _kfTtlelLabel.textColor = [UIColor colorWithHex:0x25282D];
        _kfTtlelLabel.text = @"如何在支付宝APP中查看支付宝账号？";
    }
    return _kfTtlelLabel;
}
- (UILabel *)kfContentLabel{
    if (!_kfContentLabel) {
        _kfContentLabel = [[UILabel alloc] init];
        _kfContentLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        _kfContentLabel.textColor = [UIColor colorWithHex:0x8F9296];
        _kfContentLabel.text = @"若有疑问，请联系客服微信：--";
    }
    return _kfContentLabel;
}
- (UIButton *)storeBtn{
    if (!_storeBtn) {
        _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_storeBtn addTarget:self action:@selector(storeAction) forControlEvents:UIControlEventTouchUpInside];
        _storeBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:13];
        [_storeBtn setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
        _storeBtn.layer.cornerRadius = 12;
        _storeBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        _storeBtn.layer.borderWidth = 0.5;
    }
    return _storeBtn;
}
- (UIImageView *)kfImageView{
    if (!_kfImageView) {
        _kfImageView = [[UIImageView alloc] init];
        _kfImageView.image = [UIImage imageNamed:@"mine_bind_alipay_guide"];
    }
    return _kfImageView;
}
- (UIView *)kfContentView{
    if (!_kfContentView) {
        _kfContentView = [[UIView alloc] init];
    }
    return _kfContentView;
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
        _submitBtn.layer.cornerRadius = 22.5;
        _submitBtn.enabled = NO;
        _submitBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
- (UIView *)warningView{
    if (!_warningView) {
        _warningView = [[UIView alloc] init];
        _warningView.clipsToBounds = NO;
    }
    return _warningView;
}
- (UIImageView *)warningImageView{
    if (!_warningImageView) {
        _warningImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xingletao_mine_bindAlipay_warn"]];
    }
    return _warningImageView;
}
- (UILabel *)warningLabel{
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.text = @"温馨提示：请输入正确的支付宝账号和真实姓名，否则无法提现";
        _warningLabel.textColor = [UIColor letaomainColorSkinColor];
        _warningLabel.numberOfLines = 0;
        _warningLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _warningLabel.font = [UIFont fontWithName:kSDPFRegularFont size:11];
    }
    return _warningLabel;
}
- (NSArray *)dataDic{
    if (!_dataDic) {
        NSString *phone = [NSString stringWithFormat:@"%@",[XLTUserManager shareManager].curUserInfo.phone];
        _dataDic = @[
                    @{
                    @"name" : @"真实姓名",
                    @"code": @"realname",
                     @"palceholder":@"请输入真实姓名",
                     @"type":[NSNumber numberWithInt:0],
                    },
                    @{
                    @"name" : @"支付宝账号",
                    @"code": @"alipaycode",
                    @"palceholder":@"请输入支付宝账号",
                     @"type":[NSNumber numberWithInt:0],
                    },
                    @{
                    @"name" : @"手机号码",
                    @"code": @"phone",
                    @"palceholder": @"请输入手机号码",
                    @"value":[phone secretStrFromPhoneStr],
                    @"type":[NSNumber numberWithInt:0],
                    @"noedit":phone.length ? @"1":@"0",
                    },
                    @{
                     @"name" : @"验证码",
                     @"code": @"code",
                     @"palceholder":@"请输入验证码",
                     @"type":[NSNumber numberWithInt:1],
                    }];
    }
    return _dataDic;
}
- (UITableView *)contentView{
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        [_contentView registerNib: [UINib nibWithNibName:@"XLTUserAliPayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTUserAliPayTableViewCell"];
        _contentView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentView.separatorColor = [UIColor colorWithHex:0xededed];
//        _contentView.scrollEnabled = NO;
    }
    return _contentView;
}
#pragma mark Action
- (void)storeAction{
    if (self.kfStr.length) {
        [UIPasteboard generalPasteboard].string = self.kfStr;
        [self showTipMessage:[NSString stringWithFormat:@"已复制客服微信号：%@",self.kfStr]];
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"weixin://"] afterDelay:1];
    }
}
- (void)sendCodeAction{
    [XLTUserInfoLogic xingletaonetwork_bindAlipaySnedCodeWithSuccess:^(id balance) {
        
    } failure:^(NSString *errorMsg) {
        
    }];
}
- (void)submitAction{
    [XLTUserInfoLogic xingletaonetwork_bindAlipayWith:self.realName alipay:self.alipayCode code:self.code success:^(id balance) {
        if (self.infoDic) {
            [self showToastMessage:@"修改成功!"];
        }else{
            [self showToastMessage:@"绑定成功!"];
            [XLTUserManager shareManager].curUserInfo.bind_alipay = @1;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMsg) {
        [self showToastMessage:errorMsg];
    }];
}
- (void)checkStautWithParams:(NSString *)code value:(NSString* )value{
    BOOL status = value.length ? YES : NO;
    if ([code isEqualToString:@"realname"]) {
        self.hasRealName = status;
        self.realName = value;
    }else if ([code isEqualToString:@"alipaycode"]) {
        self.hasAlipayCode = status;
        self.alipayCode = value;
    }else if ([code isEqualToString:@"code"]) {
        self.hasCode = status;
        self.code = value;
    }else {
        
    }
    if (self.hasCode && self.hasAlipayCode && self.hasRealName) {
        self.submitBtn.backgroundColor = [UIColor letaomainColorSkinColor];
//        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitBtn.enabled = YES;
    }else{
        _submitBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
        self.submitBtn.enabled = NO;
    }
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTUserAliPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTUserAliPayTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.dataDic objectAtIndex:indexPath.row];
    XLT_WeakSelf;
    cell.sendCodeBlock = ^{
        XLT_StrongSelf;
        [self sendCodeAction];
    };
    cell.textFieldBlock = ^(NSString * _Nonnull code, NSString *value) {
        XLT_StrongSelf;
        [self checkStautWithParams:code value:value];
    };
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat imageWidth = kScreenWidth - 70;
    CGFloat imageHeight = imageWidth / self.kfImageView.image.size.width * self.kfImageView.image.size.height;
    return 220 + imageHeight + 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
@end
