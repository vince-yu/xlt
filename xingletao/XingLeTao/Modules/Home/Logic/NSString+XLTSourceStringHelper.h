//
//  NSString+XLTSourceStringHelper.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XLTSourceStringHelper)
- (NSString *)letaoConvertToHttpsUrl;
- (NSString *)letaoTenThousandNumberFormat;
+ (NSString *)letaoSafeSubstring:(NSString *)str fromReverseIndex:(NSUInteger)index;

+ (NSString *)letaoSafeSubstring:(NSString *)str toIndex:(NSUInteger)index;

//+ (NSMutableString *)letaoRemoveSpecialCharacterForSignString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
