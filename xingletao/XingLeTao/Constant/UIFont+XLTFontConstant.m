//
//  UIFont+XLTFontConstant.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "UIFont+XLTFontConstant.h"

@implementation UIFont (XLTFontConstant)
//常规字体
+ (UIFont *)letaoRegularFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

//中粗体
+ (UIFont *)letaoMediumBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}
//细体
+ (UIFont *)letaoLightFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}
 //极细体
+ (UIFont *)letaoUltralightFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}
//纤细体
+ (UIFont *)letaoThinFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Thin" size:size];
}

@end
