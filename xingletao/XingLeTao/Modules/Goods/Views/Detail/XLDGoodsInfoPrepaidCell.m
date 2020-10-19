//
//  XLDGoodsInfoCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsInfoPrepaidCell.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTGoodsDisplayHelp.h"
#import "SDCycleScrollView.h"
#import "XLTUIConstant.h"
#import "MBProgressHUD+TipView.h"

@interface XLDGoodsInfoPrepaidCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoStoreNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *letaoPaidCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;


@property (nonatomic, weak) IBOutlet UIImageView *preCouponFlagImageView;

@property (nonatomic, weak) IBOutlet UIImageView *prepaidBgImageView;
@property (nonatomic, weak) IBOutlet UILabel *prepaidDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepaidDiscountLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *prepaidDiscountLabelTop;


@end

@implementation XLDGoodsInfoPrepaidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(letaoPressAction)];
    self.letaoGoodsTitleLabel.userInteractionEnabled = YES;
    [self.letaoGoodsTitleLabel addGestureRecognizer:press];
    
    
    UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFA02BF4],[UIColor colorWithHex:0xFF8521F5]] gradientType:1 imgSize:CGSizeMake(kScreenWidth, 60)];
    self.prepaidBgImageView.image = bgImage;
    
}

- (void)letaoPressAction{
    [[XLTAppPlatformManager shareManager] saveGoodsPasteboardValue:self.letaoGoodsTitleLabel.text];
    [UIPasteboard generalPasteboard].string = self.letaoGoodsTitleLabel.text;
    [MBProgressHUD letaoshowTipMessageInWindow:@"商品标题已复制!"];
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo {
    NSNumber *earnAmount = nil;
    NSNumber *originalPrice = nil;
    NSNumber *price = nil;
    NSNumber *couponAmount = nil;
    NSNumber *couponStartTime = nil;
    NSNumber *couponEndTime = nil;

    
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

        NSDictionary *seller = itemInfo[@"seller"];
        if ([seller isKindOfClass:[NSDictionary class]]) {
            letaoStoreNameLabelString = seller[@"seller_shop_name"];
        }
        letaoGoodsTitleLabelString = itemInfo[@"item_title"];
        NSDictionary *coupon = itemInfo[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
        }
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
    if ([paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber isKindOfClass:[NSString class]]) {
        self.letaoPaidCountLabel.text = [NSString stringWithFormat:@"销量 %@",[paidNumber letaoTenThousandNumberFormat]];
    } else {
        self.letaoPaidCountLabel.text = nil;
    }

    
    
    if (![letaoGoodsTitleLabelString isKindOfClass:[NSString class]]) {
        letaoGoodsTitleLabelString = nil;
    }
    self.letaoGoodsTitleLabel.text = letaoGoodsTitleLabelString;

    //
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:[UILabel new] earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice originalPricePrefixText:@" 原价￥" letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:nil couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    NSString *letaopriceLabelText  = self.letaopriceLabel.text;
    if (letaopriceLabelText != nil) {
        self.letaopriceLabel.text = nil;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ ",letaopriceLabelText]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:14.0] range:NSMakeRange(0, 1)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:23.0] range:NSMakeRange(1, attributedString.length -1-3)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont letaoMediumBoldFontWithSize:14.0] range:NSMakeRange(attributedString.length -1-3, 3)];
        self.letaopriceLabel.attributedText = attributedString;
    }
    else {
        self.letaopriceLabel.attributedText = nil;
    }
    
    self.preCouponFlagImageView.hidden = YES;

    CGFloat prepaidDiscountLabelTop = 63;
    
    if ([self isPrepaidDateValid:itemInfo]) {
        self.prepaidDateLabel.hidden =  NO;
        self.prepaidDateLabel.text = [self prepaidDateLabelText:itemInfo];
        self.prepaidDiscountLabelTop.constant = 39;
    } else {
        self.prepaidDateLabel.hidden =  YES;
        self.prepaidDiscountLabelTop.constant = 15;
        prepaidDiscountLabelTop -= (9 +15);
    }
    
    if ([self isPrepaidDiscountValid:itemInfo]) {
        self.prepaidDiscountLabel.hidden = NO;
        self.prepaidDiscountLabel.text = [self prepaidDiscountText:itemInfo];
    } else {
        self.prepaidDiscountLabel.hidden = YES;
        prepaidDiscountLabelTop -= (15+ 21);
    }
    self.titleLabelTop.constant = prepaidDiscountLabelTop;
//    self.prepaidDiscountLabel.text = @"xxxx";
}

- (BOOL)isPrepaidDateValid:(NSDictionary *)itemInfo {
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = itemInfo;
        // 定金预售
        NSDictionary *presale = goodInfo[@"presale"];
        if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
            NSNumber *start_time = presale[@"tail_start_time"];
            NSNumber *end_time = presale[@"tail_end_time"];
            return ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                    && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0);
        }
    }
    return NO;
}

- (NSString * _Nullable)prepaidDiscountText:(NSDictionary *)itemInfo  {
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = itemInfo;
        // 定金预售
        NSDictionary *presale = goodInfo[@"presale"];
        if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
            NSString *discount_fee_text = presale[@"discount_fee_text"];
            if([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0) {
                return [NSString stringWithFormat:@" %@ ",discount_fee_text];
            }
        }
    }
    return nil;
}


- (NSString * _Nullable)prepaidDateLabelText:(NSDictionary *)itemInfo  {
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *goodInfo = itemInfo;
        // 定金预售
        NSDictionary *presale = goodInfo[@"presale"];
        if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
            NSNumber *start_time = presale[@"tail_start_time"];
            NSNumber *end_time = presale[@"tail_end_time"];
            if ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0) {
                return [self tailTextWithStartDate:[NSDate dateWithTimeIntervalSince1970:[start_time longLongValue]] endDate:[NSDate dateWithTimeIntervalSince1970:[end_time longLongValue]]];
            }
        }
    }
    return nil;
}

- (BOOL)isPrepaidDiscountValid:(NSDictionary *)itemInfo {
    NSString *discount_fee_text = [self prepaidDiscountText:itemInfo];
    return ([discount_fee_text isKindOfClass:[NSString class]] && [discount_fee_text length] > 0);
}


- (NSString * _Nullable)tailTextWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    }
    if ([startDate isKindOfClass:[NSDate class]] && [endDate isKindOfClass:[NSDate class]]) {
        NSString *startString = [dateFormatter stringFromDate:startDate];
        NSString *endString = [dateFormatter stringFromDate:endDate];
        return [NSString stringWithFormat:@"支付尾款时间：%@~%@",startString,endString];
    }
    return nil;

}
@end
