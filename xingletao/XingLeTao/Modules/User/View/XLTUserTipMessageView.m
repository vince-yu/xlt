//
//  XLTUserTipMessageView.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserTipMessageView.h"
#import "XLTUserManager.h"
#import "WXApi.h"
#import "XLTUserInfoLogic.h"
#import "UIView+XLTLoading.h"
#import "XLTUserManager.h"
#import "XLTUserLoginVC.h"

@interface XLTUserTipMessageView (){

}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *letaodescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation XLTUserTipMessageView

- (instancetype)initWithNib {
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTUserTipMessageView" owner:nil options:nil] lastObject];
    if (self) {
        self.bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMiss)];
        [self.bgView addGestureRecognizer:tap];
//        self.warningLabel.text = [NSString stringWithFormat:@"到账时间%@天，请耐心等待",[XLTUserManager shareManager].curUserInfo.config.xlt_withdraw_date];
        
        self.warningLabel.text = nil;
    }
    return self;
}
- (void)setWaringStr:(NSString *)waringStr{
    self.warningLabel.text = self.waringStr;
}
- (void)setTitleStr:(NSString *)titleStr{
    self.titleLabel.text = self.titleStr;
}
- (void)setTipImage:(UIImage *)tipImage{
    [self.iconImageView setImage:tipImage];
}
- (void)setType:(XLTUserTipType)type{
    _type = type;
    if (type == XLTUserTipTypeBindWeiXin) {
        [self.iconImageView setImage:[UIImage imageNamed:@"xinletao_share_weixin"]];
        self.titleLabel.text = @"绑定微信";
        self.letaodescribeLabel.text = @"绑定微信才可以正常使用！";
        self.warningLabel.text = nil;
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.bgView.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWxinAuthRespNotification:) name:@"kWxinAuthRespNotificationName" object:nil];
    }else{
        
    }
}
- (void)receiveWxinAuthRespNotification:(NSNotification *)notification {
//    if(![XLTUserManager shareManager].isLoginViewControllerDisplay) {
        if ([notification.object isKindOfClass:[SendAuthResp class]]) {
            [self onResp:notification.object];
        }
//    }
}

- (void)onResp:(SendAuthResp *)resp {
    NSString *code = resp.code;
    if (code) {
        [self letaoletaoShowLoading];
        XLT_WeakSelf;
        [XLTUserInfoLogic bindWeiXinWithCode:code success:^(id object) {
            XLT_StrongSelf;
            XLTUserInfoModel *user = (XLTUserInfoModel *)object;
//            [XLTUserManager shareManager].curUserInfo.wechat_info = @1;
//            [[XLTUserManager shareManager] saveUserInfo];
            [self letaoletaoRemoveLoading];
            [self dissMiss];
            if ([XLTUserManager shareManager].isLoginViewControllerDisplay && user.invited.boolValue) {
                [[XLTUserManager shareManager] removeLoginViewController];
                [[XLTUserManager shareManager] loginUserInfo:user];
            }
        } failure:^(NSString *errorMsg) {
            XLT_StrongSelf;
            [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
            [self letaoletaoRemoveLoading];
            
        }];
    }
}
- (void)sendWxinAuthRequest {
    if([WXApi isWXAppInstalled]) {//判断用户是否已安装微信App
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        [WXApi sendReq:req completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/id414478124"]];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setDescribeStr:(NSString *)describeStr{
    if ([describeStr isKindOfClass:[NSAttributedString class]]) {
        self.letaodescribeLabel.attributedText = (NSAttributedString *)describeStr;
    }else if ([describeStr isKindOfClass:[NSString class]]){
        
        self.letaodescribeLabel.text = self.describeStr;
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id414478124?mt=8"]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show{
//    return;
//    if ([XLTAppPlatformManager shareManager].debugModel && self.type == XLTUserTipTypeBindWeiXin) {
//        return;
//    }
    if (self.superview) {
        return;
    }
    XLT_WeakSelf
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
- (IBAction)sureAction:(id)sender {
    if (self.type == XLTUserTipTypeBindWeiXin) {
        [self sendWxinAuthRequest];
    }else{
        [self dissMiss];
    }
    
}

- (void)dissMiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(userTipMessageViewDiDDissMiss)]) {
            [self.delegate userTipMessageViewDiDDissMiss];
        }
//        [[XLTAppPlatformManager shareManager] showbindInviterVC];
    }];
}
@end
