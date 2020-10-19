//
//  XLDGoodsInfoPriceCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsInfoPriceCell.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTGoodsDisplayHelp.h"
#import "SDCycleScrollView.h"
#import "XLTUIConstant.h"
#import "MBProgressHUD+TipView.h"
#import "XLDGoodsEarnCollectionViewCell.h"
#import "UIImage+WebP.h"

@interface XLDGoodsInfoPriceCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoEarnLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaoEarnbgImageView;
@property (nonatomic, weak) IBOutlet XLDGoodsEarnQuestionButton *questionButton;

@property (nonatomic, weak) IBOutlet UIImageView *flagImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *flagImageViewWidth;


@property (nonatomic, weak) IBOutlet UIView *memberUpgradeView;
@property (nonatomic, weak) IBOutlet UIImageView *diamondImageView;
@property (nonatomic, weak) IBOutlet UIButton *memberUpgradeButton;
@property (nonatomic, weak) IBOutlet UILabel *memberUpgradeLabel;

@end

@implementation XLDGoodsInfoPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

    //
    UILabel *letaoUpdateEarnLabel = [UILabel new];
    UILabel *letaopricePrefixLabel = [UILabel new];
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:letaoUpdateEarnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice originalPricePrefixText:@"原价￥" letaopricePrefixLabel:letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:nil couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];
    NSString *priceText = self.letaopriceLabel.text;
    NSString *prefixText = letaopricePrefixLabel.text;

    // 价格信息
    self.letaopriceLabel.text = nil;
    self.letaopriceLabel.attributedText = [self formatterPriceText:priceText prefixText:prefixText];
    // 返利信息
    NSDictionary *earnAmounInfo = [self buildEarnAmounInfo:itemInfo];
    [self letaoUpdateCellEarnDataWithInfo:earnAmounInfo];
    
    // 标记
    if ([self isLetaoHighCommissionGoods:itemInfo]) { // 高佣
        self.flagImageView.hidden = NO;
        self.flagImageViewWidth.constant = 36;
        self.flagImageView.image = [UIImage imageNamed:@"gooddetail_highcommission_flag"];
    } else if ([self isLetaoPrePaidGoods:itemInfo]) { // 预付定金
        self.flagImageView.hidden = NO;
        self.flagImageViewWidth.constant = 36;
        self.flagImageView.image = [UIImage imageNamed:@"gooddetail_prepaid_flag"];
    } else if ([self isLetaopreCoupoGoods:itemInfo]) { // 预告
        self.flagImageView.hidden = NO;
        self.flagImageViewWidth.constant = 36;
        self.flagImageView.image = [UIImage imageNamed:@"gooddetail_pre_flag"];
    } else {
        self.flagImageView.hidden = NO;
        self.flagImageViewWidth.constant = 0;
    }
    
    
    // 会员
    
    NSDictionary *next_level = itemInfo[@"next_level"];
    if ([XLTAppPlatformManager shareManager].checkEnable
        && [next_level isKindOfClass:[NSDictionary class]] && next_level.count > 0) {
        [self letaoUpdaterUpgradeDataWithInfo:next_level];
        self.memberUpgradeView.hidden = NO;
        self.diamondImageView.hidden = NO;
    } else {
        self.memberUpgradeView.hidden = YES;
        self.diamondImageView.hidden = YES;
    }
}

- (NSDictionary * _Nullable)buildEarnAmounInfo:(NSDictionary *)goodInfo {
    if ([goodInfo isKindOfClass:[NSDictionary class]]) {
        // 返利
         NSNumber *earnAmount = nil;
         NSNumber *letaocommission = nil;
         NSNumber *letaosubsidy = nil;
         BOOL isEarnAmountValid = NO;
         NSNumber *doubleEarnAmount = nil;
         BOOL isDoubleEarnAmountValid = NO;
          //        fix_rebate_amount ，double_rebate
         NSDictionary *rebate = goodInfo[@"rebate"];
         if ([rebate isKindOfClass:[NSDictionary class]]) {
             earnAmount = rebate[@"xkd_amount"];
             letaocommission = rebate[@"xlt_commission"];
             letaosubsidy = rebate[@"xlt_subsidy"];
             
             if ([earnAmount isKindOfClass:[NSNumber class]] && [earnAmount integerValue] > 0) {
                 isEarnAmountValid = YES;
             }
         }
         if (isEarnAmountValid) {
             NSNumber *double_rebate = goodInfo[@"double_rebate"];
             NSNumber *fix_rebate_amount = goodInfo[@"fix_rebate_amount"];
             if ([double_rebate isKindOfClass:[NSNumber class]] && [double_rebate boolValue]) {
                 isDoubleEarnAmountValid = YES;
                 doubleEarnAmount = [NSNumber numberWithInteger:2*[earnAmount integerValue]];
                
             } else if ([fix_rebate_amount isKindOfClass:[NSNumber class]] && [fix_rebate_amount integerValue] > 0) {
                 isDoubleEarnAmountValid = YES;
                 doubleEarnAmount = [NSNumber numberWithInteger:[fix_rebate_amount intValue] + [earnAmount intValue]];
                 
             }
         }
                  
         NSNumber *jd_plus = goodInfo[@"jd_plus"];
         if (isEarnAmountValid) {
             NSMutableDictionary *earnAmounInfo = @{@"xkd_amount":earnAmount}.mutableCopy;
             earnAmounInfo[@"item_source"] = goodInfo[@"item_source"];
             NSArray *flag = goodInfo[@"flag"];
             if ([flag isKindOfClass:[NSArray class]]) {
                 __block BOOL jd_self = NO;
                 [flag enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                         if ([obj intValue] == 4) {
                             jd_self = YES;
                             *stop = YES;
                         }
                     }
                 }];
                 earnAmounInfo[@"jd_self"] = [NSNumber numberWithBool:jd_self];
                 earnAmounInfo[@"jd_plus"] = jd_plus;;
             }
             // 不在支持双被返利
//             if (isDoubleEarnAmountValid) {
//                 [earnAmounInfo setObject:doubleEarnAmount forKey:@"double_rebate"];
//             }
             return earnAmounInfo;
         }
    }
    return nil;;
}

- (void)letaoUpdateCellEarnDataWithInfo:(NSDictionary * )earnAmounInfo {
    self.letaoEarnLabel.text = nil;
    if ([earnAmounInfo isKindOfClass:[NSDictionary class]]) {
        NSNumber *earnAmount = earnAmounInfo[@"xkd_amount"];
//        NSString *item_source = earnAmounInfo[@"item_source"];
        NSMutableAttributedString *earnAmountText = [self letaoFormattingEarnAmountt:earnAmount];
        NSNumber *jd_self = earnAmounInfo[@"jd_self"];
        NSNumber *jd_plus = earnAmounInfo[@"jd_plus"];
        if ([jd_self isKindOfClass:[NSNumber class]] && jd_self.boolValue) {
            NSString *plus = nil;
            if (![jd_plus isKindOfClass:[NSNumber class]]) {
                plus = @"\n(Plus会员返利金低于此)";
            } else {
                plus = [NSString stringWithFormat:@"\n(Plus￥%@)",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:jd_plus]];
            }

            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.maximumLineHeight = 12;
            paragraphStyle.minimumLineHeight = 12;
            paragraphStyle.lineSpacing = 1;
    
            NSAttributedString *plusAttributedString  = [[NSAttributedString alloc] initWithString:plus attributes:@{NSFontAttributeName:[UIFont letaoRegularFontWithSize:11.0],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:paragraphStyle}];
            [earnAmountText appendAttributedString:plusAttributedString];
        }
        
        self.letaoEarnLabel.attributedText = earnAmountText;
        self.letaoEarnLabel.hidden = NO;
        self.letaoEarnbgImageView.hidden = self.letaoEarnLabel.hidden;
        self.questionButton.hidden = self.letaoEarnLabel.hidden;
    } else {
        // 没有返利信息
        self.letaoEarnLabel.hidden = YES;
        self.letaoEarnbgImageView.hidden = self.letaoEarnLabel.hidden;
        self.questionButton.hidden = self.letaoEarnLabel.hidden;
    }

}

- (NSMutableAttributedString *)letaoFormattingEarnAmountt:(NSNumber *)earnAmount {
    NSString *amountText = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"返￥%@",amountText]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:15.0],
                                      NSForegroundColorAttributeName:[UIColor whiteColor]
    } range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0]} range:NSMakeRange(0, 1)];

    return attributedString;
}

- (NSAttributedString *)formatterPriceText:(NSString *)priceText prefixText:(NSString *)prefixText {
    NSString *priceUnit = @"￥";
    if (![priceText isKindOfClass:[NSString class]]) {
        priceText = @"";
    }
    if (![prefixText isKindOfClass:[NSString class]]) {
        prefixText = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",prefixText,priceUnit,priceText]];
    
    NSRange priceUnitRange = [attributedString.string rangeOfString:priceUnit];
    if (priceUnitRange.length) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264],
                                          NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:14.0]
        } range:priceUnitRange];
    }
    
    NSRange priceTextRange = [attributedString.string rangeOfString:priceText];
    if (priceTextRange.length) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264],
                                          NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:21.0]
        } range:priceTextRange];
        
        NSArray *array = [attributedString.string componentsSeparatedByString:@"."];
        if (array.count > 1) {
            NSString *decimal = [NSString stringWithFormat:@".%@",array.lastObject];
            NSRange decimalRange = [attributedString.string rangeOfString:decimal];
            if (decimalRange.length) {
                 [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264],
                                                   NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:16.0]
                 } range:decimalRange];
            }
        }
    }
    
    if (prefixText.length) {
        NSRange prefixTextRange = [attributedString.string rangeOfString:prefixText];
        if (prefixTextRange.length) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264],
                                              NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12.0]
            } range:prefixTextRange];
        }
    }
    return attributedString;
}


// 预告
- (BOOL)isLetaopreCoupoGoods:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *coupon = info[@"coupon"];
        if ([coupon isKindOfClass:[NSDictionary class]]) {
            NSNumber *couponAmount = nil;
            NSNumber *couponStartTime = nil;
            NSNumber *couponEndTime = nil;
            couponAmount = coupon[@"amount"];
            couponStartTime = [coupon[@"start_time"] isKindOfClass:[NSNumber class]] ? coupon[@"start_time"] :@0;
            couponEndTime = [coupon[@"end_time"] isKindOfClass:[NSNumber class]] ? coupon[@"end_time"] :@0;
            BOOL preCouponFlag = ([[NSDate dateWithTimeIntervalSince1970:[couponStartTime longLongValue]] isInFuture] && ([couponAmount isKindOfClass:[NSNumber class]]
               && ([couponAmount integerValue] >0)));
            return preCouponFlag;
        }
    }
    
    return NO;
}

// 高佣
- (BOOL)isLetaoHighCommissionGoods:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSNumber *hight_rebate = info[@"hight_rebate"];
        if ([hight_rebate isKindOfClass:[NSString class]] || [hight_rebate isKindOfClass:[NSNumber class]]) {
            return [hight_rebate boolValue];
        }
    }
    
    return NO;
}

// 预付定金
- (BOOL)isLetaoPrePaidGoods:(NSDictionary *)goodInfo {
    if (![self isLetaoHighCommissionGoods:goodInfo]) {
        if ([goodInfo isKindOfClass:[NSDictionary class]]) {
            // 定金预售
            NSDictionary *presale = goodInfo[@"presale"];
            if ([presale isKindOfClass:[NSDictionary class]] && presale.count > 0) {
                NSNumber *start_time = presale[@"start_time"];
                NSNumber *end_time = presale[@"end_time"];
                NSNumber *tail_start_time = presale[@"tail_start_time"];
                NSNumber *tail_end_time = presale[@"tail_end_time"];
                if ([start_time isKindOfClass:[NSNumber class]] && [start_time longLongValue] > 0
                    && [end_time isKindOfClass:[NSNumber class]] && [end_time longLongValue] > 0
                    && [tail_start_time isKindOfClass:[NSNumber class]] && [tail_start_time longLongValue] > 0
                    && [tail_end_time isKindOfClass:[NSNumber class]] && [tail_end_time longLongValue] > 0) {
                    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
                    return (timeInterval > [start_time longLongValue] && timeInterval < [end_time longLongValue]);
                }
            }
        }
    }
    return NO;
}

- (IBAction)letaoQuestionButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoIsQuestionButtonClicked)]) {
        [self.delegate letaoIsQuestionButtonClicked];
    }

}

#pragma mark -  会员

- (IBAction)upgradeBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(memberUpgradeCell:upgradeBtnClicked:)]) {
        [self.delegate memberUpgradeCell:sender upgradeBtnClicked:sender];
    }
}

- (void)letaoUpdaterUpgradeDataWithInfo:(NSDictionary *)itemInfo {
    NSString *level_txt = nil;
    NSNumber *xkd_amount = nil;
    // level:4黑色 其他金色
    NSNumber *level = nil;
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        if ([itemInfo[@"level_txt"] isKindOfClass:[NSString class]]) {
            level_txt = itemInfo[@"level_txt"];
        }
        
        if ([itemInfo[@"level"] isKindOfClass:[NSNumber class]]) {
            level = itemInfo[@"level"];
        }
        NSDictionary *rebate = itemInfo[@"rebate"];
        if ([rebate isKindOfClass:[NSDictionary class]]) {
            if ([rebate[@"xkd_amount"] isKindOfClass:[NSNumber class]]) {
                xkd_amount = rebate[@"xkd_amount"];
            }
        }
    }

    UIImage *gradientImage = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFF312F2B],[UIColor blackColor]] gradientType:1 imgSize:CGSizeMake(kScreenWidth - 20, 28)];
    [self.memberUpgradeButton setBackgroundImage:gradientImage forState:UIControlStateNormal];
    NSString *amount = [NSString stringWithFormat:@"￥%@",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:xkd_amount]];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成为运营总监, 下单最高可返利%@",amount]];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFE07100],
                                      NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:13.0]
    } range:NSMakeRange(0, attributedString.length)];
    
    NSRange amountRange = [attributedString.string rangeOfString:amount];
    if (amountRange.length) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFF34264],
                                          NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:13.0]
        } range:amountRange];
    }
    self.memberUpgradeLabel.attributedText = attributedString;
    
    NSString *file =  [[NSBundle mainBundle] pathForResource:@"member_diamond" ofType:@"webp"];
    UIImage *diamondImage = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:file]];
    self.diamondImageView.image = diamondImage;
}
@end
