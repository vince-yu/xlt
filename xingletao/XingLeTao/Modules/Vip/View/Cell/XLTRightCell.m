//
//  XLTRightCell.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTRightCell.h"

@implementation XLTRightCellModel


@end

@interface XLTRightCell ()
@property (nonatomic ,strong) UIImageView *leftContentImageView;
@property (nonatomic ,strong) UILabel *leftContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@end

@implementation XLTRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(XLTVipRightItemDetail *)model{
    if (!model) {
        return;
    }
    _model = model;
    [self.leftBgImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"xlt_vip_item_commisson_4"]];
//    self.leftBgImageView.image = [UIImage imageNamed:@"xlt_vip_item_commisson_4"];
    NSMutableString *str = [[NSMutableString alloc] init];
    if (_model.title.length) {
        [str appendFormat:@"%@\n",_model.title];
    }
    if (_model.subtitle.length) {
        [str appendString:_model.subtitle];
    }
    self.rightLabel.text = self.model.subtitle;
    self.titleLable.text = self.model.title;
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
//    [attStr addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:15],NSForegroundColorAttributeName:[UIColor colorWithHex:0x25282D]} range:NSMakeRange(0, _model.title.length)];
//    [attStr addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:13],NSForegroundColorAttributeName:[UIColor colorWithHex:0xB8B7B7]} range:NSMakeRange(attStr.length - _model.subtitle.length, _model.subtitle.length)];
//    self.rightLabel.attributedText = attStr;
//
//    switch (model.type) {
//        case XLTRightTypeBuyBili:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_left_%@",self.model.level]];
//        }
//            break;
//        case XLTRightTypeShareBili:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_left_%@",self.model.level]];
//
//        }
//            break;
//        case XLTRightTypeCommission:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_commisson_%@",self.model.level]];
//
//        }
//            break;
//        case XLTRightTypeVipUp:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_up_%@",self.model.level]];
//
//        }
//            break;
//        case XLTRightTypeGetBigCoupon:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_coupon_%@",self.model.level]];
//
//        }
//            break;
//        case XLTRightTypeGetNew:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_new_%@",self.model.level]];
//
//        }
//            break;
//        case XLTRightTypeFH:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_fh_%@",self.model.level]];
//
//        }
//            break;
//        case XLTRightTypeGZ:
//        {
//            self.leftBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xlt_vip_item_gz_%@",self.model.level]];
//
//        }
//            break;
//        default:
//            break;
//    }
//    self.rightLabel.text = self.model.content;
}
@end
