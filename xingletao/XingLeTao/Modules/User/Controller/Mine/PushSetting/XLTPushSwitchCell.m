//
//  XLTPushSwitchCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTPushSwitchCell.h"

@interface XLTPushSwitchCell ()


@end

@implementation XLTPushSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)pushSwitchValueChanged:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(cell:pushSwitchOn:)]) {
        [self.delegate cell:self pushSwitchOn:sender.on];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
