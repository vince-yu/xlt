//
//  XLTHomeCouponGoodsCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCouponGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "UIImage+UIColor.h"

@interface XLTHomeCouponGoodsCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsImageFlagLabel;

@property (nonatomic, weak) IBOutlet UIButton *letaoBuyBtn;
@property (nonatomic, weak) IBOutlet UILabel *couponAmountLabel;

@end


@implementation XLTHomeCouponGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.letaoBuyBtn.layer.masksToBounds = YES;
    self.letaoBuyBtn.layer.cornerRadius = 12.5;
    
    
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;
    [self.letaoBuyBtn setBackgroundImage:[UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:self.letaoBuyBtn.bounds.size] forState:UIControlStateNormal];
    
    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
}



- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
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
    
    NSNumber *postageState = nil;

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];
        postageState = itemInfo[@"item_delivery_postage"];

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
    
    if (letaosourceLabeltring == nil) {
        self.letaosourceLabel.hidden = YES;
    } else {
        self.letaosourceLabel.hidden = NO;
        self.letaosourceLabel.text = [NSString stringWithFormat:@"  %@  ",letaosourceLabeltring];
    }
    
    if (![letaoStoreNameLabelString isKindOfClass:[NSString class]]) {
        letaoStoreNameLabelString = nil;
    }
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    } else {
        NSString *spaceString = @"        ";
        NSInteger len = letaosourceLabeltring.length;
        while (len > 2) {
            spaceString = [spaceString stringByAppendingString:@"  "];
            len--;
        }
        letaoGoodsTitleLabelString = [spaceString  stringByAppendingFormat:@"%@", letaoGoodsTitleLabelString];
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    
    self.letaoGoodsImageFlagLabel.hidden = !([postageState isKindOfClass:[NSNumber class]] && [postageState intValue] == 0);

    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:nil earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice originalPricePrefixText:@" "  letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:nil couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    NSString *couponAmountText = [NSString stringWithFormat:@"%@ ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    BOOL shouldDisplayCoupon =  [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    
    
    if (!shouldDisplayCoupon) {
        couponAmountText = @"0";
    }
    self.couponAmountLabel.text = couponAmountText;

}
@end
