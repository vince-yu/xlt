//
//  XLTVipLogic.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipLogic.h"
#import "XLTVipGoodsModel.h"
#import "XLTVipOrderListModel.h"
#import "XLTVipTaskModel.h"
#import "XLTVipRightsModel.h"
#import "XLTUserManager.h"

@implementation XLTVipLogic
//VIP商品列表
+ (void)getVipGoodsListWithPage:(NSString *)page row:(NSString *)row success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kVipGoodsList parameters:@{@"page":page,@"row":row} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTVipGoodsModel class] json:model.data];
                success(letaoPageDataArray);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//VIP订单列表
+ (void)getVipOderListWithPage:(NSString *)page row:(NSString *)row success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kVipOrderList parameters:@{@"page":page,@"row":row} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTVipOrderListModel class] json:model.data];
                success(letaoPageDataArray);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//VIP任务列表
+ (void)getVipTaskListWithSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kVipTaskList parameters:nil responseCache:^(id responseCache) {

    } success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTVipTaskModel *task = [XLTVipTaskModel modelWithDictionary:model.data];
                success(task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}

+ (XLTVipTaskModel * _Nullable)getVipTaskListResponseCache {
    NSDictionary *responseCache = [XLTNetworkCache httpCacheForURL:kVipTaskList parameters:nil];
    if ([responseCache isKindOfClass:[NSDictionary class]]) {
        NSDictionary *cacheInfo = responseCache;
        NSDictionary *dataInfo = cacheInfo[@"data"];
        if ([dataInfo isKindOfClass:[NSDictionary class]] && dataInfo.count > 0) {
            NSString *user_id = dataInfo[@"user_id"];
            NSString *currentUId = [XLTUserManager shareManager].curUserInfo._id;
            if ([user_id isKindOfClass:[NSString class]]
                && [currentUId isKindOfClass:[NSString class]]
                && [user_id isEqualToString:currentUId]) {
                // 同一用户
                XLTVipTaskModel *task = [XLTVipTaskModel modelWithDictionary:dataInfo];
                return task;
            }
        }
    }
    return nil;
}


//VIP任务列表
+ (void)fetchVipTaskListWithId:(NSString *)uid success:(void(^)(XLTVipTaskModel * model))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    [XLTNetworkHelper GET:kVipTaskList parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTVipTaskModel *task = [XLTVipTaskModel modelWithDictionary:model.data];
                success(task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}

//VIP权益列表
+ (void)getVipRightListWithSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kVipRightsList parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTVipRightsModel *task = [XLTVipRightsModel modelWithDictionary:model.data];
                [XLTUserManager shareManager].rightModel = task;
                success(task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
@end
