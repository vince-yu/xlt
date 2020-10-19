//
//  XLTBalanceDetailModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

//@interface XLTBalanceDetailExtendModel : XLTBaseModel
//@property (nonatomic ,copy) NSString *itemSource;
//@property (nonatomic ,copy) NSString *itemId;
//@property (nonatomic ,copy) NSString *itemTitle;
//@property (nonatomic ,copy) NSString *itemImage;
//@property (nonatomic ,copy) NSString *accountName;
//@property (nonatomic ,copy) NSString *desc;
//@end
/*
 
 - {                //类型：Object  必有字段  备注：无
              "_id":"5dd67d3602dce6d4d2000dc4",                //类型：String  必有字段  备注：无
              "type":20,                //类型：Number  必有字段  备注：类型[10:商品返利 12:直接下级用户分佣 13:直接二代下级用户分佣 14:订单失效 15:金额变动 16:维权扣款 20:提现申请 21:提现拒绝 30:vip奖励 40:关系变动补偿]
              "total_amount":-100,                //类型：Number  必有字段  备注：变动金额 有正负数
              "withdraw_status":0,                //类型：Number  必有字段  备注：当type=20时出现 申请中的各个状态-1:申请已拒绝1:冻结中2:审核通过3:付款完成99:付款失败
              "alipay_account":"13398208750",                //类型：String  必有字段  备注：无
              "itime":1574337846,                //类型：Number  必有字段  备注：记录生成时间
              "item_title":"mixed",                //类型：Mixed  必有字段  备注：说明 如商品名或提现账号
              "type_text":"提现",                //类型：String  必有字段  备注：类型说明
              "withdraw_status_text":"冻结中",                //类型：String  必有字段  备注：当type=20时出现 申请中的各个状态说明
              "item_source":"mock"                //类型：String  可有字段  备注：商品平台[D:京东，C：淘宝，B：天猫]
          }
 */

@interface XLTBalanceDetailModel : XLTBaseModel
//@property (nonatomic ,copy) NSString *balanceDitalId;
//@property (nonatomic ,copy) NSString *accountType;
//@property (nonatomic ,copy) NSString *type;
//@property (nonatomic ,copy) NSString *status;
//@property (nonatomic ,copy) NSString *amount;
//@property (nonatomic ,strong) XLTBalanceDetailExtendModel *extend;
//@property (nonatomic ,copy) NSString *remark;
//@property (nonatomic ,copy) NSString *itime;
//@property (nonatomic ,copy) NSString *utime;
//@property (nonatomic ,copy) NSString *accountTypeText;
//@property (nonatomic ,copy) NSString *statusText;

@property (nonatomic ,copy) NSString *balanceDitalId;
@property (nonatomic ,copy) NSString *type;  //10:商品返利 12:直接下级用户分佣 13:直接二代下级用户分佣 14:订单失效 15:金额变动 16:维权扣款 20:提现申请 21:提现拒绝 30:vip奖励 40:关系变动补偿]
@property (nonatomic ,copy) NSString *totalAmount;
@property (nonatomic ,copy) NSString *withdrawStatus;
@property (nonatomic ,copy) NSString *alipayAccount;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *itemTitle;
@property (nonatomic ,copy) NSString *typeText;
@property (nonatomic ,copy) NSString *withdrawStatusText;
@property (nonatomic ,copy) NSString *itemSource;
@property (nonatomic ,copy) NSString *reason;

@property (nonatomic ,copy) NSString *icon_url;
@end
