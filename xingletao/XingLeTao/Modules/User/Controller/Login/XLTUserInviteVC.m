//
//  XLTUserInviteVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserInviteVC.h"
#import "UIImage+UIColor.h"
#import "XLTUserManager.h"
#import "XLTUserLoginLogic.h"
#import "XLTUserInviteSucceedVC.h"
#import "UIImageView+WebCache.h"
#import "XLTAlertViewController.h"

@interface XLTUserInviteVC () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *inviteTextField;
@property (nonatomic, weak) IBOutlet UILabel *inviteTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;

@property (nonatomic, weak) IBOutlet UIImageView *inviteImageView;

@property (nonatomic, weak) IBOutlet UILabel *inviteLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sureButtonTop;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;

@property (nonatomic, strong) NSMutableArray *sessionTaskArray;

@property (nonatomic, strong) XLTUserLoginLogic *loginLogic;
@property (nonatomic, copy) NSString *inviteImageUrl;
@end

@implementation XLTUserInviteVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSMutableArray *)sessionTaskArray {
    if(!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}

- (void)cancelInviteInfoRequest {
    @synchronized (self) {
        [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.sessionTaskArray removeAllObjects];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSureButtonStyle];
    [self observerPhoneTextFieldDidChangeNotification];
    self.inviteTextField.delegate = self;
    [self updateInvitePersonInfo:nil];
    self.inviteImageView.layer.masksToBounds = YES;
    self.inviteImageView.layer.cornerRadius = 22.0;
    self.skipButton.hidden = !self.canSkip;
}

- (IBAction)leftBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observerPhoneTextFieldDidChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.inviteTextField];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length + textField.text.length > 11) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.inviteTextField) {
        // 取消请求并且更新空的邀请人信息
        [self cancelInviteInfoRequest];
        [self updateInvitePersonInfo:nil];
        
        // 满足条件去获取新的邀请人信息
        BOOL isValidVerifyCode = [self isValidVerifyCode:self.inviteTextField.text];
        BOOL isValidPhoneNumber = [self isValidPhoneNumber:self.inviteTextField.text];
        if (isValidVerifyCode || isValidPhoneNumber) {
            [self fecthInvitePersonInfo];
        }
    }
}


- (void)setupSureButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.sureButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];

    [self.sureButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 22.0;
    self.sureButton.enabled = NO;
}

- (BOOL)isValidVerifyCode:(NSString *)verifyCode {
    if (verifyCode && [verifyCode isKindOfClass:[NSString class]]) {
        NSString *regex = @"[0-9A-Za-z]{5}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        // 字符串判断，然后BOOL值
        BOOL result = [predicate evaluateWithObject:verifyCode];
        return result;
    } else {
        return NO;
    }
}

- (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
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

- (void)show{
//    return;
//    if ([XLTAppPlatformManager shareManager].debugModel && self.type == XLTUserTipTypeBindWeiXin) {
//        return;
//    }
    if (self.view.superview) {
        return;
    }
    XLT_WeakSelf
    self.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];

    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.view.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
- (void)dissMiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self.view removeFromSuperview];
    }];
}
- (IBAction)sureBtnClicked:(id)sender {
        if (self.isAlter) {
        [self bindInviter];
    }else{
        [self loginWithInviter];
    }
     
}
- (void)bindInviter{
    if (self.loginLogic == nil) {
          self.loginLogic = [[XLTUserLoginLogic alloc] init];
      }
    __weak typeof(self)weakSelf = self;
    NSString *invitePerson = self.inviteLabel.text;
    NSString *inviteCode = self.inviteTextField.text;
    NSString *inviter_avatar = self.inviteImageUrl.copy;
    [self letaoShowLoading];
    [_loginLogic bindInvitorWithCode:inviteCode
                        success:^(XLTUserInfoModel * _Nonnull model) {
        // 登录成功 关闭页面
        [XLTUserManager shareManager].curUserInfo.inviter = invitePerson;
        [XLTUserManager shareManager].curUserInfo.inviter_avatar = inviter_avatar;
        [[XLTUserManager shareManager] saveUserInfo];
        [[XLTUserManager shareManager] removeLoginViewController];
        [weakSelf letaoRemoveLoading];
        [[XLTRepoDataManager shareManager] repoLoginIsNewUser:YES];
    } failure:^(NSString *errorMsg) {
        [weakSelf showToastMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
    }];
}
- (void)loginWithInviter {
    if (self.loginLogic == nil) {
          self.loginLogic = [[XLTUserLoginLogic alloc] init];
      }
    __weak typeof(self)weakSelf = self;
    NSString *invitePerson = self.inviteLabel.text;
    NSString *inviteCode = self.inviteTextField.text;
    NSString *inviter_avatar = self.inviteImageUrl.copy;
    [self letaoShowLoading];
    [_loginLogic loginWithPhone:self.phoneNumber
               verificationCode:self.verificationCode
                            sid:self.sid
                     inviteCode:inviteCode
                        success:^(XLTUserInfoModel * _Nonnull model) {
        // 登录成功 关闭页面
        [XLTUserManager shareManager].curUserInfo.inviter = invitePerson;
        [XLTUserManager shareManager].curUserInfo.inviter_avatar = inviter_avatar;
        [[XLTUserManager shareManager] saveUserInfo];
        [[XLTUserManager shareManager] removeLoginViewController];
        [weakSelf letaoRemoveLoading];
        [[XLTRepoDataManager shareManager] repoLoginIsNewUser:YES];
    } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
        [weakSelf showToastMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
        BOOL isCodeTimeOut = (([code isKindOfClass:[NSString class]] && [code integerValue] == 400001)
                              || ([code isKindOfClass:[NSNumber class]] && [code integerValue] == 400001));
        if (isCodeTimeOut) {
            // 返回上级页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)skipBtnClicked:(id)sender {
    if (_loginLogic == nil) {
        _loginLogic = [[XLTUserLoginLogic alloc] init];
    }

    __weak typeof(self)weakSelf = self;
    [_loginLogic loginWithPhone:self.phoneNumber
               verificationCode:self.verificationCode
                            sid:self.sid
                     inviteCode:nil
                        success:^(XLTUserInfoModel * _Nonnull model) {
        // 登录成功 关闭页面
        [[XLTUserManager shareManager] removeLoginViewController];
        [[XLTRepoDataManager shareManager] repoLoginIsNewUser:YES];
        [weakSelf letaoRemoveLoading];
        [weakSelf respoSkipInviteCode];
    } failure:^(NSString *errorMsg,NSNumber  * _Nullable code) {
        [weakSelf showToastMessage:errorMsg];
        [weakSelf letaoRemoveLoading];
    }];
}

- (void)respoSkipInviteCode {
    [_loginLogic skipInviteCodeSuccess:^(XLTUserInfoModel * _Nonnull model) {
        // do nothing
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}

- (void)updateInvitePersonInfo:(NSDictionary * _Nullable)info {
    BOOL  haveInvitePersonInfo = ([info isKindOfClass:[NSDictionary class]] && info.count > 0);
    self.sureButton.enabled = haveInvitePersonInfo;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 333) {
            obj.hidden = !haveInvitePersonInfo;
        }
    }];

    if (haveInvitePersonInfo) {
        NSString *personImageUrl = info[@"avatar"];
        NSString *personPhone = info[@"username"];
        if ([personImageUrl isKindOfClass:[NSString class]]) {
            [self.inviteImageView sd_setImageWithURL:[NSURL URLWithString:personImageUrl] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
            self.inviteImageUrl = personImageUrl;
        } else {
            self.inviteImageView.image = [UIImage imageNamed:@"xingletao_mine_header_placeholder"];
        }
        if ([personPhone isKindOfClass:[NSString class]]) {
            self.inviteLabel.text = personPhone;
        } else {
            self.inviteLabel.text = nil;
        }
        self.sureButtonTop.constant = 25;
    } else {
        self.inviteImageView.image = nil;
        self.inviteLabel.text = nil;
        self.sureButtonTop.constant = -25;
    }
}


- (void)fecthInvitePersonInfo {
    if (self.loginLogic == nil) {
        self.loginLogic = [[XLTUserLoginLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [self.loginLogic fecthInviteInfoForCode:self.inviteTextField.text success:^(NSDictionary * _Nonnull inviteInfo, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.sessionTaskArray containsObject:task]) {
            [weakSelf.sessionTaskArray removeObject:task];
            [weakSelf updateInvitePersonInfo:inviteInfo];
        }
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
        if ([weakSelf.sessionTaskArray containsObject:task]) {
            [weakSelf.sessionTaskArray removeObject:task];
            [weakSelf showTipMessage:errorMsg];
        }
    }];
    sessionTask ? [self.sessionTaskArray  addObject:sessionTask] : nil ;
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
