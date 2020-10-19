//
//  XLTHomeCategoryGoodsCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCategoryGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "UIView+Extension.h"

@interface XLTHomeCategoryGoodsCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIView *letaoCouponSpace;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoStoreNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsImageFlagLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaoPaidCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;

@end

@implementation XLTHomeCategoryGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.letaoearnLabel.layer.masksToBounds = YES;
    self.letaoearnLabel.layer.cornerRadius = 2.0;
    self.letaoearnLabel.layer.borderColor = self.letaoearnLabel.textColor.CGColor;
    self.letaoearnLabel.layer.borderWidth = 1.0;
    
    
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;

    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
    
    [self.letaoGoodsImageFlagLabel addRoundedCorners:UIRectCornerBottomRight|UIRectCornerTopLeft withRadii:CGSizeMake(5.0, 5.0)];
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
        price = itemInfo[@"item_price"];
        originalPrice = itemInfo[@"item_min_price"];
        if (![originalPrice isKindOfClass:[NSNumber class]]) {
            originalPrice = itemInfo[@"item_price"];
        }
        if (![originalPrice isKindOfClass:[NSNumber class]]
            || [originalPrice intValue] == 0) {
            originalPrice = price;
        }
        postageState = itemInfo[@"item_delivery_postage"];

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
    self.letaoStoreNameLabel.text = letaoStoreNameLabelString;
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
            self.letaoStoreNameLabel.text = nil;
       }
    if (![paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber integerValue] < 1) {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"%@人付款",@"0"];
    } else {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"%@人付款",[paidNumber letaoTenThousandNumberFormat]];
    }
    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;
    
    if (self.letaoShowImageFlag) {
        self.letaoGoodsImageFlagLabel.hidden = !([postageState isKindOfClass:[NSNumber class]] && [postageState intValue] == 0);
    } else {
        self.letaoGoodsImageFlagLabel.hidden = YES;
    }
    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:self.letaoearnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.letaoearnLabel.text = [NSString stringWithFormat:@" %@ ",self.letaoearnLabel.text];
    
    self.letaopriceLabel.text = [NSString stringWithFormat:@"%@  ",self.letaopriceLabel.text];
    
    NSString *couponAmountText = [NSString stringWithFormat:@" %@元券 ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    self.letaoCouponSpace.hidden = self.letaocouponAmountButton.hidden;
}



@end
