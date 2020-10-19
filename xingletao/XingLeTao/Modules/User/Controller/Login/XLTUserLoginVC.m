//
//  XLTUserLoginVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserLoginVC.h"
#import "UIImage+UIColor.h"
#import "XLTUserManager.h"
#import "XLTUserPhoneVerificationCodeLoginVC.h"
#import "XLTUserLoginLogic.h"
#import "XLTUserInviteVC.h"
#import "XLTWKWebViewController.h"
#import "XLTShareManager.h"
#import "WechatAuthSDK.h"
#import "WXApi.h"
#import "SPButton.h"


@interface XLDLoginAgreementButton : UIButton

@end


@implementation XLDLoginAgreementButton
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect rectBig = CGRectMake(self.bounds.origin.x-10, self.bounds.origin.y-10, self.bounds.size.width+20, self.bounds.size.height+20);
    return CGRectContainsPoint(rectBig, point);
}
@end

@interface XLTUserLoginVC ()
@property (nonatomic, weak) IBOutlet UILabel *welcomeLabel;

@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UIButton *verificationCodeButton;

@property (nonatomic, strong) XLTUserLoginLogic *loginLogic;
@property (weak, nonatomic) IBOutlet UILabel *wxLable;
@property (weak, nonatomic) IBOutlet SPButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@property (weak, nonatomic) IBOutlet XLDLoginAgreementButton *agreementButton;

@end

@implementation XLTUserLoginVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWxinAuthRespNotification:) name:@"kWxinAuthRespNotificationName" object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adjustButtonStyle];
    [self observerPhoneTextFieldDidChangeNotification];
    
    self.phoneTextField.tintColor = [UIColor letaomainColorSkinColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.view.backgroundColor = [UIColor whiteColor];

    if (self.isBindPhoneStyle
        || !([WXApi isWXAppInstalled]) || (![XLTAppPlatformManager shareManager].checkEnable)) {
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = (obj.tag == 444);
        }];
        if (self.isBindPhoneStyle) {
            [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag == 555) {
                    obj.hidden = YES;
                }
            }];
        }
    }
    [self adjustAgreementButtonStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.phoneTextField performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.phoneTextField endEditing:YES];

}


- (void)adjustAgreementButtonStyle {
    BOOL isAgreedUserAgreement = [XLTAppPlatformManager shareManager].isAgreedUserAgreement;
    self.agreementButton.selected = isAgreedUserAgreement;
    self.agreementButton.layer.masksToBounds = YES;
    self.agreementButton.layer.cornerRadius = 5.0;
    [self.agreementButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]] forState:UIControlStateSelected];
    [self.agreementButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.agreementButton.layer.borderWidth = 0.5;
    if (isAgreedUserAgreement) {
        self.agreementButton.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    } else {
        self.agreementButton.layer.borderColor = [UIColor colorWithHex:0xFFE2E2E2].CGColor;
    }
}

- (IBAction)agreementButtonAction:(id)sender {
    BOOL isAgreedUserAgreement = [XLTAppPlatformManager shareManager].isAgreedUserAgreement;
    [[XLTAppPlatformManager shareManager] agreedUserAgreement:!isAgreedUserAgreement];
    [self adjustAgreementButtonStyle];
}

- (void)adjustButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.verificationCodeButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];

    [self.verificationCodeButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.layer.cornerRadius = 22.0;
    self.verificationCodeButton.enabled = NO;
}

- (BOOL)verifyPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber && [phoneNumber isKindOfClass:[NSString class]]) {
        NSString *regex = @"1[3456789]\\d{9}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        // 字符串判断，然后BOOL值
        BOOL result = [predicate evaluateWithObject:phoneNumber];
        return result;
    } else {
        return NO;
    }
}

- (void)observerPhoneTextFieldDidChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
}


- (void)phoneTextFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.phoneTextField) {
        self.verificationCodeButton.enabled = [self verifyPhoneNumber:self.phoneTextField.text];
    }
}

- (IBAction)closeBtnClicked:(id)sender {
    [[XLTUserManager shareManager] removeLoginViewController];
}

- (IBAction)verificationCodeBtnClicked:(id)sender {
    if (!self.isBindPhoneStyle) {
        [XLTUserManager shareManager].isWXLogin = NO;
    }
    
    BOOL isAgreedUserAgreement = [XLTAppPlatformManager shareManager].isAgreedUserAgreement;
    if (!isAgreedUserAgreement) {
        [self showTipMessage:@"请先同意用户协议和隐私政策"];
        [self.view endEditing:YES];
        return;
    }
    if (_loginLogic == nil) {
        _loginLogic = [[XLTUserLoginLogic alloc] init];
    }
    [self letaoShowLoading];
    __weak typeof(self)weakSelf = self;
    [_loginLogic xingletaonetwork_requestVerificationCodeWithPhone:self.phoneTextField.text success:^(XLTLoginVerificationCodeModel * _Nonnull model) {
        
         BOOL shoulPush = NO;
         if ([model isCorrectCode]
             || [[NSString stringWithFormat:@"%@",model.xlt_rcode] isEqualToString:@"425"]) {
             // code 425是重复发送验证码可以进下级页面
             shoulPush = YES;
         } else {
             NSString *msg = model.message;
             if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                 msg = Data_Error;
             }
             [weakSelf showToastMessage:msg];
         }
         if (shoulPush) {
             NSNumber *invited = nil;
             if ([model.data isKindOfClass:[NSDictionary class]]) {
                 //         invited:0 为绑定邀请人，1已经绑定
                 invited = model.data[@"invited"];
             }
             NSString *canSkipInvited = model.data[@"canSkipInvited"];
             // 是否是新用户
             NSString *is_new = model.data[@"is_new"];
             BOOL isNew = NO;
             if ([is_new isKindOfClass:[NSString class]] || [is_new isKindOfClass:[NSNumber class]]) {
                 isNew = [is_new boolValue];
             }
             XLTUserPhoneVerificationCodeLoginVC *verificationCodeViewController = [[XLTUserPhoneVerificationCodeLoginVC alloc] initWithNibName:@"XLTUserPhoneVerificationCodeLoginVC" bundle:[NSBundle mainBundle]];
             verificationCodeViewController.sid = self.sid;
             verificationCodeViewController.invitedFlag = invited;
             verificationCodeViewController.phoneNumber = self.phoneTextField.text;
             verificationCodeViewController.isNewUser = isNew;
             if ([canSkipInvited isKindOfClass:[NSString class]] || [canSkipInvited isKindOfClass:[NSNumber class]]) {
                 verificationCodeViewController.canSkipInvited = [canSkipInvited boolValue];
             }
             [weakSelf.navigationController pushViewController:verificationCodeViewController animated:YES];
             [weakSelf showToastMessage:@"验证码已发送，请注意查收"];
        
         }
         [weakSelf letaoRemoveLoading];
    } failure:^(NSString * _Nonnull errorMsg) {
        [weakSelf showToastMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
    }];
    
}

- (NSString *)baseUrl {
    
    return [[XLTAppPlatformManager shareManager] baseH5SeverUrl];
}

- (IBAction)agreementBtnClicked:(id)sender {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = [[self baseUrl] stringByAppendingFormat:@"article-service.html"];
     web.title = @"星乐桃用户协议";
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)privacyProtocalBtnClicked:(id)sender {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = kXLTPrivacyProtocal;
    web.title = @"星乐桃平台隐私政策协议";
    [self.navigationController pushViewController:web animated:YES];
}


- (IBAction)wixnBtnClicked:(id)sender {
    BOOL isAgreedUserAgreement = [XLTAppPlatformManager shareManager].isAgreedUserAgreement;
    if (!isAgreedUserAgreement) {
        [self showTipMessage:@"请先同意用户协议和隐私政策"];
        [self.view endEditing:YES];
        return;
    }
    [self sendWxinAuthRequest];
    [XLTUserManager shareManager].isWXLogin = YES;
}

- (void)sendWxinAuthRequest {
    if([WXApi isWXAppInstalled]) {//判断用户是否已安装微信App
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        [WXApi sendReq:req completion:nil];
       }
}

- (void)receiveWxinAuthRespNotification:(NSNotification *)notification {
    if (self.navigationController.viewControllers.lastObject == self) {
        if ([notification.object isKindOfClass:[SendAuthResp class]]) {
            [self onResp:notification.object];
        }
    }
}

- (void)onResp:(SendAuthResp *)resp {
    NSString *code = resp.code;
    if (code) {
        [self letaoShowLoading];
        if (_loginLogic == nil) {
            _loginLogic = [[XLTUserLoginLogic alloc] init];
        }
        __weak typeof(self)weakSelf = self;
        [_loginLogic loginWithWXinCode:code success:^(XLTUserInfoModel * _Nonnull model) {
            [weakSelf loginWithUserInfoModel:model];
            [weakSelf letaoRemoveLoading];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf showTipMessage:errorMsg];
            [weakSelf letaoRemoveLoading];
        }];

    }
}

- (void)loginWithUserInfoModel:(XLTUserInfoModel * _Nonnull)model {
    NSString *sid = model.data[@"sid"];
    NSString *invited = model.data[@"invited"];
    NSString *canSkipInvited = model.data[@"canSkipInvited"];
    // 是否是可以跳过
    BOOL canSkipInvitedFlag = NO;
    if ([canSkipInvited isKindOfClass:[NSString class]] || [canSkipInvited isKindOfClass:[NSNumber class]]) {
        canSkipInvitedFlag = [canSkipInvited boolValue];
    }
    NSString *token = model.data[@"token"];
    
    // 是否是新用户
    NSString *is_new = model.data[@"is_new"];
    BOOL isNew = NO;
    if ([is_new isKindOfClass:[NSString class]] || [is_new isKindOfClass:[NSNumber class]]) {
        isNew = [is_new boolValue];
    }
    
    if ([token isKindOfClass:[NSString class]] && [token length]) {
        if (canSkipInvited) {
            [[XLTUserManager shareManager] loginUserInfo:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLoginSuccess object:nil];
            [[XLTUserManager shareManager] removeLoginViewController];
            [[XLTRepoDataManager shareManager] repoLoginIsNewUser:isNew];
        } else {
            if ([invited isKindOfClass:[NSNumber class]] && [invited integerValue] == 1) {
                [[XLTUserManager shareManager] loginUserInfo:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLoginSuccess object:nil];
                [[XLTUserManager shareManager] removeLoginViewController];
                [[XLTRepoDataManager shareManager] repoLoginIsNewUser:isNew];
            } else {
                // 未绑定邀请人，去绑定邀请人页面
                XLTUserInviteVC *inviteVC = [[XLTUserInviteVC alloc] init];
                inviteVC.userInfo = model;
                [self.navigationController pushViewController:inviteVC animated:YES];
            }
        }
    } else {
        XLTUserLoginVC *loginViewController = [[XLTUserLoginVC alloc] initWithNibName:@"XLTUserLoginVC" bundle:[NSBundle mainBundle]];
        loginViewController.sid = sid;
        loginViewController.isBindPhoneStyle = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }

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
