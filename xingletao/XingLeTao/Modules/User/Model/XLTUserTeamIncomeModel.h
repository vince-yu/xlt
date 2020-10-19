//
//  XLTUserTeamIncomeModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserTeamIncomeModel : XLTBaseModel
@property (nonatomic ,copy) NSString *today_team_valid_order;            //类型：Number  必有字段  备注：今日订单数
@property (nonatomic ,copy) NSString *today_estimate_commission;        //类型：Number  必有字段  备注：今日预估收入
@property (nonatomic ,copy) NSString *yesterday_team_valid_order;        //类型：Number  必有字段  备注：昨日订单数
@property (nonatomic ,copy) NSString *yesterday_estimate_commission;         //类型：Number  必有字段  备注：昨日预估收入
@property (nonatomic ,copy) NSString *nowmonth_commission;              //类型：Number  必有字段  备注：本月结算收入
@property (nonatomic ,copy) NSString *nowmonth_estimate_commission;      //类型：Number  必有字段  备注：本月付款预估收入
@property (nonatomic ,copy) NSString *nowmonth_team_valid_order;    //类型：Number  必有字段  备注：本月有效订单
@property (nonatomic ,copy) NSString *nowmonth_team_invalid_order;  //类型：Number  必有字段  备注：本月无效订单
@property (nonatomic ,copy) NSString *nowmonth_reward;           //类型：Number  必有字段  备注：本月奖励
@property (nonatomic ,copy) NSString *lastmonth_commission;     //类型：Number  必有字段  备注：上月结算收入
@property (nonatomic ,copy) NSString *lastmonth_estimate_commission;    //类型：Number  必有字段  备注：上月预估收入
@property (nonatomic ,copy) NSString *lastmonth_team_valid_order;   //类型：Number  必有字段  备注：上月有效订单
@property (nonatomic ,copy) NSString *lastmonth_team_invalid_order; //类型：Number  必有字段  备注：上月无效订单
@property (nonatomic ,copy) NSString *lastmonth_reward; //类型：Number  必有字段  备注：上月奖励
@property (nonatomic ,copy) NSString *amount_total; //类型：String  必有字段  备注：总收益

@end

@interface XLTUserMineIncomeModel : XLTBaseModel
@property (nonatomic ,copy) NSString *today_valid_order_count;            //类型：Number  必有字段  备注：今日订单数
@property (nonatomic ,copy) NSString *today_estimate;        //类型：Number  必有字段  备注：今日预估收入
@property (nonatomic ,copy) NSString *yesterday_valid_order_count;        //类型：Number  必有字段  备注：昨日订单数
@property (nonatomic ,copy) NSString *yesterday_estimate;         //类型：Number  必有字段  备注：昨日预估收入
@property (nonatomic ,copy) NSString *nowmonth_total;              //类型：Number  必有字段  备注：本月结算收入
@property (nonatomic ,copy) NSString *nowmonth_estimate;      //类型：Number  必有字段  备注：本月付款预估收入
@property (nonatomic ,copy) NSString *nowmonth_valid_order_count;    //类型：Number  必有字段  备注：本月有效订单
@property (nonatomic ,copy) NSString *nowmonth_invalid_order_count;  //类型：Number  必有字段  备注：本月无效订单
@property (nonatomic ,copy) NSString *nowmonth_reward;           //类型：Number  必有字段  备注：本月奖励
@property (nonatomic ,copy) NSString *lastmonth_total;     //类型：Number  必有字段  备注：上月结算收入
@property (nonatomic ,copy) NSString *lastmonth_estimate;    //类型：Number  必有字段  备注：上月预估收入
@property (nonatomic ,copy) NSString *lastmonth_valid_order_count;   //类型：Number  必有字段  备注：上月有效订单
@property (nonatomic ,copy) NSString *lastmonth_invalid_order_count; //类型：Number  必有字段  备注：上月无效订单
@property (nonatomic ,copy) NSString *lastmonth_reward; //类型：Number  必有字段  备注：上月奖励
@property (nonatomic ,copy) NSString *amount_total; //类型：String  必有字段  备注：总收益

@end

NS_ASSUME_NONNULL_END
