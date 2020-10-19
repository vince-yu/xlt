//
//  QQWCircleAnimationView
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XLTCircleAnimationType) {
    XLTCircleAnimationTypeCircle = 0,
    XLTCircleAnimationTypeCircleJoin,
    XLTCircleAnimationTypeDot,
};

@interface XLTCircleAnimationView : UIView

@property (nonatomic,assign) NSInteger  count;

@property (nonatomic) UIColor  *defaultBackGroundColor;//

@property (nonatomic) UIColor  *foregroundColor;

- (void)showAnimationWithType:(XLTCircleAnimationType)animationType;

-(void)removeSubLayer;

@end

