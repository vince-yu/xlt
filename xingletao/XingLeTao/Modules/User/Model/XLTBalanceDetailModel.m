//
//  XLTBalanceDetailModel.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBalanceDetailModel.h"

//@implementation XLTBalanceDetailExtendModel
//
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"itemSource":@"item_source",
//             @"itemId":@"item_id",
//             @"itemTitle":@"item_title",
//             @"itemImage":@"item_image",
//             @"accountName":@"account_name",
//             };
//}
//
//@end

@implementation XLTBalanceDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"balanceDitalId":@"_id",
             @"totalAmount":@"total_amount",
             @"withdrawStatus":@"withdraw_status",
             @"alipayAccount":@"alipay_account",
             @"itemTitle":@"item_title",
             @"typeText":@"type_text",
             @"withdrawStatusText":@"withdraw_status_text",
             @"itemSource":@"item_source",
//             @"extend":@"XLTBalanceDetailExtendModel"
             };
}
@end
