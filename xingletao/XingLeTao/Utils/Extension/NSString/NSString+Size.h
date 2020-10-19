//
//  NSString+Size.h
//  Field
//
//  Created by 赵治玮 on 2017/11/9.
//  Copyright © 2017年 赵治玮. All rights reserved.
//  gitHub:https://github.com/shabake/GHDropMenuDemo

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (NSString *)priceStr;

/*
 *  转换时间戳为字符串形式
 *
 *  @param formatter 格式
 *
 *  @return 装换后的时间
 */
- (NSString *)convertDateStringWithTimeStr:(NSString *)formatter;
//秒
- (NSString *)convertDateStringWithSecondTimeStr:(NSString *)formatter;
- (NSString *)secretStrFromPhoneStr;
//str 判空，占位，拼接
+ (NSString *)checkStrLenthWithStr:(NSString *)old placeholder:(NSString *)holder appStr:(NSString *)str before:(BOOL )before;
//元转分
- (NSString *)yuanToTransfer;
//纯数字判断
- (BOOL)isPureInt;
//分转元
- (NSString *)fenToTransyuan;
//电话号码
- (BOOL )isPhoneNumber;
@end
