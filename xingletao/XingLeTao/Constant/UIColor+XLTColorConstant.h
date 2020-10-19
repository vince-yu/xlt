//
//  UIColor+XLTColorConstant.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XLTColorConstant)
/**
 主色调
 */
+ (UIColor *)letaomainColorSkinColor;




/**
 公用底部背景颜色
 主要用于背景底色
 色值: #F5F5F5 RGB(245,245,245)
 */
+ (UIColor *)letaolightgreyBgSkinColor;

/**
 公用分割线颜色
 主要用于分割线颜色
 */
+ (UIColor *)letaolightgreySeparatorLineSkinColor;


/**
 灰色禁用颜色
 主要用于灰色按钮disable状态颜色
 色值: #AAAAAA RGB(170, 170, 170)
 */
+ (UIColor *)letaolightGrayDisableSkinColor;

@end

NS_ASSUME_NONNULL_END
