//
//  XLTBaseModel.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/5/8.
//  Copyright © 2019  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTBaseModel : NSObject
@property (nonatomic, strong) NSNumber *xlt_rcode;
@property (nonatomic, copy, nullable) NSString *message;
@property (nonatomic, strong) id data;
// code field value is 0
- (BOOL)isCorrectCode;

//parser data field to attribute
+ (instancetype)automaticParserDataWithJSON:(id)json;

@end


NS_ASSUME_NONNULL_END
