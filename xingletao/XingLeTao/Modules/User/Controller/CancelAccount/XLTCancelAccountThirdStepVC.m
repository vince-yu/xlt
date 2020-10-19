//
//  XLTCancelAccountThirdStepVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountThirdStepVC.h"
#import "XLTCancelAccountAlertVC.h"
#import "XLTCancelAccountFourthStepVC.h"

@interface XLTCancelAccountThirdStepVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic ,strong) XLTCancelAccountAlertVC *alterVC;
@end

@implementation XLTCancelAccountThirdStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *firstStr = @"1.账号注销审核时长5日，若审核期间撤销注销，账号可继续使用\n2.账号注销审核期间，若继续使用APP产生相关收益数 据或会员权益，未及时撤销账号注销申请，都将视为您已放弃在星乐桃中获得的所有权益\n3.账号注销成功后30日内无法重新注册星乐桃账号，请 确认账号的交易是否都已结算且无纠纷，账号注销后的历史交易资金权益都将视为自动放弃";
    CGSize size = [firstStr sizeWithFont:self.tipLabel.font maxSize:CGSizeMake(kScreenWidth - 30, 1000)];
//    self.tipViewHeight.constant = size.height + 30 + 50;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:firstStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [firstStr length])];

    self.tipLabel.attributedText = attr;
    self.title = @"账号注销";
    
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
- (IBAction)nextAction:(id)sender {
    [self showAlter];
}
- (void)showAlter{
    if (self.alterVC.view.superview) {
        return;
    }
    XLT_WeakSelf
    self.alterVC.view = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.alterVC.view];

    [self.alterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alterVC.view.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
- (void)dissMiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alterVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self.alterVC.view removeFromSuperview];
    }];
}
- (XLTCancelAccountAlertVC *)alterVC{
    if (!_alterVC) {
        _alterVC = [[XLTCancelAccountAlertVC alloc] init];
        XLT_WeakSelf;
        _alterVC.cancelBlock = ^{
            XLT_StrongSelf;
            
            [self dissMiss];
        };
        _alterVC.dismisBlock = ^{
            XLT_StrongSelf;
            [self.alterVC.view removeFromSuperview];
            XLTCancelAccountFourthStepVC *vc = [[XLTCancelAccountFourthStepVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _alterVC;
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
