//
//  QQWBaseModel.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/5/8.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTBaseModel.h"
#import "XLTUserManager.h"

@implementation XLTBaseModel

//需要登录
#define kInvalidUserCode 201
#define kCorrectCode 0

- (BOOL)isCorrectCode {
    
    BOOL isCorrectCode = ([self.xlt_rcode isKindOfClass:[NSString class]] && [self.xlt_rcode integerValue] == kCorrectCode)
            || ([self.xlt_rcode isKindOfClass:[NSNumber class]] && [self.xlt_rcode integerValue] == kCorrectCode);
    if (!isCorrectCode) {
        [self checkInvalidUserCode];
    }
    return isCorrectCode;
}

//需要登录
- (void)checkInvalidUserCode {
    BOOL isInvalidUserCode = ([self.xlt_rcode isKindOfClass:[NSString class]] && [self.xlt_rcode integerValue] == kInvalidUserCode)
               || ([self.xlt_rcode isKindOfClass:[NSNumber class]] && [self.xlt_rcode integerValue] == kInvalidUserCode);
    if (isInvalidUserCode) {
        self.message = @"登录失效，请重新登录";
        [[XLTUserManager shareManager] logout];
        [[XLTUserManager shareManager] displayLoginViewController];
    }
}

+ (instancetype)automaticParserDataWithJSON:(id)json  {
    NSDictionary *dictionary = [self dictionaryWithJSON:json];
    if (dictionary) {
        XLTBaseModel *model = [self modelWithDictionary:dictionary];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            model.xlt_rcode = dictionary[@"code"];
        }
        NSDictionary *dataDictionary = dictionary[@"data"];
        if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
            [model modelSetWithDictionary:dataDictionary];
        }
        return model;
    }
    return nil;
}


+ (NSDictionary *)dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}


@end

