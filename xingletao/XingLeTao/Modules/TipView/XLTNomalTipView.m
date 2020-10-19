//
//  XLTUserTipMessageView.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNomalTipView.h"
#import "XLTUserManager.h"
#import "WXApi.h"
#import "XLTUserInfoLogic.h"
#import "UIView+XLTLoading.h"
#import "XLTUserManager.h"

@interface XLTNomalTipView (){

}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *letaodescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation XLTNomalTipView
+ (void)showTipWithTitle:(NSString *)title describe:(NSString *)des sureTitle:(NSString *)sure sureBlock:(void(^)(void))sureBlock{
    XLTNomalTipView *view = [[XLTNomalTipView alloc] initWithNib];
    view.titleLabel.text = title;
    if (des && [des isKindOfClass:[NSString class]]) {
        view.letaodescribeLabel.text = des;
    }
    if (sure.length) {
        [view.sureBtn setTitle:sure forState:UIControlStateNormal];
    }
    [view show];
}
- (instancetype)initWithNib {
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTNomalTipView" owner:nil options:nil] lastObject];
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
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self dissMiss];
    
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
    }];
}
@end
