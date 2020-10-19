//
//  XLTUserBalaneCellTableViewCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserBalaneCellTableViewCell.h"

@interface XLTUserBalaneCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *letaosourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWitdh;

@end

@implementation XLTUserBalaneCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = 22.5;
//    self.backgroundColor = [UIColor letaolightgreyBgSkinColor];
//    self.contentView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
}
- (void)setModel:(XLTBalanceDetailModel *)model{
    _model = model;
    [self handleData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)handleData{
    if (self.model.itemSource.length) {
//        if ([self.model.itemSource isEqualToString:XLTTaobaoPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_tb"];
//        }else if ([self.model.itemSource isEqualToString:XLTTianmaoPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_tm"];
//        }else if ([self.model.itemSource isEqualToString:XLTJindongPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_jd"];
//        } else if ([self.model.itemSource isEqualToString:XLTPDDPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_pdd"];
//        }else if ([self.model.itemSource isEqualToString:XLTCZBPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_jy"];
//        }else if ([self.model.itemSource isEqualToString:XLTVPHPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_wbh"];
//        }else if ([self.model.itemSource isEqualToString:XLTVPHPlatformIndicate]) {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_mt"];
//        }else {
//            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_tb"];
//        }
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.icon_url] placeholderImage:[UIImage imageNamed:@"xinletao_placeholder_loading_small"]];
    }else{
        if (self.model.type.integerValue == 20 || self.model.type.integerValue == 21 || self.model.type.integerValue == 22) {
             self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_zfb"];
        } else if (self.model.type.integerValue == 30 || self.model.type.integerValue == 40 ) {
             self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_jl"];
        }else {
            self.iconImageView.image = [UIImage imageNamed:@"xingletao_mine_balance_freeze"];
        }
    }
    
    //10:商品返利 12:直接下级用户分佣 13:直接二代下级用户分佣 14:订单失效 15:金额变动 16:维权扣款 20:提现申请 21:提现拒绝 30:vip奖励 40:关系变动补偿]
    self.nameLabel.text = self.model.itemTitle;
    self.letaosourceLabel.text = self.model.typeText;

    if (self.model.totalAmount.integerValue >= 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@",[self.model.totalAmount priceStr]];
        self.moneyLabel.textColor = [UIColor colorWithHex:0xFF25282D];
    }else{
        self.moneyLabel.text = [self.model.totalAmount priceStr];
        self.moneyLabel.textColor = [UIColor colorWithHex:0xFFF73737];
    }
    if (self.model.itime == nil) {
        self.timeLabel.text = @"";
    }else{
        NSString *time = [NSString stringWithFormat:@"%ld",(long)self.model.itime.integerValue * 1000];
        self.timeLabel.text = [time convertDateStringWithTimeStr:@"yyyy-MM-dd hh:mm"];
    }
    if (self.model.type.integerValue == 20 || self.model.type.integerValue == 21) {
        //提现 当type=20时出现 申请中的各个状态-1:申请已拒绝1:冻结中2:审核通过3:付款完成99:付款失败
        self.statusLabel.hidden = NO;
        self.statusLabel.text = self.model.withdrawStatusText;
    } else {
        self.statusLabel.hidden = YES;
    }
    UIColor *reasonColor = [UIColor colorWithHex:0xFFF73737];
    BOOL isWithDraw = (self.model.type.integerValue == 20);
    if (isWithDraw
        &&[self.model.reason isKindOfClass:[NSString class]] && self.model.reason.length) {
        self.reasonLabel.hidden = NO;
        self.letaosourceLabel.textColor = reasonColor;
    } else {
        self.reasonLabel.hidden = YES;
        UIColor *normalColor = [UIColor colorWithHex:0xFF25282D];
        self.letaosourceLabel.textColor = normalColor;
    }
    [self.moneyLabel sizeToFit];
    self.priceWitdh.constant = self.moneyLabel.width + 5;
}
@end
