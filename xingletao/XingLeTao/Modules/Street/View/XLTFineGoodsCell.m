//
//  XLTFineGoodsCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTFineGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTFineGoodsCell ()
@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIView *letaoCouponSpace;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoStoreNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *letaoPaidCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsFlagLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaodescribeLabel;
@property (nonatomic, weak) IBOutlet UIView *describeSeparatorView;

@end
@implementation XLTFineGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.letaoearnLabel.layer.masksToBounds = YES;
    self.letaoearnLabel.layer.cornerRadius = 2.0;
    self.letaoearnLabel.layer.borderColor = self.letaoearnLabel.textColor.CGColor;
    self.letaoearnLabel.layer.borderWidth = 1.0;
//    175
    
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;

    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    
    self.letaoGoodsFlagLabel.layer.masksToBounds = YES;
    self.letaoGoodsFlagLabel.layer.cornerRadius = ceilf(self.letaoGoodsFlagLabel.bounds.size.height/2);
    
    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
}

/*
    "_id": "77ce9e2ae8df0d86e9698fa35e16574f",
    "item_id": "43710330869",
    "item_source": "D",
    "item_title": "百草味 纸皮核桃袋装 坚果薄皮核桃原味大仁干果新疆特产 家庭装（1000g）",
    "item_sell_count": 837,
    "item_price": 3890,
    "item_min_price": 5990,
    "seller_shop_id": "17153",
    "item_delivery_postage": 0,
    "status": 1,
    "item_image": "http://img14.360buyimg.com/ads/jfs/t1/64029/38/7391/277850/5d569135E2046a417/3d1d44cb0367aedc.jpg",
    "rebate": {
        "xkd_rate": 8800,
        "xkd_amount": 684
    },
    "coupon": {
        "start_time": 1569254400,
        "end_time": 1569686399,
        "start_fee": 5500,
        "amount": 2100,
        "rate": 3505
    },
    "sort": 93486,
    "seller_shop_name": "百草味品牌旗舰店"
*/




- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    NSDictionary *goodsInfo = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        goodsInfo = itemInfo[@"good_info"];
    }
    [self updateCellGoodsData:goodsInfo];
    
     
     NSString *recommend_content = itemInfo[@"recommend_content"];
     if ([recommend_content isKindOfClass:[NSString class]] && recommend_content.length > 0) {
         self.letaodescribeLabel.text = recommend_content;
         self.describeSeparatorView.hidden = NO;
     } else {
         self.letaodescribeLabel.text = nil;
         self.describeSeparatorView.hidden = YES;
     }
}

- (void)updateCellGoodsData:(id _Nullable )itemInfo {
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
    
    
    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:self.letaoearnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.letaoearnLabel.text = [NSString stringWithFormat:@" %@ ",self.letaoearnLabel.text];
    
    self.letaopriceLabel.text = [NSString stringWithFormat:@"%@  ",self.letaopriceLabel.text];
    
    NSString *couponAmountText = [NSString stringWithFormat:@" %@元券 ",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
    [self.letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
    self.letaoCouponSpace.hidden = self.letaocouponAmountButton.hidden;
 
}


@end
