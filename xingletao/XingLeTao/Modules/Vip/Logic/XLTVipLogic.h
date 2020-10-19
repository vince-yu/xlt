//
//  XLTVipLogic.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTVipTaskModel;
@interface XLTVipLogic : XLTNetBaseLogic
//VIP商品列表
+ (void)getVipGoodsListWithPage:(NSString *)page row:(NSString *)row success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//VIP订单列表
+ (void)getVipOderListWithPage:(NSString *)page row:(NSString *)row success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//VIP任务列表
+ (void)getVipTaskListWithSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
+ (XLTVipTaskModel * _Nullable)getVipTaskListResponseCache;


//VIP任务列表
+ (void)fetchVipTaskListWithId:(NSString *)uid success:(void(^)(XLTVipTaskModel * model))success failure:(void(^)(NSString *errorMsg))failure;

//VIP权益列表
+ (void)getVipRightListWithSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
