//
//  XLTUpdateInvaterVC.m
//  XingLeTao
//
//  Created by SNQU on 2020/2/25.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTUpdateInvaterVC.h"
#import "XLTUserManager.h"
#import "XLTUserInfoLogic.h"
#import "XLTInviterModel.h"
#import "XLTCommonAlertViewController.h"
#import "XLTInvaterRecommendView.h"

@interface XLTUpdateInvaterVC ()<UITextFieldDelegate,XLTInvaterRecommendDelegate>
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UITextField *contentField;
@property (nonatomic ,strong) UILabel *describeLabel;
@property (nonatomic ,strong) UIButton *sureBtn;
@property (nonatomic ,strong) UILabel *tipLabel;
//@property (nonatomic ,strong)
@property (nonatomic ,strong) UILabel *warnLabel;
@property (nonatomic ,strong) XLTInvaterRecommendView *recommendView;

@end

@implementation XLTUpdateInvaterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
}
- (void)requestData{
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTUserInfoLogic getInviterInfoSuccess:^(id  _Nonnull info) {
        XLT_StrongSelf;
        XLTInviterModel *model = info;
        self.nameLabel.text = model.invite_link_code.length ? [NSString stringWithFormat:@"当前邀请码：%@",model.invite_link_code] : [NSString stringWithFormat:@"当前邀请码：%@",[XLTUserManager shareManager].curUserInfo.invite_link_code] ;
        self.describeLabel.text = model.show_content.length ? model.show_content : @"";
        [self updateSureBtn:model.can_set];
        [self letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
- (void)initSubView{
    self.title = @"更改邀请码";
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.describeLabel];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.describeLabel.mas_bottom).offset(35);
        make.height.mas_equalTo(55);
    }];
    [self.view addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
    }];
    
//    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentField];
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(45);
//        make.top.equalTo(self.contentView.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50 - kBottomSafeHeight);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(12);
    }];
    
//    NSString *inviter = [XLTUserManager shareManager].curUserInfo.wechat_show_uid;
//    if (myWX.length) {
//        [self updateSureBtn:YES];
//    }else{
        [self updateSureBtn:@"0"];
//    }
    [self.view addSubview:self.warnLabel];
    [self.view addSubview:self.recommendView];
    self.warnLabel.hidden = YES;
    self.recommendView.hidden = YES;
    
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.height.mas_equalTo(100);
    }];
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}
- (XLTInvaterRecommendView *)recommendView{
    if (!_recommendView) {
        _recommendView = [[XLTInvaterRecommendView alloc] initWithNib];
        _recommendView.delegate = self;
    }
    return _recommendView;
}
- (UILabel *)warnLabel{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc] init];
        _warnLabel.textColor = [UIColor colorWithHex:0xFA0C0C];
        _warnLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
    }
    return _warnLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"更改之前的邀请码保留7天的有效期";
        _tipLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _tipLabel.textColor = [UIColor colorWithHex:0xFF8202];
    }
    return _tipLabel;
}
- (void)tapAction{
    [self.view endEditing:YES];
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
    }
    return _contentView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHex:0x25282D];
        _nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _nameLabel.text = [NSString stringWithFormat:@"当前邀请码：%@",[XLTUserManager shareManager].curUserInfo.invite_link_code];
    }
    return _nameLabel;
}
- (UITextField *)contentField{
    if (!_contentField) {
        _contentField = [[UITextField alloc] init];
        _contentField.placeholder = @"只能输入数字、大写字母或两者组合";
//        _contentField.text = [XLTUserManager shareManager].curUserInfo.wechat_show_uid;
        _contentField.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        _contentField.delegate = self;
    }
    return _contentField;
}
- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.text = @"";
        _describeLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _describeLabel.textColor = [UIColor colorWithHex:0xB0B0B0];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.numberOfLines = 0;
    }
    return _describeLabel;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(updateWXAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 22.5;
    }
    return _sureBtn;
}
- (void)updateSureBtn:(id )canSure{
    if (canSure) {
        if ([canSure boolValue]) {
            self.sureBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
            self.sureBtn.enabled = YES;
            self.contentField.enabled = YES;
            [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            self.recommendView.hidden = NO;
//            self.tipLabel.hidden = NO;
        }else{
            self.sureBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
            self.sureBtn.enabled = NO;
            self.contentField.enabled = NO;
            [self.sureBtn setTitle:@"权限已用完" forState:UIControlStateNormal];
//            self.tipLabel.hidden = YES;
            self.recommendView.hidden = YES;
        }
        
    }else{
        self.sureBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
        self.sureBtn.enabled = NO;
        self.contentField.enabled = NO;
        [self.sureBtn setTitle:@"暂无权限" forState:UIControlStateNormal];
        self.recommendView.hidden = YES;
//        self.tipLabel.hidden = YES;
    }
    
}
- (void)updateCheckConfigWithError:(NSString *)error{
    if (error.length) {
        [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).offset(32);
        }];
        self.warnLabel.text = error;
        self.warnLabel.hidden = NO;
    }else{
        [self.recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).offset(10);
        }];
        self.warnLabel.text = @"";
        self.warnLabel.hidden = YES;
    }
}
- (void)checkInvaterCode{
    if (self.contentField.text.length != 5) {
        [self updateCheckConfigWithError:nil];
        return;
    }
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTUserInfoLogic checkInviter:self.contentField.text success:^(NSDictionary * _Nonnull info) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self updateCheckConfigWithError:nil];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self updateCheckConfigWithError:errorMsg];
    }];
}
- (void)updateWXAction{
    if (self.contentField.text.length < 5) {
        [self showTipMessage:@"请输入5位邀请码！"];
        return;
    }
    XLTCommonAlertViewController *alertViewController = [[XLTCommonAlertViewController alloc] init];
//           alertViewController.displayNotShowButton = NO;
    XLT_WeakSelf;
    alertViewController.letaoalertViewAction = ^(NSInteger clickIndex) {
        XLT_StrongSelf;
        if (clickIndex) {
            [self updateInviteCode];
        }
        
    };
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"更改后将不能改回之前的邀请码，更改之前的邀请码保留7天的有效期，有效期过后将作废，确定要改吗？"];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, 15)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xF73737]} range:NSMakeRange(15, 16)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(31, attrStr.length - 31)];
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"" message:attrStr messageTextAlignment:NSTextAlignmentCenter cancelButtonText:@"取消" sureButtonText:@"确定更改"];
    
    
}
- (void)updateInviteCode{
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTUserInfoLogic updateInviter:self.contentField.text success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:@"保存成功"];
        [self requestData];
        [XLTUserManager shareManager].curUserInfo.invite_link_code = self.contentField.text;
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length >= 6) {
//        [self updateSureBtn:YES];
//    }else{
//        [self updateSureBtn:NO];
//    }
//    [self checkInvaterCode];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length && textField.text.length >= 5) {
        return NO;
    }else{
//        [self checkInvaterCode];
    }
    
    return YES;
}
- (void)textChanged:(NSNotification *)note{
    UITextField *textField = note.object;
    if ([textField isEqual:self.contentField]) {
        [self checkInvaterCode];
    }
}
#pragma mark InvaterViewDelegate
- (void)selectCode:(NSString *)str{
    self.contentField.text = str;
    [self checkInvaterCode];
}
@end
