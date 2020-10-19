//
//  UIColor+XLTColorConstant.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "UIColor+XLTColorConstant.h"
#import "UIColor+Helper.h"


@implementation UIColor (XLTColorConstant)
#pragma mark - 公用颜色


/**
 主色调
 */
+ (UIColor *)letaomainColorSkinColor
{
    return [UIColor colorWithHex:0xFFFF8202];
}


/**
 公用底部背景颜色
 主要用于背景底色
 色值: #F5F5F5 RGB(245,245,245)
 */
+ (UIColor *)letaolightgreyBgSkinColor
{
    return [UIColor colorWithHex:0xFFF5F5F7];
}

/**
 公用分割线颜色
 主要用于分割线颜色
 */
+ (UIColor *)letaolightgreySeparatorLineSkinColor
{
    return [UIColor colorWithHex:0xFFEBEBED];
}


/**
 灰色禁用颜色
 主要用于灰色按钮disable状态颜色
 色值: #AAAAAA RGB(170, 170, 170)
 */
+ (UIColor *)letaolightGrayDisableSkinColor
{
    return [UIColor colorWithHex:0xFFAAAAAA];
}
@end
