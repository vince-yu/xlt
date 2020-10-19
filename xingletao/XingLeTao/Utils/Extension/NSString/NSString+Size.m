//
//  NSString+Size.m
//  Field
//
//  Created by 赵治玮 on 2017/11/9.
//  Copyright © 2017年 赵治玮. All rights reserved.
//  gitHub:https://github.com/shabake/GHDropMenuDemo

#import "NSString+Size.h"

@implementation NSString (Size)
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
 
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
}
- (NSString *)priceStr{
    if (!self.length) {
        return @"0.0";
    }
    return [NSString stringWithFormat:@"%.2f",[self doubleValue] / 100];
}
//毫秒
- (NSString *)convertDateStringWithTimeStr:(NSString *)formatter
{
    NSTimeInterval time=[self doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
//秒
- (NSString *)convertDateStringWithSecondTimeStr:(NSString *)formatter
{
    NSTimeInterval time=[self doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
- (NSString *)secretStrFromPhoneStr
{
    if (self.length < 7) {
        return self;
    }
    NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(3, 4)];
    NSString *str = [self replaceCharactersAtIndexes:@[rangeValue] withString:@"****"];
    return str;
}
- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString {
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for (NSInteger i = 0; i < [indexes count]; i++) {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}
+ (NSString *)checkStrLenthWithStr:(NSString *)old placeholder:(NSString *)holder appStr:(NSString *)str before:(BOOL )before{
    if (old.length) {
        if (str.length) {
            if (before) {
                NSString *newStr = [NSString stringWithFormat:@"%@%@",str,old];
                return newStr;
            }else{
                NSString *newStr = [NSString stringWithFormat:@"%@%@",old,str];
                return newStr;
            }
            
        }else{
            return old;
        }
       
    }else{
        if (str.length) {
            if (before) {
                NSString *newStr = [NSString stringWithFormat:@"%@%@",str,holder];
                return newStr;
            }else{
                NSString *newStr = [NSString stringWithFormat:@"%@%@",holder,str];
                return newStr;
            }
        }else{
            return holder;
        }
        
    }
}
- (NSString *)yuanToTransfer{
    if (!self.length) {
        
        return self;
    }
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalFenNumber = [decimalNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    return [NSString stringWithFormat:@"%ld",decimalFenNumber.integerValue];
//    NSInteger fen = [decimalFenNumber integerValue];
}
- (NSString *)fenToTransyuan{
    if (!self.length) {
        
        return self;
    }
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *decimalFenNumber = [decimalNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    return [NSString stringWithFormat:@"%ld",decimalFenNumber.integerValue];
//    NSInteger fen = [decimalFenNumber integerValue];
}
- (BOOL)isPureInt{

    NSScanner* scan = [NSScanner scannerWithString:self];

    int val;

    return[scan scanInt:&val] && [scan isAtEnd];

}
- (BOOL )isPhoneNumber{
    if (self && [self isKindOfClass:[NSString class]]) {
        NSString *regex = @"1[3456789]\\d{9}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        // 字符串判断，然后BOOL值
        BOOL result = [predicate evaluateWithObject:self];
        return result;
    } else {
        return NO;
    }
}

@end
