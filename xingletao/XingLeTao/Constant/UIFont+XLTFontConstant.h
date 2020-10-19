//
//  UIFont+XLTFontConstant.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*字体类型 苹方字体*/

@interface UIFont (XLTFontConstant)

//常规字体
+ (UIFont *)letaoRegularFontWithSize:(CGFloat)size;
//中粗体
+ (UIFont *)letaoMediumBoldFontWithSize:(CGFloat)size;
//细体
+ (UIFont *)letaoLightFontWithSize:(CGFloat)size;
 //极细体
+ (UIFont *)letaoUltralightFontWithSize:(CGFloat)size;
//纤细体
+ (UIFont *)letaoThinFontWithSize:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
