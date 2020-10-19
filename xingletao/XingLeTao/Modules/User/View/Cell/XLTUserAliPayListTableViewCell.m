//
//  XLTUserAliPayListTableViewCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserAliPayListTableViewCell.h"

@interface XLTUserAliPayListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameValue;
@property (weak, nonatomic) IBOutlet UILabel *aplipayCodeLabel;

@end

@implementation XLTUserAliPayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(id)model{
    _model = model;
    if ([self.model isKindOfClass:[NSDictionary class]]) {
        self.nameValue.text = [self.model objectForKey:@"realname"];
        self.aplipayCodeLabel.text = [self.model objectForKey:@"account"];
    }
}
- (IBAction)editAction:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}
@end
