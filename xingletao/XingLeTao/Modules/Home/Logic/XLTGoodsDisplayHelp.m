//
//  XLTDisplayDiscountCouponHelp.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDisplayHelp.h"
#import "XLTAppPlatformManager.h"
#import "NSDate+Utilities.h"
#import "UIColor+Helper.h"
#import "XLTHomePageLogic.h"
#import "UIImage+Resize.h"
#import "UIImage+XLTCompress.h"
#import <CommonCrypto/CommonDigest.h>


@interface XLTShareImageItem : UIActivityItemProvider
@property (nonatomic, strong) id qq_placeholderItem;

@end

@implementation XLTShareImageItem

- (nullable id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(nullable UIActivityType)activityType {
    if ([activityType isEqualToString:@"com.tencent.mqq.ShareExtension"]) {
        return self.qq_placeholderItem;
    }  else {
        return self.placeholderItem;
    }
}
@end

//GoodsSource C:淘宝 B:天猫 D:京东  V:唯品会 CZB:团油 S:苏宁
NSString *const XLTTaobaoPlatformIndicate = @"C";
NSString *const XLTTianmaoPlatformIndicate = @"B";
NSString *const XLTJindongPlatformIndicate = @"D";
NSString *const XLTPDDPlatformIndicate = @"P";
NSString *const XLTVPHPlatformIndicate = @"V";
NSString *const XLTCZBPlatformIndicate = @"CZB";
NSString *const XLTSuNingPlatformIndicate = @"S";
@implementation XLTGoodsDisplayHelp
+ (BOOL)letaoShouldShowEarnWithAmount:(NSNumber *)amount {
    if ([amount isKindOfClass:[NSNumber class]] || [amount isKindOfClass:[NSString class]]) {
        return [amount integerValue] > 0;
    }
    return NO;
}


+ (BOOL)letaoShouldShowCouponWithAmount:(NSNumber *)couponAmount
                             couponStartTime:(NSTimeInterval)couponStartTime
                               couponEndTime:(NSTimeInterval)couponEndTime {
    if ([[NSDate dateWithTimeIntervalSince1970:couponEndTime] isInFuture]) {
        return [XLTGoodsDisplayHelp  letaoIsCouponAmountGreaterThanZero:couponAmount];
    }
    return NO;
}

+ (BOOL)letaoIsOriginalPrice:(NSNumber *)originalPrice
            sameToPrice:(NSNumber *)price {
    return ([originalPrice isKindOfClass:[NSNumber class]]
    && [price isKindOfClass:[NSNumber class]]
    && ([originalPrice integerValue] == [price integerValue]));
}


+ (BOOL)letaoIsCouponAmountGreaterThanZero:(NSNumber *)couponAmount {
    return ([couponAmount isKindOfClass:[NSNumber class]]
    && ([couponAmount integerValue] >0));
}


+ (NSString *)letaoFormatterYuanWithFenMoney:(id)money {
    if ([money isKindOfClass:[NSString class]]
        || [money isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%0.2f",[money floatValue]/100];
    }
    return @"0.00";
}

+ (NSString *)letaoFormatterIntegerYuanWithFenMoney:(id)money {
    if ([money isKindOfClass:[NSString class]]
        || [money isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%0.0f",[money floatValue]/100];
    }
    return @"0";
}



+ (NSString *)letaoCommonDateStringForDate:(NSDate *)date {
    static NSCalendar *calendar = nil;
    if (!calendar) {
        calendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    BOOL isToday = NO;
    BOOL isYesterday = NO;
    if ([cmp1 day] == [cmp2 day] && [cmp1 year] == [cmp2 year] && [cmp1 month] == [cmp2 month]) { // 今天
        formatter.dateFormat = @" HH:mm";
        isToday = YES;
    } else if(([cmp1 day] +1) == [cmp2 day] && [cmp1 year] == [cmp2 year] && [cmp1 month] == [cmp2 month]) { // 昨天
        formatter.dateFormat = @" HH:mm";
        isYesterday = YES;
    }
//    else if ([cmp1 year] == [cmp2 year]) { // 今年
//        formatter.dateFormat = @"MM-dd HH:mm";
//    }
    else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    NSString *time = [formatter stringFromDate:date];
    NSString *prefixString = nil;
    if (isToday) {
        prefixString = @"今天";
    } else if (isYesterday) {
        prefixString = @"昨天";
    } else {
        prefixString = @"";
    }
    return [NSString stringWithFormat:@"%@%@",prefixString,time];
    
}

+ (NSString *)letaoSourceTextForType:(NSString *)type {
    return [[XLTAppPlatformManager shareManager] letaoSourceTextForType:type];
}

+ (void)letaoUpdateEarnLabel:(UILabel * _Nullable)letaoearnLabel
         earnAmount:(NSNumber *)earnAmount
 letaooriginalPriceLabel:(UILabel * _Nullable)letaooriginalPriceLabel
      originalPrice:(NSNumber *)originalPrice
letaopricePrefixLabel:(UILabel * _Nullable)letaopricePrefixLabel
         letaopriceLabel:(UILabel * _Nullable)letaopriceLabel
              price:(NSNumber *)price
 letaocouponAmountButton:(UIButton * _Nullable)letaocouponAmountButton
       couponAmount:(NSNumber *)couponAmount
    couponStartTime:(NSTimeInterval)couponStartTime
      couponEndTime:(NSTimeInterval)couponEndTime {

    [self letaoUpdateEarnLabel:letaoearnLabel
               earnAmount:earnAmount
       letaooriginalPriceLabel:letaooriginalPriceLabel
            originalPrice:originalPrice
  originalPricePrefixText:@""
         letaopricePrefixLabel:letaopricePrefixLabel
               letaopriceLabel:letaopriceLabel
                    price:price
       letaocouponAmountButton:letaocouponAmountButton
             couponAmount:couponAmount
          couponStartTime:couponStartTime
            couponEndTime:couponEndTime];
}


+ (void)letaoUpdateEarnLabel:(UILabel * _Nullable)letaoearnLabel
         earnAmount:(NSNumber *)earnAmount
 letaooriginalPriceLabel:(UILabel *)letaooriginalPriceLabel
      originalPrice:(NSNumber *)originalPrice
originalPricePrefixText:(NSString *)originalPricePrefixText
letaopricePrefixLabel:(UILabel *)letaopricePrefixLabel
         letaopriceLabel:(UILabel *)letaopriceLabel
              price:(NSNumber *)price
 letaocouponAmountButton:(UIButton * _Nullable)letaocouponAmountButton
           couponAmount:(NSNumber *)couponAmount
    couponStartTime:(NSTimeInterval)couponStartTime
          couponEndTime:(NSTimeInterval)couponEndTime {
    
    //letaoearnLabel
    letaoearnLabel.hidden = ![XLTGoodsDisplayHelp letaoShouldShowEarnWithAmount:earnAmount];
    if (!letaoearnLabel.hidden) {
        letaoearnLabel.text = [NSString stringWithFormat:@"返%@ ",[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:earnAmount]];
    }
    
     //letaooriginalPriceLabel 划线价
    letaooriginalPriceLabel.hidden = [XLTGoodsDisplayHelp letaoIsOriginalPrice:originalPrice sameToPrice:price];
    if (!letaooriginalPriceLabel.hidden) {
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        if (![originalPricePrefixText isKindOfClass:[NSString class]]) {
            originalPricePrefixText = @"";
        }
        NSString *originalPriceText = [originalPricePrefixText stringByAppendingString:[XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:originalPrice]];
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:originalPriceText];
        [attribtStr addAttributes:attribtDic range:NSMakeRange(originalPricePrefixText.length, attribtStr.length -originalPricePrefixText.length )];
        letaooriginalPriceLabel.attributedText = attribtStr;
    }
    

    
    //price
    letaopriceLabel.text = [XLTGoodsDisplayHelp letaoFormatterYuanWithFenMoney:price];
    
    BOOL shouldDisplayCoupon = [XLTGoodsDisplayHelp letaoShouldShowCouponWithAmount:couponAmount couponStartTime:couponStartTime couponEndTime:couponEndTime];
    //letaopricePrefixLabel 券后
    letaopricePrefixLabel.hidden = !shouldDisplayCoupon;
    if (!letaopricePrefixLabel.hidden) {
        letaopricePrefixLabel.text = @"券后";
    }
    
    // letaocouponAmountButton
    letaocouponAmountButton.hidden = !shouldDisplayCoupon;
    if (shouldDisplayCoupon && [letaocouponAmountButton isKindOfClass:[UIButton class]]) {
        NSString *couponAmountText = [NSString stringWithFormat:@"优惠券%@元",[XLTGoodsDisplayHelp letaoFormatterIntegerYuanWithFenMoney:couponAmount]];
        [letaocouponAmountButton setTitle:couponAmountText forState:UIControlStateNormal];
        if (letaocouponAmountButton.currentBackgroundImage == nil) {
            UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:letaocouponAmountButton.bounds.size];
            //圆角
            UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, [UIScreen mainScreen].scale);
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height) byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)] addClip];
            [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
            UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [letaocouponAmountButton setBackgroundImage:roundedImage forState:UIControlStateNormal];
            letaocouponAmountButton.alpha = 0.9;
        }
    }
}

+ (NSString *)letaoNoneSecondDateStringWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    }
    if ([date isKindOfClass:[NSDate class]]) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return @"";

}

+ (NSString *)letaoSecondDateStringWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if ([date isKindOfClass:[NSDate class]]) {
        NSString *dateString = [dateFormatter stringFromDate:date];
        return dateString;
    }
    return @"";

}


+ (NSArray *)processSizeForShareActivityItems:(NSArray *)activityItems goodsImage:(UIImage  * _Nullable )goodsImage {
    NSMutableArray *shareItems = [NSMutableArray array];
    if ([activityItems isKindOfClass:[NSArray class]]) {
        CGFloat maxLength = 200;
        [activityItems enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImage class]]) {
                // 大小处理
                NSData *compressImageData = [obj letaocompressWithMaxLength:1024*maxLength];
                if (compressImageData.length) {
                    UIImage *compressImage = [UIImage imageWithData:compressImageData];
                    if (compressImage) {
                        XLTShareImageItem *shareItem = [[XLTShareImageItem alloc] initWithPlaceholderItem:compressImage];
                        if (goodsImage == obj) {
                            shareItem.qq_placeholderItem = [obj letaocompressWithMaxLength:1024*100];
                        } else {
                            UIImage *qqImage = [self processQQImage:obj];
                            shareItem.qq_placeholderItem = qqImage;
                        }
                        [shareItems addObject:shareItem];
                    }
                }
            } else {
                [shareItems addObject:obj];
            }
        }];
    }
   
    return shareItems;
}

+ (UIImage *)processQQImage:(UIImage *)qqImage {
    UIImage *processImage = [self imageByScalingAndCroppingForSize:CGSizeMake(750, 750) sourceImage:qqImage];
    return processImage;
}


+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
//    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
