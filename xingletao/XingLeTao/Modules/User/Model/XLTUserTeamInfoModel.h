//
//  XLTUserTeamInfoModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/22.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserTeamInfoModel : XLTBaseModel
@property (nonatomic ,copy) NSString *fansOnetwo;
@property (nonatomic ,copy) NSString *fansOne;
@property (nonatomic ,copy) NSString *fansTwo;
@property (nonatomic ,copy) NSString *today;
@property (nonatomic ,copy) NSString *yesterday;
@property (nonatomic ,copy) NSString *month;
@property (nonatomic ,copy) NSString *lastmonth;
@property (nonatomic ,copy) NSString *vaild_direct_vip;  //类型：String  必有字段  备注：有效直接用户(会员)数
@property (nonatomic ,copy) NSString *vaild_indirect_vip;  //类型：String  必有字段  备注：有效其它用户(会员)数

@end

@interface XLTUserTeamItemListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *itemId;
@property (nonatomic ,copy) NSString *avatar;
@property (nonatomic ,copy) NSString *inviterUsername; //类型：String  必有字段  备注：邀请人
@property (nonatomic ,copy) NSString *fansOnetwo;
@property (nonatomic ,copy) NSString *username;
@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *fans_all;          //类型：Number  必有字段  备注：粉丝数
@property (nonatomic ,copy) NSString *can_copy;          //类型：Boolean  必有字段  备注：是否可复制
@property (nonatomic ,copy) NSString *phone;         //类型：String  必有字段  备注：手机号码
@property (nonatomic ,copy) NSString *recent;        //类型：Number  必有字段  备注：[0:无效 1:有效]
@property (nonatomic ,copy) NSString *tip;//copy_helptext;     //类型：String  必有字段  备注：复制帮助文案
@property (nonatomic ,copy) NSString *estimate_total;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,strong) NSArray *user_task_list;
@property (nonatomic ,copy) NSString *process_explain;
@property (nonatomic ,copy) NSNumber *process;
@property (nonatomic ,copy) NSNumber *recommed ;
@property (nonatomic ,copy) NSNumber *register_from; //4、机器人
@property (nonatomic ,copy) NSNumber *status;
@end
/*
 "username":"133****8565",                //类型：String  必有字段  备注：昵称
 "avatar":"mock",                //类型：String  必有字段  备注：头像
 "itime":1574220200,                //类型：Number  必有字段  备注：注册时间
 "today_total":0,                //类型：Number  必有字段  备注：今日收益
 "today_estimate":0,                //类型：Number  必有字段  备注：今日预估收益
 "yesterday_total":0,                //类型：Number  必有字段  备注：昨日收益
 "yesterday_estimate":0,                //类型：Number  必有字段  备注：昨日预估收益
 "nowmonth_total":0,                //类型：Number  必有字段  备注：当月收益
 "nowmonth_estimate":0,                //类型：Number  必有字段  备注：当月预估收益
 "lastmonth_total":0,                //类型：Number  必有字段  备注：上月收益
 "lastmonth_estimate":"mock",                //类型：String  必有字段  备注：上月预估收益
 "unsettled_amount":"mock"                //类型：String  必有字段  备注：总未结算佣金
 */
 
@interface XLTUserIncomeModel : XLTBaseModel
@property (nonatomic ,copy) NSString *itemId;
@property (nonatomic ,copy) NSString *username;
@property (nonatomic ,copy) NSString *avatar;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *today_total;
@property (nonatomic ,copy) NSString *today_estimate;
@property (nonatomic ,copy) NSString *yesterday_total;
@property (nonatomic ,copy) NSString *yesterday_estimate;
@property (nonatomic ,copy) NSString *nowmonth_total;
@property (nonatomic ,copy) NSString *nowmonth_estimate;
@property (nonatomic ,copy) NSString *lastmonth_total;
@property (nonatomic ,copy) NSString *lastmonth_estimate;
@property (nonatomic ,copy) NSString *unsettled_amount;
@property (nonatomic ,copy) NSString *valid_order_count;  //类型：String  必有字段  备注：有效订单数
@property (nonatomic ,copy) NSString *vaild_direct_vip;     //类型：String  必有字段  备注：有效直接会员
@property (nonatomic ,copy) NSString *invalid_order_count;  //类型：String  必有字段  备注：无效订单数
@property (nonatomic ,copy) NSString *invaild_direct_vip;  //类型：String  必有字段  备注：无效直接用户(会员)数
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *canCopy;
@property (nonatomic ,copy) NSString *tip;//copy_helptext;     //类型：String  必有字段  备注：复制帮助文案
@property (nonatomic ,copy) NSString *recent;
@property (nonatomic ,copy) NSString *level;
@property (nonatomic ,copy) NSString *valid_order_count_total;      //valid_order_count_total 有效订单总数 
@property (nonatomic ,copy) NSString *invalid_order_count_total; //invalid_order_count_total 无效订单总数
@property (nonatomic ,copy) NSNumber *status;

@end
NS_ASSUME_NONNULL_END
