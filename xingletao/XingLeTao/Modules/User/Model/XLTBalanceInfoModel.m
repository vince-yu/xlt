//
//  XLTBalanceInfoModel.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBalanceInfoModel.h"

@implementation XLTBalanceInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"BlanceId":@"_id",
             @"userId":@"user_id",
             @"amountTotal":@"amount_total",
             @"amountTaken":@"amount_taken",
             @"amountAvail":@"amount_avail",
             @"amountFrozen":@"freeze_amount",
             @"amountMonth":@"amount_month",
             @"amountComing":@"amount_coming",
             @"orderTotalCount":@"order_total_count",
             @"orderTotalAmount":@"order_total_amount",
             @"orderComingCount":@"order_coming_count",
             @"orderComingAmount":@"order_coming_amount",
             @"orderAvailAmount":@"order_avail_amount",
             @"orderAvailCount":@"order_avail_count",
             @"orderFailAmount":@"order_fail_amount",
             @"orderFailCount":@"order_fail_count",
             @"estimatedRebateAmount":@"estimated_rebate_amount",
             
             @"unsettledAmount":@"unsettled_amount",
             @"withdrawAmount":@"withdraw_amount",
             @"amountUseable":@"amount_useable",
             };
}
@end
