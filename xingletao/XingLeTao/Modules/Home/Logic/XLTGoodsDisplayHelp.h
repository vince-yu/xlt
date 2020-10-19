//
//  XLTDisplayDiscountCouponHelp.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//GoodsSource C:淘宝 B:天猫 D:京东  V:唯品会 CZB:团油 S:苏宁
extern NSString *const XLTTaobaoPlatformIndicate;
extern NSString *const XLTTianmaoPlatformIndicate;
extern NSString *const XLTJindongPlatformIndicate;
extern NSString *const XLTPDDPlatformIndicate;
extern NSString *const XLTVPHPlatformIndicate;
extern NSString *const XLTCZBPlatformIndicate;
extern NSString *const XLTSuNingPlatformIndicate;

@interface XLTGoodsDisplayHelp : NSObject

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
          couponEndTime:(NSTimeInterval)couponEndTime;

+ (void)letaoUpdateEarnLabel:(UILabel *  _Nullable)letaoearnLabel
         earnAmount:(NSNumber *)earnAmount
 letaooriginalPriceLabel:(UILabel * _Nullable)letaooriginalPriceLabel
      originalPrice:(NSNumber *)originalPrice
originalPricePrefixText:(NSString *)originalPricePrefixText
letaopricePrefixLabel:(UILabel * _Nullable)letaopricePrefixLabel
         letaopriceLabel:(UILabel * _Nullable)letaopriceLabel
              price:(NSNumber *)price
 letaocouponAmountButton:(UIButton * _Nullable)letaocouponAmountButton
           couponAmount:(NSNumber *)couponAmount
    couponStartTime:(NSTimeInterval)couponStartTime
          couponEndTime:(NSTimeInterval)couponEndTime;


+ (NSString *)letaoSourceTextForType:(NSString *)type;

+ (NSString *)letaoFormatterYuanWithFenMoney:(id)money;

+ (NSString *)letaoFormatterIntegerYuanWithFenMoney:(id)money;

+ (BOOL)letaoShouldShowCouponWithAmount:(NSNumber *)couponAmount
                            couponStartTime:(NSTimeInterval)couponStartTime
                              couponEndTime:(NSTimeInterval)couponEndTime;

+ (NSString *)letaoNoneSecondDateStringWithDate:(NSDate *)date;
+ (NSString *)letaoSecondDateStringWithDate:(NSDate *)date;
+ (NSString *)letaoCommonDateStringForDate:(NSDate *)date;

+ (NSArray *)processSizeForShareActivityItems:(NSArray *)activityItems goodsImage:(UIImage  * _Nullable )goodsImage ;

@end

NS_ASSUME_NONNULL_END
