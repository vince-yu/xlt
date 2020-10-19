//
//  XLTActivityModel.m
//  XingLeTao
//
//  Created by SNQU on 2020/4/24.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTActivityModel.h"

@implementation XLTActivityStyleModel
- (NSString *)bgImage_url{
    return [_bgImage_url letaoConvertToHttpsUrl];
}
@end

@implementation XLTActivityBtnModel

@end

@implementation XLTActivityModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"acId":@"_id",
             @"acCode":@"code",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
  // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
  return @{@"button" : [XLTActivityBtnModel class]};
}
@end

@implementation XLTActivityLinkModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"tCode":@"code",
             };
}


@end
