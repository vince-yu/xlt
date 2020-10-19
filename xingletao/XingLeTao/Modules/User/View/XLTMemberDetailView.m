//
//  XLTMemberDetailView.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMemberDetailView.h"
#import "SPButton.h"

@interface XLTMemberDetailView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayIncome;
@property (weak, nonatomic) IBOutlet UILabel *yestIncome;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthIncome;
@property (weak, nonatomic) IBOutlet UILabel *totalIncome;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet SPButton *tipBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *activeOrder;
@property (weak, nonatomic) IBOutlet UILabel *activeMember;

@end

@implementation XLTMemberDetailView
- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTMemberDetailView" owner:nil options:nil] lastObject];
    if (self) {
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
//
        self.avatorImageView.layer.cornerRadius = 24;
        self.avatorImageView.layer.masksToBounds = YES;
        self.sureBtn.layer.cornerRadius = 17.5;
        self.sureBtn.layer.masksToBounds = YES;
        
        self.storeBtn.layer.cornerRadius = 10;
        self.storeBtn.layer.borderColor = [UIColor colorWithHex:0xFF8202].CGColor;
        self.storeBtn.layer.borderWidth = 1;
    }
    return self;
}
- (void)setModel:(XLTUserIncomeModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    [self.tipBtn setTitle:self.model.tip forState:UIControlStateNormal];
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    self.nameLabel.text = self.model.username.length ? self.model.username : @"";
    self.creatTimeLabel.text =
    self.todayIncome.text = self.model.today_estimate.length ? [self.model.today_estimate priceStr] : @"0";
    self.yestIncome.text = self.model.yesterday_estimate.length ? [self.model.yesterday_estimate priceStr] : @"0";
    self.lastMonthIncome.text = self.model.lastmonth_estimate.length ? [self.model.lastmonth_estimate priceStr] : @"0";
    self.totalIncome.text = self.model.unsettled_amount.length ? [self.model.unsettled_amount priceStr] : @"0";
    
    self.activeMember.text = self.model.vaild_direct_vip.length ? self.model.vaild_direct_vip : @"0";
    
    NSString *vailedOrder = self.model.valid_order_count.length ? self.model.valid_order_count : @"0";
    NSString *invailedOrder = self.model.invalid_order_count.length ? self.model.invalid_order_count : @"0";
    NSMutableAttributedString *orderAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",vailedOrder,invailedOrder]];
    [orderAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xF73737]} range:NSMakeRange(0, vailedOrder.length)];
    [orderAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC6C6C6]} range:NSMakeRange(vailedOrder.length,orderAttr.length - vailedOrder.length)];
    self.activeOrder.attributedText = orderAttr;
    
    NSString *phoneText = [NSString stringWithFormat:@"注册手机 %@",self.model.phone.length ? self.model.phone : @"--"];
    NSMutableAttributedString *phoneAttr = [[NSMutableAttributedString alloc] initWithString:phoneText];
    [phoneAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 4)];
    [phoneAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4,phoneText.length - 4)];
    self.phoneLabel.attributedText = phoneAttr;
    
    NSString *creatTimeText = self.model.itime.length ? [self.model.itime convertDateStringWithSecondTimeStr:@"注册时间 yyyy-MM-dd hh:mm:ss"] : @"注册时间 --";
    NSMutableAttributedString *createTimeAttr = [[NSMutableAttributedString alloc] initWithString:creatTimeText];
    [createTimeAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xA5A5A6]} range:NSMakeRange(0, 4)];
    [createTimeAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(4,creatTimeText.length - 4)];
    self.creatTimeLabel.attributedText = createTimeAttr;
    
    [self reloadView];
}
- (void)reloadView{
    
    if (self.model.canCopy.boolValue) {
//        self.phoneLabel.text = self.model.phone;
        self.storeBtn.hidden = NO;
        self.tipBtn.hidden = NO;
        self.lineTop.constant = 50;
        self.contentViewHeight.constant = 523;
    }else{
//        self.phoneLabel.text = @"";
        self.storeBtn.hidden = YES;
        self.tipBtn.hidden = YES;
        self.lineTop.constant = 30;
        self.contentViewHeight.constant = 503;
    }
}
- (IBAction)storeAction:(id)sender {
    [UIPasteboard generalPasteboard].string = self.model.phone;
    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功！"];
}
- (IBAction)sureAction:(id)sender {
    [self dissMiss];
}
- (void)show{
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
- (void)dissMiss{
    XLT_WeakSelf
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        XLT_StrongSelf
        self.alpha = 0;
    } completion:^(BOOL finished) {
        XLT_StrongSelf;
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
