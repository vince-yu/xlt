//
//  XLDGoodsDetailFooterView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsDetailFooterView.h"
#import "XLTAppPlatformManager.h"
#import "XLTGoodsDisplayHelp.h"
#import "XLTUIConstant.h"
#import "XLTHomePageLogic.h"
@implementation XLDGoodsDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaoBuyBtn.titleLabel.numberOfLines = 0;
    self.letaoShareBtn.titleLabel.numberOfLines = 0;
    self.letaoLimitBuyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.letaoLimitBuyBtn.frame = CGRectMake(0, 0, self.bounds.size.width, 49);
    self.letaoLimitBuyBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    NSString *prefixText = @"立即购买";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:prefixText];
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, prefixText.length)];
    [self.letaoLimitBuyBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    self.letaoLimitBuyBtn.backgroundColor = [UIColor letaomainColorSkinColor];
    [self addSubview:self.letaoLimitBuyBtn];
    self.letaoLimitBuyBtn.hidden = YES;
}

- (void)letaoUpdateErarnAmount:(NSNumber *)amount
                   shareAmount:(NSNumber *)shareAmount
                  couponAmount:(NSNumber *)couponAmount
                 prepaidAmount:(NSNumber *)prepaidAmount
                   goodsSource:(NSString *)source
                   isPreCoupon:(BOOL)isPreCoupon
         isLetaoHighCommission:(BOOL)isLetaoHighCommission
                isPrepaidGoods:(BOOL)isPrepaidGoods
                 isCouponValid:(BOOL)isCouponValid{
    [self letaoUpdateErarnAmount:amount couponAmount:couponAmount prepaidAmount:prepaidAmount isPreCoupon:isPreCoupon isLetaoHighCommission:isLetaoHighCommission isPrepaidGoods:isPrepaidGoods isCouponValid:isCouponValid];
    [self letaoUpdateShareAmount:shareAmount];
    _letaoIsAliSource = ([source isKindOfClass:[NSString class]]
                                 && ([source isEqualToString:XLTTaobaoPlatformIndicate] || [source isEqualToString:XLTTianmaoPlatformIndicate]));
    self.letaoCommandBtn.hidden = ! _letaoIsAliSource;
    self.letaoShareBtn.hidden = NO;
    self.letaoLimitBuyBtn.hidden = YES;
}

- (void)letaoUpdateErarnAmount:(NSNumber *)amount
                  couponAmount:(NSNumber *)couponAmount
                 prepaidAmount:(NSNumber *)prepaidAmount
                   isPreCoupon:(BOOL)isPreCoupon
         isLetaoHighCommission:(BOOL)isLetaoHighCommission
                isPrepaidGoods:(BOOL)isPrepaidGoods
                 isCouponValid:(BOOL)isCouponValid{
    
    NSNumber *saveAmount = [NSNumber numberWithInt:amount.intValue + couponAmount.intValue];
    
    if ([amount isKindOfClass:[NSNumber class]]
        && [saveAmount intValue] > 0) {
        NSString *prefixText = @"省";
        NSString *lastText = @"元";
        NSString *suffixText = nil;
        NSString *amountText = nil;
        NSString *saveText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:saveAmount];
        UIColor *bgColor = nil;
        if (isLetaoHighCommission) {
            suffixText = isCouponValid ? @"立即领券" : @"立即购买";
            amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:amount];
            bgColor = [UIColor colorWithHex:0xFF7046E0];
        } else if (isPrepaidGoods) {
            if ([prepaidAmount isKindOfClass:[NSNumber class]]
                && [prepaidAmount intValue] > 0) {
                 suffixText = @"立即付定金";
                 amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:prepaidAmount];
            } else {
                suffixText = isCouponValid ? @"立即领券" : @"立即购买";
                amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:amount];
            }
            bgColor = [UIColor colorWithHex:0xFFF34264];
        } else if (isPreCoupon) {
            suffixText = @"提前领券";
            amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:amount];
            bgColor = [UIColor colorWithHex:0xFF13AB5A];
        } else {
            suffixText = isCouponValid ? @"立即领券" : @"立即购买";
            amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:amount];
            bgColor = [UIColor colorWithHex:0xFFF73737];
        }
        NSString *contentStr = nil;
        NSMutableAttributedString *attributedString = nil;
        if (isPreCoupon) {
            contentStr = [NSString stringWithFormat:@"%@%@%@\n%@",prefixText,amountText,lastText,suffixText];
            attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
            [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18]} range:[contentStr rangeOfString:amountText]];
        }else{
            contentStr = [NSString stringWithFormat:@"%@%@%@\n%@",prefixText,saveText,lastText,suffixText];
            attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
            [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18]} range:[contentStr rangeOfString:saveText]];
        }
        
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16]} range:[contentStr rangeOfString:prefixText]];
        
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16]} range:[contentStr rangeOfString:lastText]];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size:10]} range:[contentStr rangeOfString:suffixText]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[[UIColor whiteColor] colorWithAlphaComponent:0.7] range:[contentStr rangeOfString:suffixText]];

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName :paragraphStyle} range:NSMakeRange(0, attributedString.length)];

        [self.letaoBuyBtn setAttributedTitle:attributedString forState:UIControlStateNormal];

        [self.letaoBuyBtn setBackgroundColor:bgColor];

    } else {
        NSString *prefixText = @"立即购买";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:prefixText];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15]} range:NSMakeRange(0, prefixText.length)];

        [self.letaoBuyBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
        [self.letaoBuyBtn setBackgroundColor:[UIColor colorWithHex:0xFFF73737]];
    }
}

- (void)letaoUpdateShareAmount:(NSNumber *)amount {
    if ([amount isKindOfClass:[NSNumber class]]
        && [amount intValue] > 0 )
    {
        NSString *prefixText = @"赚";
        NSString *lastText = @"元";
        NSString *suffixText = @"立即分享";
        NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:amount];
        NSString *contentText = [NSString stringWithFormat:@"%@%@%@\n%@",prefixText,amountText,lastText,suffixText];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentText];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16]} range:NSMakeRange(0, prefixText.length)];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18]} range:[contentText rangeOfString:amountText]];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16]} range:[contentText rangeOfString:lastText]];
        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size:10]} range:[contentText rangeOfString:suffixText]];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:[[UIColor whiteColor] colorWithAlphaComponent:0.7] range:[contentText rangeOfString:suffixText]];

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName :paragraphStyle} range:NSMakeRange(0, attributedString.length)];

        [self.letaoShareBtn setAttributedTitle:attributedString forState:UIControlStateNormal];

    }
}
@end
