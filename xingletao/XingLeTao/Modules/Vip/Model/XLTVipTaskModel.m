//
//  XLTVipTaskModel.m
//  XingLeTao
//
//  Created by SNQU on 2019/12/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipTaskModel.h"

@implementation XLTVipTaskRulesModel


@end

@implementation XLTVipTaskModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"taskId":@"_id",
             };
}
// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
  // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
  return @{@"event_rules" : [XLTVipTaskRulesModel class]};
}
@end
