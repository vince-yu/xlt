//
//  XLTMyWatermarkSwitchCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyWatermarkSwitchCell.h"

@implementation XLTMyWatermarkSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)watermarkSwitchAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(watermarkSwitchCell:switchOn:)]) {
        [self.delegate watermarkSwitchCell:self switchOn:sender.on];
    }
}

@end
