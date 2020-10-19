//
//  XLTCarcdOrderCell.m
//  XingLeTao
//
//  Created by vince on 2020/9/21.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCarcdOrderCell.h"

@interface XLTCarcdOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *earnLabelTop;

@end

@implementation XLTCarcdOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.goodImageView.layer.cornerRadius = 5.0;
    self.goodImageView.layer.masksToBounds = YES;
}
- (void)setModel:(XLTOrderListModel *)model{
    _model = model;
    XLTOrderForCartInfoModel *cartModel = self.model.creditCardOrderInfo;
    self.orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.model.third_order_id];
    //类型：Number  必有字段  备注：状态1 处理中 2 成功 3失败
    NSString *resultPre = @"通过时间 ";
    switch (cartModel.status.intValue) {
        case 1:
            self.statusLabel.text = @"审核中";
            self.earnLabelTop.constant = 16;
            self.resultTime.hidden = YES;
            break;
        case 2:
            self.statusLabel.text = @"即将到账";
            self.earnLabelTop.constant = 3;
            self.resultTime.hidden = NO;
            break;
        case 3:
            self.statusLabel.text = @"已失效";
            resultPre = @"未通过时间 ";
            self.earnLabelTop.constant = 3;
            self.resultTime.hidden = NO;
            break;
        default:
            break;
    }
    if (self.model.text_color.length > 1) {
        self.statusLabel.textColor = [UIColor colorWithHexString:[self.model.text_color substringWithRange:NSMakeRange(1, self.model.text_color.length - 1)]];
    }
    self.statusLabel.text = self.model.xlt_settle_status_text;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:[self.model.item_image letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    self.nameLabel.text = cartModel.card_name.length ? cartModel.card_name : @"";
    self.applyLabel.text = cartModel.phone.length ? [NSString stringWithFormat:@"申请人 %@",cartModel.phone] : @"";
    
    NSString *estimatedRebateAmount = [NSString stringWithFormat:@"￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:self.model.xlt_total_amount]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估返 %@",estimatedRebateAmount]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:14] range:NSMakeRange(0, attributedString.length - estimatedRebateAmount.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF25282D] range:NSMakeRange(0, attributedString.length - estimatedRebateAmount.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:16] range:NSMakeRange(attributedString.length - estimatedRebateAmount.length, estimatedRebateAmount.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF73737] range:NSMakeRange(attributedString.length - estimatedRebateAmount.length, estimatedRebateAmount.length)];
    self.earnLabel.attributedText = attributedString;
    
    self.applyTimeLabel.text = cartModel.itime.length ? [NSString stringWithFormat:@"申请时间 %@",[cartModel.itime convertDateStringWithSecondTimeStr:@"yyyy年MM月dd日 hh:mm"]] : @"";
    
    self.resultTime.text = cartModel.itime.length ? [NSString stringWithFormat:@"%@%@",resultPre,[cartModel.accept_time convertDateStringWithSecondTimeStr:@"yyyy年MM月dd日 hh:mm"]] : @"";
    
}
@end
