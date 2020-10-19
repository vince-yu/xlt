//
//  XLTVipRightsModel.m
//  XingLeTao
//
//  Created by SNQU on 2020/2/4.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTVipRightsModel.h"

@implementation XLTVipMoreImageModel
- (NSString *)icon{
    return [_icon letaoConvertToHttpsUrl];
}
@end

@implementation XLTVipRightItemDetail
- (NSString *)icon{
    return [_icon letaoConvertToHttpsUrl];
}
@end

@implementation XLTVipRightItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"rights" : [XLTVipRightItemDetail class],
           @"moreimg" : [XLTVipMoreImageModel class]
  };
}
- (NSString *)icon{
    return [_icon letaoConvertToHttpsUrl];
}
@end

@implementation XLTVipRightsModel
// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
  return @{@"list" : [XLTVipRightItem class]};
}
@end
