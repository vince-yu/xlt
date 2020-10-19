//
//  XLTCelebrityStoreGoodsCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCelebrityStoreGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTCelebrityStoreGoodsCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;

@end

@implementation XLTCelebrityStoreGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
    
    self.letaoearnLabel.layer.masksToBounds = YES;
    self.letaoearnLabel.layer.cornerRadius = 2.0;
    self.letaoearnLabel.layer.borderColor = self.letaoearnLabel.textColor.CGColor;
    self.letaoearnLabel.layer.borderWidth = 1.0;
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary * )itemInfo {
    NSNumber *earnAmount = nil;
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;
    NSString *picUrlString = nil;
    

    
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            earnAmount = rebate[@"xkd_amount"];
        }
        originalPrice = itemInfo[@"item_min_price"];

        price = itemInfo[@"item_price"];
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
    
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:self.letaoearnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice originalPricePrefixText:@"￥" letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    // 11 是占位的 暂时这么处理
    self.letaoearnLabel.text = nil;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1返￥%@1",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount]]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(attributedString.length -1, 1)];
    self.letaoearnLabel.attributedText = attributedString;
    
}
@end
