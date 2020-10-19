//
//  XLTOrderListModel.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/25.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderListModel.h"

@implementation XLTOrderListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"orderId":@"_id"
    };
}
@end
@implementation XLTOrderForCartInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"orderId":@"_id"
    };
}

@end
