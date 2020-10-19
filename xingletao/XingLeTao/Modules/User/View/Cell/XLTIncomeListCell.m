//
//  XLTIncomeListCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTIncomeListCell.h"

@interface XLTIncomeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *listBgView;
@property (weak, nonatomic) IBOutlet UILabel *listId;
@property (weak, nonatomic) IBOutlet UIButton *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation XLTIncomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.listBgView.layer.cornerRadius = 11.5;
    self.listBgView.layer.masksToBounds = YES;
    
    self.avatorImageView.layer.cornerRadius = 22.5;
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatorImageView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.avatorImageView.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    self.avatorImageView.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

}
- (void)configWithIndex:(NSInteger )index{
    switch (index) {
        case 2:{
            self.listBgView.hidden = NO;
            self.listBgView.backgroundColor = [UIColor colorWithHex:0xFEE8E8];
            self.priceLabel.textColor = [UIColor colorWithHex:0xF73737];
            self.listId.textColor = [UIColor colorWithHex:0xF73737];
        }
            break;
        case 3:{
            self.listBgView.hidden = NO;
            self.listBgView.backgroundColor = [UIColor colorWithHex:0xFBEFE3];
            self.priceLabel.textColor = [UIColor colorWithHex:0xFF8202];
            self.listId.textColor = [UIColor colorWithHex:0xFF8202];
        }
            break;
        default:
        {
            self.listBgView.hidden = YES;
//            self.listBgView.backgroundColor = [UIColor colorWithHex:0xFBEFE3];
            self.priceLabel.textColor = [UIColor colorWithHex:0x25282D];
            self.listId.textColor = [UIColor colorWithHex:0xB2B2B2];
        }
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.listId.text = [NSString stringWithFormat:@"%ld",(long)self.model.index + 1];
    [self configWithIndex:self.model.index + 1];
}
@end
