//
//  XLTUserInputOldPhoneVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserInputOldPhoneVC.h"
#import "UIImage+UIColor.h"
#import "XLTUserManager.h"
#import "XLTUserInfoLogic.h"
#import "XLTWKWebViewController.h"
#import "XLTUserOldPhoneVerificationVC.h"


@interface XLTUserInputOldPhoneVC ()
@property (nonatomic, weak) IBOutlet UILabel *welcomeLabel;

@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UIButton *verificationCodeButton;


@end

@implementation XLTUserInputOldPhoneVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改手机号";
    [self setupVerificationCodeButtonStyle];
    [self observerPhoneTextFieldDidChangeNotification];

    self.phoneTextField.tintColor = [UIColor letaomainColorSkinColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
}
- (void)viewDidAppear:(BOOL)animated{
    [self.phoneTextField performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];
}
- (void)setupVerificationCodeButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.verificationCodeButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];

    [self.verificationCodeButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.layer.cornerRadius = 22.0;
    self.verificationCodeButton.enabled = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [self letaohiddenNavigationBar:YES];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verificationCodeBtnClicked:(id)sender {
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestoldPhoneSendCodeWith:self.phoneTextField.text success:^(XLTBaseModel *model) {
        XLT_StrongSelf;
        BOOL shoulPush = NO;
        if ([model isCorrectCode]
            || [[NSString stringWithFormat:@"%@",model.xlt_rcode] isEqualToString:@"425"]) {
            shoulPush = YES;
        } else {
            NSString *msg = model.message;
            if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                msg = Data_Error;
            }
            [self showToastMessage:msg];
        }
        if (shoulPush) {
            [self pushCodeVC];
            [self showToastMessage:@"验证码已发送，请注意查收"];
        }
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self showToastMessage:errorMsg];
    }];
    
}
- (void)pushCodeVC{
    XLTUserOldPhoneVerificationVC *vc = [[XLTUserOldPhoneVerificationVC alloc] init];
    vc.phoneNumber = self.phoneTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSString *)baseUrl {
    return [[XLTAppPlatformManager shareManager] baseH5SeverUrl];
}

- (IBAction)agreementBtnClicked:(id)sender {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.jump_URL = [[self baseUrl] stringByAppendingFormat:@"article.html"];
     web.title = @"星乐桃用户协议";
    [self.navigationController pushViewController:web animated:YES];
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
