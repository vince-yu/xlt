//
//  XLTUserBalanceHeadView.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserBalanceHeadView.h"
#import "XLTGoodsDisplayHelp.h"
#import "SPButton.h"
#import "XLTAlertViewController.h"
#import "XLTUserManager.h"
#import "SPButton.h"

@interface XLTUserBalanceHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *comesoonImcomLabel;
@property (weak, nonatomic) IBOutlet UILabel *takenImcomLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;
@property (weak, nonatomic) IBOutlet UIButton *headTipBtn;
@property (weak, nonatomic) IBOutlet UILabel *headTipView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freezeLabelBgWidth;
@property (weak, nonatomic) IBOutlet UIImageView *freezeLabelBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;
@property (weak, nonatomic) IBOutlet SPButton *memberBtn;
@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet UIButton *totalBtn;
@property (weak, nonatomic) IBOutlet UIButton *jsBtn;
@property (weak, nonatomic) IBOutlet UIButton *txBtn;
@property (weak, nonatomic) IBOutlet UIView *conentView;

@end

@implementation XLTUserBalanceHeadView
- (instancetype)initWithNib
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XLTUserBalanceHeadView" owner:nil options:nil] lastObject];
    if (self) {
        
        UIImage *image = [[UIImage imageNamed:@"xingletao_mine_balance_headerqb"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 15, 5, 15) resizingMode:UIImageResizingModeStretch];
        _freezeLabelBgImageView.image = image;
        [self.memberView addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(12.5, 12.5) viewRect:CGRectMake(0, 0, 95, 25)];
        self.memberView.layer.masksToBounds = YES;
        self.totalBtn.selected = YES;
        self.totalBtn.backgroundColor = [UIColor letaomainColorSkinColor];
        self.conentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.conentView.layer.shadowOffset = CGSizeMake(1, 1);
        self.conentView.layer.shadowOpacity = 0.15;
        self.conentView.layer.shadowRadius = 2.0;
    }
    return self;
}
- (void)setBalanceInfo:(XLTBalanceInfoModel *)balanceInfo{
    _balanceInfo = balanceInfo;
    self.rebateLabel.text = [NSString stringWithFormat:@"返利结算时间：%@天",[XLTUserManager shareManager].curUserInfo.config.xlt_rebate_time];
    [self handleData];
}
- (void)handleData{
    self.balanceLabel.text = [self.balanceInfo.amountUseable priceStr];
    self.totalIncomeLabel.text = [self.balanceInfo.amountTotal priceStr];
    self.takenImcomLabel.text = [self.balanceInfo.withdraw_success_amount priceStr];
    self.comesoonImcomLabel.text = [self.balanceInfo.unsettledAmount priceStr];
    if (([self.balanceInfo.estimatedRebateAmount isKindOfClass:[NSString class]]
        || [self.balanceInfo.estimatedRebateAmount isKindOfClass:[NSNumber class]])
        && [self.balanceInfo.estimatedRebateAmount floatValue] > 0) {
        self.headTipView.text = [NSString stringWithFormat:@"您还有￥%@返利金未领取，请及时到订单中领取",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:self.balanceInfo.estimatedRebateAmount]];
    }else{
        self.headTipView.text = @"温馨提示：返利金，需要手动到订单中进行领取！";
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"提现中:%@元",[self.balanceInfo.amountFrozen priceStr]]];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 12], NSForegroundColorAttributeName: [UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, 4)];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 12], NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFF34264]} range:NSMakeRange(4, attStr.length - 5)];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 12], NSForegroundColorAttributeName: [UIColor colorWithHex:0x25282D]} range:NSMakeRange(attStr.length - 1, 1)];
    
    
    
    self.freezeLabel.attributedText = attStr;
    CGFloat textWidth = ceilf([attStr.string sizeWithFont:[UIFont fontWithName:kSDPFMediumFont size: 12] maxSize:CGSizeMake(CGFLOAT_MAX, 17)].width);

    self.freezeLabelBgWidth.constant = ceilf(textWidth +45);
    
}
- (IBAction)tipBtnClickActipn:(id)sender {
    
}
- (IBAction)selectTimeAction:(id)sender {
    if (self.selectTimeBlock) {
        self.selectTimeBlock();
    }
}
- (void)setTime:(NSString *)timeStr{
    if (timeStr.length) {
        self.timeLabel.text = timeStr;
    }else{
        self.timeLabel.text = @"选择日期";
    }
}
- (IBAction)memberBtnClick:(id)sender {
    XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
           alertViewController.displayNotShowButton = NO;
    [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"结算时间" message:@"结算时间，会根据对应等级和交易金额，进行变化而变化，等级越高，结算时间越短，结算时间，最短可以日结！" sureButtonText:@"知道了" cancelButtonText:nil];
    
}
- (IBAction)totalAction:(id)sender {
    self.totalBtn.selected = YES;
    self.jsBtn.selected = NO;
    self.txBtn.selected = NO;
    self.totalBtn.backgroundColor = [UIColor letaomainColorSkinColor];
    self.txBtn.backgroundColor = [UIColor clearColor];
    self.jsBtn.backgroundColor = [UIColor clearColor];
    if (self.selectTypeBlock) {
        self.selectTypeBlock(0);
    }
}
- (IBAction)jsAction:(id)sender {
    self.totalBtn.selected = NO;
    self.jsBtn.selected = YES;
    self.txBtn.selected = NO;
    self.totalBtn.backgroundColor = [UIColor clearColor];
    self.txBtn.backgroundColor = [UIColor clearColor];
    self.jsBtn.backgroundColor = [UIColor letaomainColorSkinColor];
    if (self.selectTypeBlock) {
        self.selectTypeBlock(1);
    }
    
}
- (IBAction)txAction:(id)sender {
    self.totalBtn.selected = NO;
    self.jsBtn.selected = NO;
    self.txBtn.selected = YES;
    self.txBtn.backgroundColor = [UIColor letaomainColorSkinColor];
    self.totalBtn.backgroundColor = [UIColor clearColor];
    self.jsBtn.backgroundColor = [UIColor clearColor];
    if (self.selectTypeBlock) {
        self.selectTypeBlock(2);
    }
}

@end
