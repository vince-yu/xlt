//
//  XLTShareFeedGoodsCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareFeedGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "UIImage+UIColor.h"
#import "UIView+Extension.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTShareFeedGoodsCell ()
@property (nonatomic, weak) IBOutlet UIButton *couponPriceButton;
@property (nonatomic, weak) IBOutlet UIView *letaoCouponSpace;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;

@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *salesAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *shareEarnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsImageFlagLabel;
@end


@implementation XLTShareFeedGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaocouponAmountButton.layer.masksToBounds = YES;
    self.letaocouponAmountButton.layer.cornerRadius = 2;
    self.letaocouponAmountButton.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaocouponAmountButton.layer.borderWidth = 0.5;
    [self.letaocouponAmountButton setBackgroundImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFFFF9F2]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)letaoUpdateCellGoodsInfo:(id _Nullable )goodsInfo otherDataInfo:(NSDictionary *)itemInfo {
    NSString *flag_txt = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        flag_txt = itemInfo[@"flag_txt"];
    }
    [self letaoUpdateCellGoodsInfo:goodsInfo];
    
    if ([flag_txt isKindOfClass:[NSString class]] && flag_txt.length > 0) {
        self.letaoGoodsImageFlagLabel.hidden = NO;
        self.letaoGoodsImageFlagLabel.text = [NSString stringWithFormat:@" %@ ",flag_txt];
        [self.letaoGoodsImageFlagLabel setNeedsLayout];
        [self.letaoGoodsImageFlagLabel layoutIfNeeded];
        [self.letaoGoodsImageFlagLabel addRoundedCorners:UIRectCornerTopLeft|UIRectCornerBottomRight withRadii:CGSizeMake(5.0, 5.0)];

    } else {
        self.letaoGoodsImageFlagLabel.hidden = YES;
    }
}


- (void)letaoUpdateCellGoodsInfo:(id _Nullable )itemInfo {
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
   
    NSNumber *status = nil;

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        status = itemInfo[@"status"];

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
    if ([picUrlString isKindOfClass:[NSString class]]) {
        [self.letaogoodsImageView sd_setImageWithURL:[NSURL URLWithString:[picUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    } else {
        [self.letaogoodsImageView setImage:kPlaceholderSmallImage];
    }
    

    
    
    if (![paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber integerValue] < 1) {
        self.salesAmountLabel.text = [NSString stringWithFormat:@"%@人购买",@"0"];
    } else {
        self.salesAmountLabel.text = [NSString stringWithFormat:@"%@人购买",[paidNumber letaoTenThousandNumberFormat]];
    }
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    
//    BOOL isCouponValid = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
//    NSString *item_source = itemInfo[@"item_source"];
//    BOOL isWPHSource = ([item_source isKindOfClass:[NSString class]] && [item_source isEqualToString:XLTVPHPlatformIndicate]);
//    self.letaoGoodsImageFlagLabel.hidden = isCouponValid || isWPHSource;

    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:nil earnAmount:earnAmount letaooriginalPriceLabel:nil originalPrice:originalPrice letaopricePrefixLabel:nil letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    
    NSString *couponAmountText = [NSString stringWithFormat:@"  优惠券:￥%@  ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    self.letaopriceLabel.text = [NSString stringWithFormat:@"￥%@",self.letaopriceLabel.text];
    
    [self.couponPriceButton setTitle:[NSString stringWithFormat:@"  券后价:%@  ",self.letaopriceLabel.text] forState:UIControlStateNormal];

    self.letaoCouponSpace.hidden = self.letaocouponAmountButton.hidden;
    self.couponPriceButton.hidden = self.letaocouponAmountButton.hidden;
    self.letaopriceLabel.hidden = !self.letaocouponAmountButton.hidden;
    
    self.shareEarnLabel.text = nil;
    self.shareEarnLabel.attributedText =  [self formattingEarnAmountt:earnAmount];
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
        self.shareEarnLabel.hidden = YES;
    }
}

- (NSMutableAttributedString *)formattingEarnAmountt:(NSNumber *)earnAmount {
    BOOL canshow = [XLTAppPlatformManager shareManager].checkEnable;
    if (canshow
        && [earnAmount isKindOfClass:[NSNumber class]] && earnAmount.intValue > 0) {
        NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"分享赚￥%@",amountText]];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF25282D]} range:NSMakeRange(0, 3)];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16],NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264]} range:NSMakeRange(attributedString.length -amountText.length-1, amountText.length+1)];

        return attributedString;
    } else {
        return nil;
    }

}


@end
