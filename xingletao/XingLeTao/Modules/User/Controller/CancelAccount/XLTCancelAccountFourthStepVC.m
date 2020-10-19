//
//  XLTCancelAccountFourthStepVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountFourthStepVC.h"
#import "XLTUserInfoLogic.h"
#import "JKCountDownButton.h"
#import "XLTCancelAccountLogic.h"
#import "XLTUserManager.h"

@interface XLTCancelAccountFourthStepVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic ,assign) BOOL isCodeing;
@end

@implementation XLTCancelAccountFourthStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.codeBtn.layer.cornerRadius = 15;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    self.title = @"手机号验证";
    [self changeWithPhone:NO];
    [self changeCancelBtnStatus:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)verificationCodeTextFieldDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (notification.object == self.phoneTextField) {
        [self changeWithPhone:[textField.text isPhoneNumber]];
    }else if (notification.object == self.codeTextField){
        if (textField.text.length == 6 && [self.phoneTextField.text isPhoneNumber]) {
            [self changeCancelBtnStatus:YES];
        }else{
            [self changeCancelBtnStatus:NO];
        }
    }
}
- (void)changeCancelBtnStatus:(BOOL )status{
    if (status) {
        self.nextBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
        self.nextBtn.enabled = NO;
    }
}
- (void)changeWithPhone:(BOOL )number{
    if (self.codeTextField.text.length == 6 && [self.codeTextField.text isPureInt] && number) {
        [self changeCancelBtnStatus:YES];
    }else{
        [self changeCancelBtnStatus:NO];
    }
    
    if (self.isCodeing) {
        
    }else{
        if (number) {
            self.codeBtn.enabled = YES;
            self.codeBtn.backgroundColor = RGBACOLOR(255, 130, 2, 0.05);
            [self.codeBtn setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
            self.codeBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
            self.codeBtn.layer.borderWidth = 0.5;
            [self.codeBtn setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
        }else{
            self.codeBtn.enabled = NO;
            self.codeBtn.backgroundColor = RGBACOLOR(208, 208, 208, 0.05);
            self.codeBtn.layer.borderColor = RGBACOLOR(204, 204, 204, 0.73).CGColor;
            [self.codeBtn setTitleColor:[UIColor colorWithHex:0xBEBEBE] forState:UIControlStateNormal];
            self.codeBtn.layer.borderWidth = 0.5;
            [self.codeBtn setTitleColor:[UIColor colorWithHex:0xBEBEBE] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)cancelAction:(id)sender {
    if (self.phoneTextField.text == nil || self.codeTextField.text == nil || ![self.phoneTextField.text isPhoneNumber] || ![self.codeTextField.text isPureInt] || self.codeTextField.text.length != 6) {
        [self showTipMessage:@"请输入正确的手机号和验证码！"];
        return;
    }
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTCancelAccountLogic requestCancelAccountWithPhone:self.phoneTextField.text code:self.codeTextField.text reason:[XLTUserManager shareManager].reasonArray Success:^(NSDictionary * _Nonnull info) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:@"申请成功！"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
}
- (IBAction)codeAction:(id)sender {
    XLT_WeakSelf;
    [XLTCancelAccountLogic requestCancelAccountSendCodeWithPhone:self.phoneTextField.text success:^(NSDictionary *dic) {
        XLT_StrongSelf;
//        BOOL shoulPush = NO;
//        XLTBaseModel *model = [XLTBaseModel modelWithDictionary:dic];
//        if ([model isCorrectCode]
//            || [[NSString stringWithFormat:@"%@",model.xlt_rcode] isEqualToString:@"425"]) {
//            shoulPush = YES;
//        } else {
//            NSString *msg = model.message;
//            if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
//                msg = Data_Error;
//            }
//            [self showToastMessage:msg];
//        }
//        if (shoulPush) {
            [self verificationCodeButtonStartCountDown];
            [self showToastMessage:@"验证码已发送，请注意查收"];
//        }
        
    } failure:^(NSString *errorMsg) {
        XLT_StrongSelf;
        [self showToastMessage:errorMsg];
        self.isCodeing = NO;
    }];
}
- (void)verificationCodeButtonStartCountDown {
    self.codeBtn.enabled = NO;
    [self.codeBtn startCountDownWithSecond:60];
    XLT_WeakSelf;
    [self.codeBtn countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        XLT_StrongSelf;
        NSString *title = [NSString stringWithFormat:@"重新发送(%zds)",second];
        countDownButton.layer.borderWidth = 0.5;
        countDownButton.enabled = NO;
        countDownButton.backgroundColor = RGBACOLOR(208, 208, 208, 0.05);
        countDownButton.layer.borderColor = RGBACOLOR(204, 204, 204, 0.73).CGColor;
        self.isCodeing = YES;
        [countDownButton setTitleColor:[UIColor colorWithHex:0xBEBEBE] forState:UIControlStateNormal];
        return title;
    }];
    [self.codeBtn countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        XLT_StrongSelf;
        countDownButton.enabled = YES;
        countDownButton.backgroundColor = RGBACOLOR(255, 130, 2, 0.05);
        countDownButton.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        countDownButton.layer.borderWidth = 0.5;
        self.isCodeing = NO;
        [countDownButton setTitleColor:[UIColor colorWithHex:0xFF8202] forState:UIControlStateNormal];
        [self changeWithPhone:[self.phoneTextField.text isPhoneNumber]];
        return @"获取验证码";
        
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
