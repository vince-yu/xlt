//
//  XLTUserNewPhoneLoginViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserNewPhoneLoginViewController.h"
#import "UIImage+UIColor.h"
#import "JKCountDownButton.h"
#import "XLTUserInfoLogic.h"
#import "UIColor+Helper.h"
#import "XLTUserManager.h"
#import "XLTUserInputNewPhoneVC.h"

@interface XLTUserNewPhoneLoginViewController ()
@property (nonatomic, weak) IBOutlet JKCountDownButton *verificationCodeButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *verificationCodeTextField;



@property (nonatomic, weak) IBOutlet UILabel *verificationCodeLabel;

@end

@implementation XLTUserNewPhoneLoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubmitButtonStyle];
    [self setupVerificationCodeButtonStyle];
    self.title = @"修改手机号";
    self.verificationCodeTextField.tintColor = [UIColor letaomainColorSkinColor];
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    [self observerVerificationCodeDidChangeNotification];
    
    self.verificationCodeLabel.text = [self verificationCodeLabelText];
}
- (void)viewWillAppear:(BOOL)animated{
    [self letaohiddenNavigationBar:YES];
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

- (void)pushBindVC{
    XLTUserInputNewPhoneVC *vc = [[XLTUserInputNewPhoneVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)submitBtnClicked:(id)sender {
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestnewPhoneChangeAndLoginWith:self.phoneNumber code:self.verificationCodeTextField.text success:^(id balance) {
        XLT_StrongSelf;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self showToastMessage:@"修改成功！"];
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self showToastMessage:errorMsg];
    }];
}

- (IBAction)leftBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)xingletaonetwork_requestVerificationCodeBtnClicked:(id)sender {
    XLT_WeakSelf;
    [XLTUserInfoLogic xingletaonetwork_requestphoneSendCodeWith:self.phoneNumber success:^(XLTBaseModel *model) {
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
            [self verificationCodeButtonStartCountDown];
            [self showToastMessage:@"验证码已发送，请注意查收"];
        }
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self showToastMessage:errorMsg];
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
