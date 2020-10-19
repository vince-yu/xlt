//
//  XLDGoodsDetailFooterView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface XLDGoodsDetailFooterView : UIView
@property (nonatomic, weak) IBOutlet SPButton *letaoHomeBtn;
@property (nonatomic, weak) IBOutlet SPButton *letaoCommandBtn;
@property (nonatomic, weak) IBOutlet UIButton *letaoBuyBtn;
@property (nonatomic, weak) IBOutlet UIButton *letaoShareBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *letaoBuyBtnWidth;
@property (nonatomic, strong) UIButton *letaoLimitBuyBtn;

@property (nonatomic, readonly) BOOL letaoIsAliSource;

- (void)letaoUpdateErarnAmount:(NSNumber *)amount
                   shareAmount:(NSNumber *)shareAmount
                  couponAmount:(NSNumber *)couponAmount
                 prepaidAmount:(NSNumber *)prepaidAmount
                   goodsSource:(NSString *)source
                   isPreCoupon:(BOOL)isPreCoupon
         isLetaoHighCommission:(BOOL)isLetaoHighCommission
                isPrepaidGoods:(BOOL)isPrepaidGoods
                 isCouponValid:(BOOL)isCouponValid;
@end

NS_ASSUME_NONNULL_END
