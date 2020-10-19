//
//  XLTLimitMakeOrderVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAddAddressVC.h"
#import "UIImage+UIColor.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTOrderLogic.h"
#import "XLTWKWebViewController.h"
#import <WebKit/WebKit.h>
//#import "XLTAliPayManager.h"
#import "XLTAddressPickerVC.h"
#import "XLTAddressLogic.h"

@interface XLTAddAddressVC () <XLTAddressPickerVCDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *pickAddressTextField;
@property (nonatomic, weak) IBOutlet UITextView *addressTextView;


@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) XLTOrderLogic *orderLogic;
@end

@implementation XLTAddAddressVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"填写收货地址";
    // Do any additional setup after loading the view from its nib.
    [self setupSubmitButtonStyle];
    [self observerVerificationCodeDidChangeNotification];
    
    self.phoneTextField.text = [self safeText:self.phone];
    self.nameTextField.text = [self safeText:self.name];
    self.addressTextView.text = [self safeText:self.sketch];
    [self loadPickAddressTextFieldText];
    
//    [self adjustSubmitButtonEnabledState];
    
}

- (NSString *)safeText:(id)text {
    if ([text isKindOfClass:[NSString class]]) {
        return text;
    } else {
        return nil;
    }
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

}

- (void)observerVerificationCodeDidChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self.addressTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verificationCodeTextFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.pickAddressTextField];

    
    
}


- (void)verificationCodeTextFieldDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self.nameTextField
        || notification.object == self.phoneTextField
        || notification.object == self.addressTextView
        || notification.object == self.pickAddressTextField) {
//        [self adjustSubmitButtonEnabledState];
    }
}

- (void)adjustSubmitButtonEnabledState {
    self.submitButton.enabled = ([self verifyName:self.nameTextField.text]
                                 && [self verifyPhoneNumber:self.phoneTextField.text]
                                 && [self verifyAddressText:self.addressTextView.text]
                                 && self.pickAddressTextField.text.length > 0);
}

- (BOOL)verifyAddressText:(NSString *)addressText {
    return (addressText.length >0 && addressText.length < 51);
}

- (BOOL)verifyName:(NSString *)name {
    if (name.length >0 && name.length < 13) {
        return ![name containsString:@" "];
    }
    return NO;
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


- (IBAction)submitAction:(id)sender {
    if (self.nameTextField.text.length < 1) {
        [self showTipMessage:@"收货人不能为空"];
    } else if (![self verifyName:self.nameTextField.text]) {
        [self showTipMessage:@"收货人不能超过12字符，不能输入空格"];
    } else if (self.phoneTextField.text.length < 1) {
        [self showTipMessage:@"手机号不能为空"];
    } else if (![self verifyPhoneNumber:self.phoneTextField.text]) {
        [self showTipMessage:@"手机号格式有误，请重新填写"];
    } else if (self.pickAddressTextField.text.length < 1) {
        [self showTipMessage:@"请选择所在地区"];
    } else if (self.addressTextView.text.length < 1) {
        [self showTipMessage:@"详细地址不能为空"];
    } else if (![self verifyAddressText:self.addressTextView.text]) {
        [self showTipMessage:@"详细地址不能超过50字符"];
    } else {
        [self letaoShowLoading];
        NSString *name = self.nameTextField.text;
        NSString *phone = self.phoneTextField.text;
        
        NSString *province_name = self.province[@"name"];
        NSString *province_id = self.province[@"id"];
        
        NSString *city_name = self.city[@"name"];
        NSString *city_code = self.city[@"id"];
        
        NSString *county_name = self.county[@"name"];
        NSString *county_code = self.county[@"id"];
        
        NSString *sketch = self.addressTextView.text;

        [self letaoShowLoading];
        __weak typeof(self)weakSelf = self;

        [XLTAddressLogic addAddressInfoWithName:name phone:phone province_name:province_name province_id:province_id city_name:city_name city_code:city_code county_name:county_name county_code:county_code sketch:sketch success:^(XLTBaseModel * _Nonnull goodsDetail, NSURLSessionDataTask * _Nonnull task) {
            [weakSelf letaoRemoveLoading];
            [weakSelf showToastMessage:@"保存地址成功"];
            [weakSelf didUpdateName:name phone:phone province_name:province_name province_id:province_id city_name:city_name city_code:city_code county_name:county_name county_code:county_code sketch:sketch];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
            [weakSelf showToastMessage:errorMsg];
            [weakSelf letaoRemoveLoading];
        }];
    }
}

- (void)didUpdateName:(NSString *)name
              phone:(NSString *)phone
      province_name:(NSString *)province_name
        province_id:(NSString *)province_id
city_name:(NSString *)city_name
          city_code:(NSString *)city_code
        county_name:(NSString *)county_name
        county_code:(NSString *)county_code
               sketch:(NSString *)sketch {
    if ([self.delegate respondsToSelector:@selector(addAddressVC:
                                                    name:
                                                    phone:
                                                    province_name:
                                                    province_id:
                                                    city_name:
                                                    city_code:
                                                    county_name:
                                                    county_code: sketch:)]) {
        [self.delegate addAddressVC:self
                           name:name
                          phone:phone
                  province_name:province_name
                    province_id:province_id
                      city_name:city_name
                      city_code:city_code
                    county_name:county_name
                    county_code:county_code sketch:sketch];
    }
}


- (IBAction)pickAddressAction:(id)sender {
    XLTAddressPickerVC *addressPickerVC = [[XLTAddressPickerVC alloc] init];
    addressPickerVC.province = self.province;
    addressPickerVC.city = self.city;
    addressPickerVC.county = self.county;
    addressPickerVC.delegate = self;
     addressPickerVC.view.hidden = YES;
       self.definesPresentationContext = YES;
       addressPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
       [self.navigationController presentViewController:addressPickerVC animated:NO completion:^{
           addressPickerVC.view.hidden = NO;
           addressPickerVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
           addressPickerVC.letaoBgView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
           [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
               addressPickerVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
               addressPickerVC.letaoBgView.transform=CGAffineTransformMakeTranslation(0, 0);
           } completion:^(BOOL finished) {
           }];
       }];
}

- (void)addressPickerVC:(XLTAddressPickerVC *)vc
pickedProvince:(NSDictionary * _Nullable)province
          city:(NSDictionary * _Nullable)city
                 county:(NSDictionary * _Nullable)county {
    self.province = province;
    self.city = city;
    self.county = county;
    
    [self loadPickAddressTextFieldText];
}

- (void)loadPickAddressTextFieldText {
    NSMutableArray *textArray = [NSMutableArray array];
    if (self.province[@"name"]) {
        [textArray addObject:self.province[@"name"]];
    }
    if (self.city[@"name"]) {
        [textArray addObject:self.city[@"name"]];
    }
    if (self.county[@"name"]) {
        [textArray addObject:self.county[@"name"]];
    }
    self.pickAddressTextField.text = [textArray componentsJoinedByString:@" "];
//     [self adjustSubmitButtonEnabledState];
}



- (void)setupSubmitButtonStyle {
    UIImage *normalStateImage  = [UIImage letaoimageWithColor:[UIColor letaomainColorSkinColor]];
    UIImage *disabledStateImage  = [UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFC3C4C7]];
    [self.submitButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];

    [self.submitButton setBackgroundImage:disabledStateImage forState:UIControlStateDisabled];
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 22.0;
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
