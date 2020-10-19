//
//  XLTIncomListFirstCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTIncomListFirstCell.h"


@interface XLTIncomListFirstCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation XLTIncomListFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.listLabel addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight withRadii:CGSizeMake(7.5, 7.5) viewRect:CGRectMake(0, 0, 34, 15)];
    self.listLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.listLabel.layer.borderWidth = 1.0;
    self.listLabel.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius = 22.5;
    self.avatorImageView.layer.masksToBounds = YES;
//    [self.contentView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10, 10) viewRect:CGRectMake(0, 0, kScreenWidth, 150)];
}
- (void)setModel:(XLTUserIncomListModel *)model{
    _model = model;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xingletao_mine_header_placeholder"]];
    self.nameLabel.text = [NSString checkStrLenthWithStr:self.model.nick placeholder:@"" appStr:nil before:NO];
    NSString *priceStr = [NSString checkStrLenthWithStr:[self.model.income priceStr] placeholder:@"0.00" appStr:@"￥" before:YES];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:10]} range:NSMakeRange(0, 1)];
    [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14]} range:NSMakeRange(1, priceStr.length - 1)];
    self.priceLabel.attributedText = attr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
