//
//  XLTBindWXVC.m
//  XingLeTao
//
//  Created by vince on 2020/2/14.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBindWXVC.h"
#import "XLTUserManager.h"
#import "XLTUserInfoLogic.h"
#import "XLTUserTaskManager.h"

@interface XLTBindWXVC ()<UITextFieldDelegate>
@property (nonatomic ,strong) IBOutlet UIView *contentView;
@property (nonatomic ,strong) IBOutlet UITextField *contentField;
@property (nonatomic ,strong) IBOutlet UIButton *sureBtn;
@end

@implementation XLTBindWXVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    
}
- (void)textChange:(NSNotification *)note{
    UITextField *textField = note.object;
    if ([textField isEqual:self.contentField]) {
        if (textField.text.length >= 6) {
            [self updateSureBtn:YES];
        }else{
            [self updateSureBtn:NO];
        }
    }
}
- (void)initSubView{
    self.title = @"导师微信";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"请输入你的微信"];
    [attr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:13],NSForegroundColorAttributeName:[UIColor colorWithHex:0xB9B9B9]} range:NSMakeRange(0, attr.length)];
    self.contentField.attributedPlaceholder = attr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.contentField];
    self.contentView.clipsToBounds = YES;
    NSString *myWX = [XLTUserManager shareManager].curUserInfo.wechat_show_uid;
    if (myWX.length) {
        [self updateSureBtn:YES];
        self.contentField.text = myWX;
    }else{
        [self updateSureBtn:NO];
    }
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapAction{
    [self.view endEditing:YES];
}
- (void)updateSureBtn:(BOOL )canSure{
    if (canSure) {
        self.sureBtn.backgroundColor = [UIColor colorWithHex:0xFF8202];
        self.sureBtn.enabled = YES;
    }else{
        self.sureBtn.backgroundColor = [UIColor colorWithHex:0xC3C4C7];
        self.sureBtn.enabled = NO;
    }
    
}
- (BOOL )checkWXCode:(NSString *)code{
//    return YES;
    NSString* number= @"^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    BOOL value = [numberPre evaluateWithObject:code];
    return value;
}
- (IBAction)senderupdateWXAction{
    if (self.contentField.text.length < 6 || self.contentField.text.length > 20 || ![self checkWXCode:self.contentField.text]) {
        [self showTipMessage:@"请输入6~20位的微信号！"];
        return;
    }
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTUserInfoLogic updateShowWXWith:self.contentField.text success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:@"保存成功"];
        [XLTUserManager shareManager].curUserInfo.wechat_show_uid = self.contentField.text;
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadSettingVC)]) {
            [self.delegate reloadSettingVC];
        }
        [[XLTUserTaskManager shareManager] letaoRepoInputWeChatTaskInfo];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
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
