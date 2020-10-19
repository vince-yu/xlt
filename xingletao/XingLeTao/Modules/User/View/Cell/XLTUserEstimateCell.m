//
//  XLTUserEstimateCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserEstimateCell.h"

@interface XLTUserEstimateCell ()
@property (weak, nonatomic) IBOutlet UILabel *monthEsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthEsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthOrderLabel;
@property (weak, nonatomic) IBOutlet UIView *contentVIew;


@end

@implementation XLTUserEstimateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentVIew.layer.cornerRadius = 6;
    self.contentVIew.layer.masksToBounds = YES;
}
- (void)setModel:(XLTUserTeamIncomeModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    if ([_model isKindOfClass:[XLTUserTeamIncomeModel class]]) {
        XLTUserTeamIncomeModel *teamModel = (XLTUserTeamIncomeModel *)_model;
        self.monthEsLabel.text = teamModel.nowmonth_commission.length ? [teamModel.nowmonth_commission priceStr] : @"0";
        self.lastMonthEsLabel.text = teamModel.lastmonth_commission.length ? [teamModel.lastmonth_commission priceStr] : @"0";
        self.monthPayLabel.text = teamModel.nowmonth_estimate_commission.length ? [teamModel.nowmonth_estimate_commission priceStr] : @"0";
        self.lastMonthSetLabel.text = teamModel.lastmonth_estimate_commission.length ? [teamModel.lastmonth_estimate_commission priceStr] : @"0";
        self.monthBonusLabel.text = teamModel.nowmonth_reward.length ? [teamModel.nowmonth_reward priceStr] : @"0";
        self.lastMonthBonusLabel.text = teamModel.lastmonth_reward.length ? [teamModel.lastmonth_reward priceStr] : @"0";
        
        NSString *nowvail = teamModel.nowmonth_team_valid_order.length ? teamModel.nowmonth_team_valid_order : @"0";
        NSString *nowInvail = teamModel.nowmonth_team_invalid_order.length ? teamModel.nowmonth_team_invalid_order : @"0";
        NSMutableAttributedString *now = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",nowvail,nowInvail]];
        [now addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, now.length - nowInvail.length)];
        [now addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC9C9C9]} range:NSMakeRange(now.length - nowInvail.length, nowInvail.length)];
        self.monthOrderLabel.attributedText = now;
        
        NSString *lastvail = teamModel.lastmonth_team_valid_order.length ? teamModel.lastmonth_team_valid_order : @"0";
        NSString *lastInvail = teamModel.lastmonth_team_invalid_order.length ? teamModel.lastmonth_team_invalid_order : @"0";
        NSMutableAttributedString *last = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",lastvail,lastInvail]];
        [last addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, last.length - lastInvail.length)];
        [last addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC9C9C9]} range:NSMakeRange(last.length - lastInvail.length, lastInvail.length)];
        self.lastMonthOrderLabel.attributedText = last;
    }else if ([_model isKindOfClass:[XLTUserMineIncomeModel class]]){
        XLTUserMineIncomeModel *mineModel = (XLTUserMineIncomeModel *)_model;
        self.monthEsLabel.text = mineModel.nowmonth_total ? [mineModel.nowmonth_total priceStr] : @"0";
        self.lastMonthEsLabel.text = mineModel.lastmonth_total.length ? [mineModel.lastmonth_total priceStr] : @"0";
        self.monthPayLabel.text = mineModel.nowmonth_estimate.length ? [mineModel.nowmonth_estimate priceStr] : @"0";
        self.lastMonthSetLabel.text = mineModel.lastmonth_estimate.length ? [mineModel.lastmonth_estimate priceStr] : @"0";
        self.monthBonusLabel.text = mineModel.nowmonth_reward.length ? [mineModel.nowmonth_reward priceStr] : @"0";
        self.lastMonthBonusLabel.text = mineModel.lastmonth_reward.length ? [mineModel.lastmonth_reward priceStr] : @"0";
        
        NSString *nowvail = mineModel.nowmonth_valid_order_count.length ? mineModel.nowmonth_valid_order_count : @"0";
        NSString *nowInvail = mineModel.nowmonth_invalid_order_count.length ? mineModel.nowmonth_invalid_order_count : @"0";
        NSMutableAttributedString *now = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",nowvail,nowInvail]];
        [now addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, now.length - nowInvail.length)];
        [now addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC9C9C9]} range:NSMakeRange(now.length - nowInvail.length, nowInvail.length)];
        self.monthOrderLabel.attributedText = now;
        
        NSString *lastvail = mineModel.lastmonth_valid_order_count.length ? mineModel.lastmonth_valid_order_count : @"0";
        NSString *lastInvail = mineModel.lastmonth_invalid_order_count.length ? mineModel.lastmonth_invalid_order_count : @"0";
        NSMutableAttributedString *last = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",lastvail,lastInvail]];
        [last addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, last.length - lastInvail.length)];
        [last addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xC9C9C9]} range:NSMakeRange(last.length - lastInvail.length, lastInvail.length)];
        self.lastMonthOrderLabel.attributedText = last;
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
