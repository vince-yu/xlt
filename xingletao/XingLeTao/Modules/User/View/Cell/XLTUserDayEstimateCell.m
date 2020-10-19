//
//  XLTUserDayEstimateCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserDayEstimateCell.h"

@interface XLTUserDayEstimateCell ()
@property (weak, nonatomic) IBOutlet UILabel *payCount;
@property (weak, nonatomic) IBOutlet UILabel *incomLabel;
@property (weak, nonatomic) IBOutlet UIView *contentVIew;

@end

@implementation XLTUserDayEstimateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentVIew.layer.cornerRadius = 6;
    self.contentVIew.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPayCountStr:(NSString *)payCountStr{
    _payCountStr = payCountStr;
    self.payCount.text = self.payCountStr.length ? self.payCountStr : @"0";
}
- (void)setPayIncomeStr:(NSString *)payIncomeStr{
    _payIncomeStr = payIncomeStr;
    self.incomLabel.text = self.payIncomeStr.length ? [self.payIncomeStr priceStr] : @"0";
}
@end
