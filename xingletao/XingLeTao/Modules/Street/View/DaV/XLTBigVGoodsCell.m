//
//  XLTHomeGoodsCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBigVGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "XLTGoodsDisplayHelp.h"
#import "UIColor+XLTColorConstant.h"
#import "XLTUIConstant.h"
#import "NSNumber+XLTTenThousandsHelp.h"
#import "UIImage+UIColor.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTBigVGoodsCell ()

@property (nonatomic, weak) IBOutlet UILabel *letaoearnLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaooriginalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopricePrefixLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaopriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *letaocouponAmountButton;
@property (nonatomic, weak) IBOutlet UIView *letaoCouponSpace;

@property (nonatomic, weak) IBOutlet UILabel *letaosourceLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoStoreNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *letaogoodsImageView;
@property (nonatomic, weak) IBOutlet UILabel *salesAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoBuyLabel;
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsImageFlagLabel;
@property (nonatomic, strong) UIImageView *letaobgImageView;
@property (nonatomic, assign) BOOL lastCell;
@property (nonatomic, weak) IBOutlet UIButton *letaoMoreBtn;

@end
@implementation XLTBigVGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.letaoearnLabel.layer.masksToBounds = YES;
    self.letaoearnLabel.layer.cornerRadius = 2.0;
    self.letaoearnLabel.layer.borderColor = self.letaoearnLabel.textColor.CGColor;
    self.letaoearnLabel.layer.borderWidth = 1.0;
    
    
    self.letaoBuyLabel.layer.masksToBounds = YES;
    self.letaoBuyLabel.layer.cornerRadius = 5.0;
    
    
    self.letaosourceLabel.layer.masksToBounds = YES;
    self.letaosourceLabel.layer.cornerRadius = ceilf(self.letaosourceLabel.bounds.size.height/2);
    self.letaosourceLabel.layer.borderColor = [UIColor letaomainColorSkinColor].CGColor;
    self.letaosourceLabel.layer.borderWidth = 1.0;
    
    
    self.letaogoodsImageView.layer.masksToBounds = YES;
    self.letaogoodsImageView.layer.cornerRadius = 5.0;
    
    UIImageView *letaobgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView insertSubview:letaobgImageView atIndex:0];
    self.letaobgImageView = letaobgImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.letaobgImageView.frame = self.bounds;
    UIImage *bgImage = [UIImage letaoimageWithColor:[UIColor whiteColor]];
    if (self.lastCell) {
        //圆角
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
                  [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)] addClip];
        [bgImage drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
                  UIGraphicsEndImageContext();
        self.letaobgImageView.image = roundedImage;
    } else {
        self.letaobgImageView.image = bgImage;
    }
}

- (IBAction)letaoMoreBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoMoreBtnClicked:)]) {
        [self.delegate letaoMoreBtnClicked:self];
    }
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo isLastCell:(BOOL)lastCell {
    self.lastCell = lastCell;
    [self letaoUpdateCellDataWithInfo:itemInfo];
    self.letaoMoreBtn.hidden = !self.lastCell;
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
    self.letaoStoreNameLabel.text = letaoStoreNameLabelString;
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
            self.letaoStoreNameLabel.text = nil;
       }
    if (![paidNumber isKindOfClass:[NSNumber class]]
        || [paidNumber integerValue] < 1) {
        self.salesAmountLabel.text = [NSString stringWithFormat:@"%@人付款",@"0"];
    } else {
        self.salesAmountLabel.text = [NSString stringWithFormat:@"%@人付款",[paidNumber letaoTenThousandNumberFormat]];
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
    [XLTGoodsDisplayHelp letaoUpdateEarnLabel:self.letaoearnLabel earnAmount:earnAmount letaooriginalPriceLabel:self.letaooriginalPriceLabel originalPrice:originalPrice letaopricePrefixLabel:self.letaopricePrefixLabel letaopriceLabel:self.letaopriceLabel price:price letaocouponAmountButton:self.letaocouponAmountButton couponAmount:couponAmount couponStartTime:[couponStartTime longLongValue] couponEndTime:[couponEndTime longLongValue]];

    self.letaoearnLabel.text = [NSString stringWithFormat:@" %@ ",self.letaoearnLabel.text];
    
    self.letaopriceLabel.text = [NSString stringWithFormat:@"%@  ",self.letaopriceLabel.text];
    
    self.letaoCouponSpace.hidden = self.letaocouponAmountButton.hidden;
}

@end
