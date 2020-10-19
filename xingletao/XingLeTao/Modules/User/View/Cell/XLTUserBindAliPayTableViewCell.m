//
//  XLTAddAlipayCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserBindAliPayTableViewCell.h"

@interface XLTUserBindAliPayTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation XLTUserBindAliPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textFiled.enabled = NO;
    self.addBtn.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
