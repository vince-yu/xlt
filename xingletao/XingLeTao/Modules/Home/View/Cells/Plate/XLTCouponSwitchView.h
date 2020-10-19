//
//  XLTCouponSwitchView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XLTCouponSwitchView;
@protocol XLTCouponSwitchViewDelegate <NSObject>

- (void)letaoCouponSwitchView:(XLTCouponSwitchView *)topFilterView didSwitchOn:(BOOL)isOn;

@end

@interface XLTCouponSwitchView : UIView
@property (nonatomic, weak) id<XLTCouponSwitchViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UISwitch *couponSwitch;

@end

NS_ASSUME_NONNULL_END
