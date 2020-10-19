//
//  XLTHomeScrollGoodsItemCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/10.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeScrollGoodsItemCell.h"


@interface XLTHomeScrollGoodsItemCell ()
@property (nonatomic, weak) IBOutlet UILabel *earnInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceInfoLabel;
@property (nonatomic, weak) IBOutlet UIImageView *goodsImageView;

@property (nonatomic, weak) IBOutlet UILabel *couponLabel;
@property (nonatomic, weak) IBOutlet UIImageView *couponBgImageView;
@end

@implementation XLTHomeScrollGoodsItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFDF5F2];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 8.0;
    self.contentView.layer.borderColor = [[UIColor colorWithHex:0xFFFF8202] colorWithAlphaComponent:0.32].CGColor;
    self.contentView.layer.borderWidth = 1.5;
}

- (void)letaoUpdateInfo:(NSDictionary *)itemInfo {
    NSNumber *earnAmount = nil;
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    NSString *picUrlString = nil;
    
    NSString *letaosourceLabeltring = nil;
    NSString *letaoStoreNameLabelString = nil;
    NSNumber *paidNumber = nil;
    NSString *letaoGoodsTitleLabelString = nil;
    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        price = itemInfo[@"item_price"];
        letaosourceLabeltring = [XLTGoodsDisplayHelp letaoSourceTextForType:itemInfo[@"item_source"]];
        paidNumber = itemInfo[@"item_sell_count"];
        letaoStoreNameLabelString = itemInfo[@"seller_shop_name"];
        letaoGoodsTitleLabelString = itemInfo[@"item_title"];
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
        picUrlString = itemInfo[@"item_image"];
    }
    
    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.couponLabel.hidden = !isCouponValid;
    self.couponBgImageView.hidden = self.couponLabel.hidden;
    if (isCouponValid) {
        self.couponLabel.text = [NSString stringWithFormat:@"优惠券%@",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    }
    
    
    self.priceInfoLabel.attributedText = [self formatterPrice:price isCouponValid:isCouponValid];
    self.earnInfoLabel.attributedText = [self formatterEarnAmount:earnAmount price:price originalPrice:originalPrice];
        
    if ([picUrlString isKindOfClass:[NSString class]]) {
        NSString *picUrl = [picUrlString letaoConvertToHttpsUrl];
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
        UIImage *picImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
        if ([picImage isKindOfClass:[UIImage class]]) {
            self.goodsImageView.image = picImage;
            // 直接设置有webp会有bug，需要重新设置
            [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        } else {
            [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        }
    } else {
        self.goodsImageView.image = nil;
    }
    
    

}

- (NSAttributedString *)formatterPrice:(NSNumber *)price isCouponValid:(BOOL)isCouponValid {
    NSString *priceText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:price];
    if (isCouponValid) {
        NSString *couponText = @"券后 ";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",couponText,priceText]];
        NSRange couponRang = [attributedString.string rangeOfString:couponText];
        NSRange priceRang = [attributedString.string rangeOfString:priceText];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12.0],
                                          NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]
        } range:couponRang];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12.0],
                                          NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFFE3B3B]
        } range:priceRang];
        return attributedString;

    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12.0],
                                               NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFFE3B3B]
        } range:NSMakeRange(0, priceText.length)];
        return attributedString;

    }
}

- (BOOL)letaoIsOriginalPrice:(NSNumber *)originalPrice
            sameToPrice:(NSNumber *)price {
    return ([originalPrice isKindOfClass:[NSNumber class]]
    && [price isKindOfClass:[NSNumber class]]
    && ([originalPrice integerValue] == [price integerValue]));
}

- (NSAttributedString *)formatterEarnAmount:(NSNumber *)earnAmount price:(NSNumber *)price originalPrice:(NSNumber *)originalPrice {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if ([earnAmount isKindOfClass:[NSNumber class]] && [earnAmount integerValue] > 0) {
        NSMutableAttributedString *earnAmountAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"返%@ ",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount]]];
        [earnAmountAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11.0],
                                          NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]
        } range:NSMakeRange(0, earnAmountAttributedString.length)];
        [earnAmountAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFFE3B3B]
        } range:NSMakeRange(0, earnAmountAttributedString.length)];
        
        [attributedString appendAttributedString:earnAmountAttributedString];
    }

    if (![self letaoIsOriginalPrice:originalPrice sameToPrice:price]) {
        NSMutableAttributedString *originalPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:originalPrice]]];
        [originalPriceAttributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:10.0],
                                          NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFBCBCBC],
                                                       NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
        } range:NSMakeRange(0, originalPriceAttributedString.length)];
        
        [attributedString appendAttributedString:originalPriceAttributedString];
    }
    return attributedString;
}

@end
