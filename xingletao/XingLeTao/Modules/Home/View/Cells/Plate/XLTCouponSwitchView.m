//
//  XLTPlateCouponSwitchView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCouponSwitchView.h"

@implementation XLTCouponSwitchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)switchValueChanged:(UISwitch *)switchView {
    if ([self.delegate respondsToSelector:@selector(letaoCouponSwitchView:didSwitchOn:)]) {
        [self.delegate letaoCouponSwitchView:self didSwitchOn:switchView.on];
    }
    // 汇报事件
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_FILTER_COUPON properties:nil];
}
@end
