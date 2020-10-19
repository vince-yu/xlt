//
//  XLTUserPhoneVerificationCodeLoginVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserPhoneVerificationCodeLoginVC.h"
#import "UIImage+UIColor.h"
#import "JKCountDownButton.h"
#import "XLTUserLoginLogic.h"
#import "UIColor+Helper.h"
#import "XLTUserManager.h"
#import "XLTUserInviteVC.h"
#import "XLTAppPlatformManager.h"

@interface XLTUserPhoneVerificationCodeLoginVC ()
@property (nonatomic, weak) IBOutlet JKCountDownButton *verificationCodeButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *verificationCodeTextField;

@property (nonatomic, strong) XLTUserLoginLogic *loginLogic;


@property (nonatomic, weak) IBOutlet UILabel *verificationCodeLabel;

@end

@implementation XLTUserPhoneVerificationCodeLoginVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubmitButtonStyle];
    [self setupVerificationCodeButtonStyle];
    self.view.backgroundColor = [UIColor whiteColor];

    self.verificationCodeTextField.tintColor = [UIColor letaomainColorSkinColor];
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    [self observerVerificationCodeDidChangeNotification];
    
    self.verificationCodeLabel.text = [self verificationCodeLabelText];
}

- (NSString *)verificationCodeLabelText {
    NSMutableString *verificationCodeLabelText = [[NSMutableString alloc] initWithString: @"验证码已发送至+86 "];
    if (self.phoneNumber.length >= 11) {
        [verificationCodeLabelText appendString:[self.phoneNumber substringToIndex:3]];
        [verificationCodeLabelText appendString:@" "];
        
        [verificationCodeLabelText appendString:[self.phoneNumber substringWithRange:NSMakeRange(3, 4)]];
        [verificationCodeLabelText appendString:@" "];
        
        [verificationCodeLabelText appendString:[self.phoneNumber substringWithRange:NSMakeRange(7, 4)]];
    } else {
        [verificationCodeLabelText appendString:self.phoneNumber];
    }
    return verificationCodeLabelText;
}

- (void)setupSubmitButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.submitButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];

    [self.submitButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 22.0;
    self.submitButton.enabled = NO;
}

- (void)setupVerificationCodeButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:UIColorMakeRGBA(255, 130, 2, 0.05)];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.verificationCodeButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];
    [self.verificationCodeButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    
    [self.verificationCodeButton setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
    [self.verificationCodeButton setTitleColor:[UIColor colorWithHex:0xFFFEFEFE] forState:UIControlStateDisabled];

    
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.layer.cornerRadius = 15.0;
    self.verificationCodeButton.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.verificationCodeButton.layer.borderWidth = 1.0;

    [self verificationCodeButtonStartCountDown];
}

- (void)verificationCodeButtonStartCountDown {
    self.verificationCodeButton.enabled = NO;
    [self.verificationCodeButton startCountDownWithSecond:60];
    [self.verificationCodeButton countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"重新发送(%zds)",second];
        countDownButton.layer.borderWidth = 0;
        return title;
    }];
    [self.verificationCodeButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        countDownButton.layer.borderWidth = 1.0;
        return @"获取验证码";
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}

- (BOOL)isValidVerifyCode:(NSString *)verifyCode {
    if (verifyCode && [verifyCode isKindOfClass:[NSString class]]) {
        NSString *regex = @"^\\d{6}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        // 字符串判断，然后BOOL值
        BOOL result = [predicate evaluateWithObject:verifyCode];
        return result;
    } else {
        return NO;
    }
}

- (void)observerVerificationCodeDidChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.verificationCodeTextField];
}


- (void)verificationCodeTextFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.verificationCodeTextField) {
        self.submitButton.enabled = [self isValidVerifyCode:self.verificationCodeTextField.text];
    }
}


- (IBAction)submitBtnClicked:(id)sender {
    if (_loginLogic == nil) {
        _loginLogic = [[XLTUserLoginLogic alloc] init];
    }
    if ([XLTUserManager shareManager].isWXLogin) {
        [self submitWithUser];
    }else{
        [self submitWithNoUser];
    }
}
- (void)pushInviteVC:(BOOL )isAlter{
    XLTUserInviteVC *inviteCodeController = [[XLTUserInviteVC alloc] initWithNibName:@"XLTUserInviteVC" bundle:[NSBundle mainBundle]];
    inviteCodeController.isAlter = isAlter;
    inviteCodeController.sid = self.sid;
    inviteCodeController.phoneNumber = self.phoneNumber;
//    inviteCodeController.verificationCode = verificationCode;
    inviteCodeController.canSkip = self.canSkipInvited;
    [self.navigationController pushViewController:inviteCodeController animated:YES];
}
- (void)submitWithNoUser{
    [self letaoShowLoading];
    __weak typeof(self)weakSelf = self;
    if (self.canSkipInvited) {
        // 可以跳过逻辑
        if (([self.invitedFlag isKindOfClass:[NSNumber class]] && ![self.invitedFlag boolValue]
             && self.isNewUser)) {
             NSString *verificationCode = self.verificationCodeTextField.text;
             [_loginLogic xingletaonetwork_requesLoginWithPhone:self.phoneNumber code:verificationCode success:^(XLTUserInfoModel * _Nonnull model) {
                 if (model.wechat_info.boolValue) {
                     if (model.invited.boolValue) {
                         // 登录成功 关闭页面
                         [[XLTUserManager shareManager] removeLoginViewController];
                         [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                         [weakSelf letaoRemoveLoading];
                     }else{
                         [weakSelf pushInviteVC:YES];
                     }
                     
                 }else{
                     [[XLTAppPlatformManager shareManager] showbindWXTipViewIfNeed];
                     [weakSelf pushInviteVC:YES];
                 }
                 [weakSelf letaoRemoveLoading];
                } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
                    [weakSelf showToastMessage:errorMsg];
                    [weakSelf letaoRemoveLoading];
                }];
         } else {
             [_loginLogic loginWithPhone:self.phoneNumber verificationCode:self.verificationCodeTextField.text
                                     sid:self.sid
                              inviteCode:nil
                                 success:^(XLTUserInfoModel * _Nonnull model) {
                 // 登录成功 关闭页面
                 [[XLTUserManager shareManager] removeLoginViewController];
                 [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                 [weakSelf letaoRemoveLoading];
             } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
                 [weakSelf showToastMessage:errorMsg];
                 [weakSelf letaoRemoveLoading];
             }];
         }
    } else {
        // 必须绑定邀请码
        if ([self.invitedFlag isKindOfClass:[NSNumber class]]
             && ![self.invitedFlag boolValue]) {
             NSString *verificationCode = self.verificationCodeTextField.text;
             [_loginLogic xingletaonetwork_requesLoginWithPhone:self.phoneNumber code:verificationCode success:^(XLTUserInfoModel * _Nonnull model) {
                 if (model.wechat_info.boolValue) {
                     if (model.invited.boolValue) {
                         // 登录成功 关闭页面
                         [[XLTUserManager shareManager] removeLoginViewController];
                         [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                         [weakSelf letaoRemoveLoading];
                     }else{
                         [weakSelf pushInviteVC:YES];
                     }
                     
                 }else{
                     [[XLTAppPlatformManager shareManager] showbindWXTipViewIfNeed];
                     [weakSelf pushInviteVC:YES];
                 }
                 [weakSelf letaoRemoveLoading];
                } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
                    [weakSelf showToastMessage:errorMsg];
                    [weakSelf letaoRemoveLoading];
                }];
         } else {
             [_loginLogic loginWithPhone:self.phoneNumber verificationCode:self.verificationCodeTextField.text
                                     sid:self.sid
                              inviteCode:nil
                                 success:^(XLTUserInfoModel * _Nonnull model) {
                 // 登录成功 关闭页面
                 [[XLTUserManager shareManager] removeLoginViewController];
                 [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                 [weakSelf letaoRemoveLoading];
             } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
                 [weakSelf showToastMessage:errorMsg];
                 [weakSelf letaoRemoveLoading];
             }];
         }
    }
}
- (void)submitWithUser{
    [self letaoShowLoading];
    __weak typeof(self)weakSelf = self;
    if (self.canSkipInvited) {
        // 可以跳过逻辑
        if (([self.invitedFlag isKindOfClass:[NSNumber class]] && ![self.invitedFlag boolValue]
             && self.isNewUser)) {
             NSString *verificationCode = self.verificationCodeTextField.text;
             [_loginLogic verificationPhone:self.phoneNumber
                              verificationCode:verificationCode
                                        sid:self.sid
                                       success:^(XLTUserInfoModel * _Nonnull model) {
                 XLTUserInviteVC *inviteCodeController = [[XLTUserInviteVC alloc] initWithNibName:@"XLTUserInviteVC" bundle:[NSBundle mainBundle]];
                 inviteCodeController.sid = self.sid;
                 inviteCodeController.phoneNumber = self.phoneNumber;
                 inviteCodeController.verificationCode = verificationCode;
                 inviteCodeController.canSkip = self.canSkipInvited;
                 [weakSelf.navigationController pushViewController:inviteCodeController animated:YES];
                 [weakSelf letaoRemoveLoading];
                } failure:^(NSString * _Nonnull errorMsg) {
                    [weakSelf showToastMessage:errorMsg];
                    [weakSelf letaoRemoveLoading];
                }];
         } else {
             [_loginLogic loginWithPhone:self.phoneNumber verificationCode:self.verificationCodeTextField.text
                                     sid:self.sid
                              inviteCode:nil
                                 success:^(XLTUserInfoModel * _Nonnull model) {
                 // 登录成功 关闭页面
                 [[XLTUserManager shareManager] removeLoginViewController];
                 [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                 [weakSelf letaoRemoveLoading];
             } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
                 [weakSelf showToastMessage:errorMsg];
                 [weakSelf letaoRemoveLoading];
             }];
         }
    } else {
        // 必须绑定邀请码
        if ([self.invitedFlag isKindOfClass:[NSNumber class]]
             && ![self.invitedFlag boolValue]) {
             NSString *verificationCode = self.verificationCodeTextField.text;
             [_loginLogic verificationPhone:self.phoneNumber
                              verificationCode:verificationCode
                                        sid:self.sid
                                       success:^(XLTUserInfoModel * _Nonnull model) {
                 if ([model isKindOfClass:[XLTUserInfoModel class]] && model.invited) {
                     // 登录成功 关闭页面
                     
                     [[XLTUserManager shareManager] removeLoginViewController];
                     [[XLTUserManager shareManager] loginUserInfo:model];
                     [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLoginSuccess object:nil];
                     [weakSelf letaoRemoveLoading];
                 }else{
                     XLTUserInviteVC *inviteCodeController = [[XLTUserInviteVC alloc] initWithNibName:@"XLTUserInviteVC" bundle:[NSBundle mainBundle]];
                     inviteCodeController.sid = self.sid;
                     inviteCodeController.phoneNumber = self.phoneNumber;
                     inviteCodeController.verificationCode = verificationCode;
                     [weakSelf.navigationController pushViewController:inviteCodeController animated:YES];
                     [weakSelf letaoRemoveLoading];
                 }
                 
                } failure:^(NSString * _Nonnull errorMsg) {
                    [weakSelf showToastMessage:errorMsg];
                    [weakSelf letaoRemoveLoading];
                }];
         } else {
             [_loginLogic loginWithPhone:self.phoneNumber verificationCode:self.verificationCodeTextField.text
                                     sid:self.sid
                              inviteCode:nil
                                 success:^(XLTUserInfoModel * _Nonnull model) {
                 // 登录成功 关闭页面
                 [[XLTUserManager shareManager] removeLoginViewController];
                 [[XLTRepoDataManager shareManager] repoLoginIsNewUser:self.isNewUser];
                 [weakSelf letaoRemoveLoading];
             } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
                 [weakSelf showToastMessage:errorMsg];
                 [weakSelf letaoRemoveLoading];
             }];
         }
    }
}
- (IBAction)leftBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)xingletaonetwork_requestVerificationCodeBtnClicked:(id)sender {
    if (_loginLogic == nil) {
           _loginLogic = [[XLTUserLoginLogic alloc] init];
       }
    __weak typeof(self)weakSelf = self;
    [_loginLogic xingletaonetwork_requestVerificationCodeWithPhone:self.phoneNumber success:^(XLTLoginVerificationCodeModel * _Nonnull model) {
        BOOL shoulPush = NO;
         if ([model isCorrectCode]
             || [[NSString stringWithFormat:@"%@",model.xlt_rcode] isEqualToString:@"425"]) {
             shoulPush = YES;
         } else {
             NSString *msg = model.message;
             if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                 msg = Data_Error;
             }
             [weakSelf showToastMessage:msg];
         }
         if (shoulPush) {
             [weakSelf verificationCodeButtonStartCountDown];
             [weakSelf showToastMessage:@"验证码已发送，请注意查收"];
         }
        
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showToastMessage:errorMsg];
    }];
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
