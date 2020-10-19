//
//  UIImage+UIColor.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/7/25.
//  Copyright © 2019 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UIColor)
+ (UIImage *)letaoimageWithColor:(UIColor *)color;
 /*
  gradientType
  0,//从上到小
  1,//从左到右
  2,//左上到右下
  3,//右上到左下
  */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(int )gradientType imgSize:(CGSize)imgSize;
@end

NS_ASSUME_NONNULL_END
