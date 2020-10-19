//
//  XLTVipGoodsCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipGoodsCell.h"

@interface XLTVipGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@end

@implementation XLTVipGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
}
- (void)setModel:(XLTVipGoodsModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:self.model.banner.firstObject] placeholderImage:[UIImage imageNamed:@"xinletao_placeholder_loading_small"]];
    self.nameLabel.text = [NSString checkStrLenthWithStr:self.model.title placeholder:@"--" appStr:nil before:NO];
    NSString *priceStr = [NSString checkStrLenthWithStr:[self.model.price priceStr] placeholder:@"0.00" appStr:@"￥" before:YES];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:11]} range:NSMakeRange(0, 1)];
    [attr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16]} range:NSMakeRange(1, priceStr.length - 1)];
    self.priceLabel.attributedText = attr;

}
@end
