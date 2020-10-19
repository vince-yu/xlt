//
//  MBProgressHUD+TipView.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/24.
//  Copyright © 2019  . All rights reserved.
//

#import "MBProgressHUD+TipView.h"

@implementation MBProgressHUD (QQWTipView)

#define kDefaultTipDurationTime 2.0

+ (void)letaoshowTipMessageInWindow:(NSString*)message {
    [self letaoshowTipMessageInWindow:message hideAfterDelay:kDefaultTipDurationTime];
}

+ (void)letaoshowTipMessageInWindow:(NSString*)message hideAfterDelay:(NSTimeInterval)delay {
    if ([message isKindOfClass:[NSString class]] && message.length > 0) {
        UIView  *view = (UIView*)[UIApplication sharedApplication].delegate.window;
        MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
        if (!hud) {
            hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
        }else{
            [hud showAnimated:YES];
        }
        
//        hud.minSize = CGSizeMake(100, 100);
        hud.label.text = message;
        hud.label.font = [UIFont systemFontOfSize:16.0];
        hud.label.textColor= [UIColor whiteColor];
        hud.label.numberOfLines = 0;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
        hud.removeFromSuperViewOnHide = YES;
        [hud setContentColor:[UIColor whiteColor]];
        //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        //    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:delay];
    }
}

@end
