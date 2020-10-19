//
//  XLTMyRecommendListModel.h
//  XingLeTao
//
//  Created by SNQU on 2020/6/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyRewardInfoModel : XLTBaseModel
@property (nonatomic ,copy) NSString *wait_settlement;       //类型：Number  必有字段  备注：等待结算
@property (nonatomic ,copy) NSString *settlement;           //类型：Number  必有字段  备注：已结算
@property (nonatomic ,copy) NSString *avatar;
@property (nonatomic ,copy) NSString *nickname;
@property (nonatomic ,copy) NSString *is_nomal_settle;
@end

@interface XLTMyRewardListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *listId;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *recm_id;
@property (nonatomic ,copy) NSString *goods_id;
@property (nonatomic ,copy) NSString *item_id;
@property (nonatomic ,copy) NSString *order_count;
@property (nonatomic ,copy) NSString *item_source;
@property (nonatomic ,copy) NSString *reward_amount;
@property (nonatomic ,copy) NSString *status;    //1 等待结算  2 已结算 3结算失败 4 预估结算中

@property (nonatomic ,copy) NSString *item_title;
@property (nonatomic ,copy) NSString *item_image;
@property (nonatomic ,copy) NSString *set_time;  //类型：Number  必有字段  备注：结算时间(如果状态未结算则是预估时间 否则为确实到账的时间)
@property (nonatomic ,copy) NSString *recm_itime; //类型：Number  必有字段  备注：推荐时间
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *utime;
@property (nonatomic ,copy) NSString *rank;
@property (nonatomic ,copy) NSString *settle_type; //1、正常 2、异步结算
@end

NS_ASSUME_NONNULL_END
