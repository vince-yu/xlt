//
//  XLTCancelAccountSecondStepVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountSecondStepVC.h"
#import "XLTCancelAccountThirdStepVC.h"
#import "XLTUserManager.h"
#import "XLTCancelAccountLogic.h"

@interface XLTCancelAccountSecondStepVC ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *invailBalanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation XLTCancelAccountSecondStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *firstStr = @"1.您的账户将无法登录与使用\n2.您的账户信息和会员权益将永久删除且无法恢复\n3.您的收益与团队成员将永久清空且无法恢复\n4.您账户所关联的订单将无法查询与找回\n5.您绑定的微信号和手机号将无法短时间内再次注册星乐桃";
    NSString *finalStr = @"5.您绑定的微信号和手机号将无法短时间内再次注册星乐桃";
    CGSize size = [firstStr sizeWithFont:self.tipLabel.font maxSize:CGSizeMake(kScreenWidth - 30, 1000)];
//    self.tipViewHeight.constant = size.height + 35 + 20;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:firstStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xF73737]} range:[firstStr rangeOfString:finalStr]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];   
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [firstStr length])];

    self.tipLabel.attributedText = attr;
    self.title = @"账号注销";
    [self requestData];
    
}
- (void)requestData{
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTCancelAccountLogic requestCancelAccountReasonWithType:@"2" success:^(NSDictionary * _Nonnull info) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        if (info.count) {
            NSNumber *unsettled_amount = info[@"unsettled_amount"];
            NSNumber *amount_useable = info[@"amount_useable"];
            NSString *amount_useable_str = amount_useable != nil ? [NSString stringWithFormat:@"￥%@",[[NSString stringWithFormat:@"%@",amount_useable] fenToTransyuan]] : @"￥--";
            NSString *unsettled_amount_str = unsettled_amount != nil ? [NSString stringWithFormat:@"￥%@",[[NSString stringWithFormat:@"%@",unsettled_amount] fenToTransyuan]] : @"￥--";
            self.balanceLabel.text = amount_useable_str;
            self.invailBalanceLabel.text = unsettled_amount_str;
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self showTipMessage:errorMsg];
    }];
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
- (IBAction)nextSpaceAction:(id)sender {
    XLTCancelAccountThirdStepVC *vc = [[XLTCancelAccountThirdStepVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
