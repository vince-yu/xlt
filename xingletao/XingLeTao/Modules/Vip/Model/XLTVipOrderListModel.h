//
//  XLTVipOrderListModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface XLTVipOrderGoodsInfo : XLTBaseModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSArray *banner;
@end

@interface XLTVipOrderAddress : XLTBaseModel
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *full_addr;

@end

@interface XLTVipOrderListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *goods_id;
@property (nonatomic ,strong) XLTVipOrderGoodsInfo *goods_info;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,strong) XLTVipOrderAddress *user_addr;
@property (nonatomic ,copy) NSString *out_trade_no;              //类型：String  必有字段  备注：订单号
@property (nonatomic ,copy) NSString *itime;                     //类型：Number  必有字段  备注：订单创建时间
@property (nonatomic ,copy) NSString *express_status;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *express_no;               //类型：String  必有字段  备注：运单号
@property (nonatomic ,copy) NSString *express_com;              //类型：String  必有字段  备注：快递公司

@end

NS_ASSUME_NONNULL_END
