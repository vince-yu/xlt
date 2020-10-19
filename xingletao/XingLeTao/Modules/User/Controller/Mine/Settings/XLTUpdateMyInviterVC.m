//
//  XLTUpdateMyInviterVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/10.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTUpdateMyInviterVC.h"
#import "XLTUserLoginLogic.h"
#import "XLTUserManager.h"
#import "XLTCommonAlertViewController.h"

@interface XLTUpdateMyInviterVC () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *inviteImageView;
@property (nonatomic, weak) IBOutlet UILabel *inviteLabel;
@property (nonatomic, weak) IBOutlet UITextField *inviteTextField;
@property (nonatomic, weak) IBOutlet UIView *inviteTextFieldBgView;

@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@property (nonatomic, weak) IBOutlet UIButton *recommendBtn;

@property (nonatomic, copy) NSString *inviteImageUrl;
@property (nonatomic, strong) NSMutableArray *sessionTaskArray;
@property (nonatomic, strong) XLTUserLoginLogic *loginLogic;
@property (nonatomic, copy) NSString *recommendInviterCode;
@property (nonatomic, assign) BOOL isRecommendFlag;

@end

@implementation XLTUpdateMyInviterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置上级邀请码";
    [self updateInvitePersonInfo:nil];
    [self observerPhoneTextFieldDidChangeNotification];
    
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.sureButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];
    [self.sureButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFB9B9B9],
                       NSFontAttributeName: [UIFont letaoRegularFontWithSize:14.0]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"请输入邀请码或邀请人手机号" attributes:attributes];
    self.inviteTextField.attributedPlaceholder = attributedString;
    if ([self.inviterCode isKindOfClass:[NSString class]] && self.inviterCode.length > 0) {
        self.inviteTextField.userInteractionEnabled = NO;
        self.sureButton.hidden = YES;
        UIColor *bgColor = self.view.backgroundColor;
       
        self.inviteTextField.backgroundColor = [UIColor clearColor];
        self.inviteTextFieldBgView.backgroundColor = bgColor;
        self.inviteTextFieldBgView.layer.borderColor = [UIColor colorWithHex:0xFFD5D8DB].CGColor;
        self.inviteTextFieldBgView.layer.borderWidth = 0.5;
        self.inviteTextField.textAlignment = NSTextAlignmentCenter;
        self.inviteTextField.text = [NSString stringWithFormat:@"邀请码：%@",self.inviterCode];
        [self fecthInvitePersonInfoWithInviteCode:self.inviterCode];
    } else {
        [self fetchRecommendInviter];
    }
    self.inviteTextField.tintColor = [UIColor letaomainColorSkinColor];
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
        [self textFieldDidChangeAction];
        // 只要改变了就不是推荐的
        self.isRecommendFlag = NO;
    }
}

- (void)textFieldDidChangeAction {
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

- (void)viewWillAppear:(BOOL)animated {
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
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

- (void)fecthInvitePersonInfo {
    [self fecthInvitePersonInfoWithInviteCode:self.inviteTextField.text];
}

- (void)fecthInvitePersonInfoWithInviteCode:(NSString *)inviteCode {
    if (self.loginLogic == nil) {
        self.loginLogic = [[XLTUserLoginLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    NSURLSessionTask *sessionTask = [self.loginLogic fecthInviteInfoForCode:inviteCode success:^(NSDictionary * _Nonnull inviteInfo, NSURLSessionTask * _Nonnull task) {
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

- (void)updateInviter {

    if (self.loginLogic == nil) {
        self.loginLogic = [[XLTUserLoginLogic alloc] init];
    }
    __weak typeof(self)weakSelf = self;
    NSString *invitePerson = self.inviteLabel.text;
    NSString *inviteCode = self.inviteTextField.text;
    NSString *inviter_avatar = self.inviteImageUrl.copy;

    [self.loginLogic bindInviteCode:inviteCode isRecommendFlag:self.isRecommendFlag success:^(XLTUserInfoModel * _Nonnull model) {
        [XLTUserManager shareManager].curUserInfo.inviter = invitePerson;
        [XLTUserManager shareManager].curUserInfo.inviter_avatar = inviter_avatar;
        [[XLTUserManager shareManager] saveUserInfo];
        [weakSelf updateInviterSuccess];
      } failure:^(NSString * _Nonnull errorMsg) {
          [weakSelf showToastMessage:errorMsg];
      }];
}

- (void)updateInviterSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kXLTUpdateMyInviterNotifications object:nil];
    [self showTipMessage:@"上级邀请码设置成功"];
    [self.navigationController popViewControllerAnimated:YES];
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
    } else {
        self.inviteImageView.image = nil;
        self.inviteLabel.text = nil;
    }
}


- (IBAction)bindBtnClicked:(id)sender {
    XLTCommonAlertViewController *alertViewController = [[XLTCommonAlertViewController alloc] init];
    [alertViewController letaoPresentWithSourceVC:self.navigationController title:@"提示" message:@"确定绑定该邀请码，绑定后将不能更改！" cancelButtonText:@"取消" sureButtonText:@"确实"];
    __weak typeof(self)weakSelf = self;
    alertViewController.letaoalertViewAction = ^(NSInteger clickIndex) {
        if (clickIndex == 1) {
            [weakSelf updateInviter];
        }
    };
}


- (IBAction)recommendBtnClicked:(id)sender {
    if ([self.recommendInviterCode isKindOfClass:[NSString class]]) {
//        if (![self.inviteTextField.text isEqualToString:self.recommendInviterCode])
        {
            self.inviteTextField.text = self.recommendInviterCode;
            // 标记是推荐邀请码
            self.isRecommendFlag = YES;
            [self textFieldDidChangeAction];
        }
    }
}

- (void)fetchRecommendInviter {
    __weak typeof(self)weakSelf = self;
    [XLTUserLoginLogic fetchRecommendInviterSuccess:^(NSDictionary * _Nonnull inviteInfo, NSURLSessionTask * _Nonnull task) {
        [weakSelf fetchRecommendInviterSuccess:inviteInfo];
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionTask * _Nonnull task) {
        
    }];
}

- (void)fetchRecommendInviterSuccess:(NSDictionary *)inviteInfo {
    NSString *inviterCode = inviteInfo[@"inviterCode"];
    if ([inviterCode isKindOfClass:[NSString class]] && inviterCode.length > 0) {
        self.recommendInviterCode = inviterCode;
        self.recommendBtn.hidden = NO;
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
