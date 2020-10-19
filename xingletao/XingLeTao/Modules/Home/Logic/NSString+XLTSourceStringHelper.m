//
//  NSString+XLTImageStringHelper.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "NSString+XLTSourceStringHelper.h"

@implementation NSString (XLTSourceStringHelper)

- (NSString *)letaoConvertToHttpsUrl {
    if ([self hasPrefix:@"http"]) {
        return self;
    } else {
        return [NSString stringWithFormat:@"https:%@",self];
    }
}

+ (NSString *)letaoSafeSubstring:(NSString *)str fromReverseIndex:(NSUInteger)index {
    NSUInteger subIndex = MAX(0, str.length - index);
    if (subIndex == 0) {
        return str;
    } else {
        return [str substringFromIndex:subIndex];
    }
}

+ (NSString *)letaoSafeSubstring:(NSString *)str toIndex:(NSUInteger)index {
    if (index < str.length) {
        return [str substringToIndex:index];
    } else {
        return str;
    }
}
- (NSString *)letaoTenThousandNumberFormat {
    NSUInteger number = [self integerValue];
    if (number > 10000) {
        return [NSString stringWithFormat:@"%0.1f万",number / 10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",(long)number];
    }
}
//+ (NSMutableString *)letaoRemoveSpecialCharacterForSignString:(NSString *)str {
//    NSMutableString *resultStr = [NSMutableString string];
//    if ([str isKindOfClass:[NSString class]] && str.length > 0) {
//        [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//            NSUInteger bytesLength = [substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//            if (bytesLength < 4) {
//                [resultStr appendString:substring];
//            }
//        }];
//    }
//    return resultStr;
//}


//+ (NSMutableString *)letaoRemoveSpecialCharacterForSignString:(NSString *)str {
//    NSMutableString *resultStr = [NSMutableString string];
//    if ([str isKindOfClass:[NSString class]] && str.length > 0) {
//        [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//            NSUInteger bytesLength = [substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//            if (bytesLength < 4) {
//                [resultStr appendString:substring];
//            } else {
//                // 服务器容错处理，他们不能处理emoji 16号变体选择符，最加到后面
//                for (int i = 0; i < substring.length; i++) {
//                    unichar ch = [substring characterAtIndex:i];
//                    NSString *everyString = [NSString stringWithCharacters:&ch length:1];
//                    NSUInteger everyBytesLength = [everyString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//                    if (everyBytesLength > 0 && everyString) {
//                        [resultStr appendString:everyString];
//                    }
//                }
//            }
//        }];
//    }
//    return resultStr;
//}
@end
