//
//  XLTOrderListModel.h
//  Xingxlt_
//
//  Created by SNQU on 2019/11/25.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"
/*
  {
     "_id":"mock",                //类型：String  可有字段  备注：ID
     "item_source":"mock",                //类型：String  必有字段  备注：商品来源第三方平台淘宝/天猫/京东
     "item_source_text":"mock",                //类型：String  必有字段  备注：商品来源第三方平台淘宝/天猫/京东
     "item_id":"mock",                //类型：String  必有字段  备注：第三方品台商品ID
     "goods_id":"mock",                //类型：String  必有字段  备注：商品ID
     "item_title":"mock",                //类型：String  必有字段  备注：商品名称
     "item_image":"mock",                //类型：String  必有字段  备注：商品首图
     "item_price":"mock",                //类型：String  必有字段  备注：商品价格
     "item_num":"mock",                //类型：String  必有字段  备注：商品数量
     "third_order_id":"mock",                //类型：String  必有字段  备注：订单编号：第三方平台订单id
     "create_time":"mock",                //类型：String  必有字段  备注：用户下单时间
     "xlt_settle_status":"mock",                //类型：String  必有字段  备注：订单状态[1:即将到账,2:已到账,10:已失效]
     "xlt_settle_status_text":"已到账",                //类型：String  必有字段  备注：订单状态[1:即将到账,2:已到账,10:已失效]
     "xlt_estimated_settle_time":"2019-11-21",                //类型：String  必有字段  备注：预估结算时间
     "xlt_total_amount":"1200",                //类型：String  必有字段  备注：用户总返利金额
     "xlt_refund_status":"1",                //类型：String  必有字段  备注：维权状态 0 无维权，1 维权创建[维权处理中] 2 维权成功，3 维权失败
     "xlt_refund_status_text":"维权创建[维权处理中]"                //类型：String  必有字段  备注：维权状态 0 无维权，1 维权创建[维权处理中] 2 维权成功，3 维权失败
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderForCartInfoModel :  XLTBaseModel
@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *real_name;
@property (nonatomic ,copy) NSString *card_id;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *bank;
@property (nonatomic ,copy) NSString *card_name;
@property (nonatomic ,copy) NSString *logo;
@property (nonatomic ,copy) NSString *rebate_amount;
@property (nonatomic ,copy) NSString *accept_time;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *utime;
@end


@interface XLTOrderListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,copy) NSString *item_source;
@property (nonatomic ,copy) NSString *item_source_text;
@property (nonatomic ,copy) NSString *item_id;
@property (nonatomic ,copy) NSString *goods_id;
@property (nonatomic ,copy) NSString *item_title;
@property (nonatomic ,copy) NSString *item_image;
@property (nonatomic ,copy) NSString *item_price;
@property (nonatomic ,copy) NSString *item_num;
@property (nonatomic ,copy) NSString *third_order_id;
@property (nonatomic ,copy) NSString *create_time;
@property (nonatomic ,copy) NSString *xlt_settle_status;
@property (nonatomic ,copy) NSString *xlt_settle_status_text;
@property (nonatomic ,copy) NSString *xlt_estimated_settle_time;
@property (nonatomic ,copy) NSString *xlt_total_amount;
@property (nonatomic ,copy) NSString *xlt_refund_status;
@property (nonatomic ,copy) NSString *xlt_refund_status_text;
@property (nonatomic ,copy) NSString *paid_amount;
@property (nonatomic ,copy) NSString *seller_shop_id;
@property (nonatomic ,copy) NSString *xlt_order_tips;
@property (nonatomic ,copy) NSString *highlight;
@property (nonatomic ,copy) NSString *discount;
@property (nonatomic ,copy) NSString *text_color;
@property (nonatomic ,copy) NSString *activity_voucher_tips;

//type字段吧，int类型，1 为饿了么
@property (nonatomic ,copy) NSNumber *type;
@property (nonatomic ,copy) NSString *from; //app,wx_robot

//信用卡
@property (nonatomic ,strong) XLTOrderForCartInfoModel *creditCardOrderInfo;
@end

NS_ASSUME_NONNULL_END
