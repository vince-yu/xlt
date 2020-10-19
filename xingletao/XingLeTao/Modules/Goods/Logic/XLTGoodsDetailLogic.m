//
//  XLTGoodsDetailLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTGoodsDetailLogic.h"
#import "AFHTTPSessionManager.h"
#import "XLTLogManager.h"

@implementation XLTGoodsDetailLogic
// 商品详情数据
- (NSURLSessionTask *)xingletaonetwork_requestGoodsDetailDataWithPlate:(NSString * _Nullable)plate
                                                     category:(NSString * _Nullable)category
                                                 letaoGoodsId:(NSString *)letaoGoodsId
                                                      item_id:(NSString * _Nullable)item_id
                                                      user_id:(NSString * _Nullable)user_id
                                                   itemSource:(NSString *)itemSource
                                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                                      success:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                                                      failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (plate) {
        [parameters setObject:plate forKey:@"plate"];
    }
    if (category) {
        [parameters setObject:category forKey:@"category"];
    }
    
    if (item_id) {
        [parameters setObject:item_id forKey:@"item_id"];
    }

    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }

    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"id"];
    }
    
    if (itemSource) {
        if ([itemSource isEqual:[NSNull null]]) {
            itemSource = @"";
        }
        [parameters setObject:itemSource forKey:@"item_source"];
    }

    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    sessionManager.requestSerializer.timeoutInterval = timeoutInterval;

    NSString *url = kGoodsDetailUrl;
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:url parameters:parameters];
    return [sessionManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model,task);
            } else {
                success(model,task);
                //                NSString *msg = model.message;
                //                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                //                    msg = Data_Error;
                //                }
                //                failure(msg);
            }
        } else {
            failure(Data_Error,task);
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:url response:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(Data_Error,task);
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:url response:nil error:error];
    }];
}

- (NSMutableDictionary *)commonParametersAdd:(NSDictionary *)parameters URLString:(NSString *)URLString sessionManager:(AFHTTPSessionManager *)sessionManager {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [result addEntriesFromDictionary:parameters];
    }
    NSURL *baseUrl = [[NSURL alloc] initWithString:[[XLTAppPlatformManager shareManager] baseApiSeverUrl]];
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:baseUrl];
    NSString *urlPath = url.path;
    if ([urlPath hasPrefix:@"/"]) {
        urlPath = [urlPath substringFromIndex:1];
    }
    
    [XLTNetworkHelper generateSecrtetWithParameters:parameters path:urlPath sessionManager:sessionManager];

    return result;
}


// 商品详情数据[第二部分]
- (NSURLSessionTask *)xingletaonetwork_requestGoodsDescDataWithPlate:(NSString * _Nullable)plate
                                              category:(NSString * _Nullable)category
                                               goodsId:(NSString *)goodsId
                                               item_id:(NSString * _Nullable)item_id
                                               user_id:(NSString * _Nullable)user_id
                                            itemSource:(NSString *)itemSource
                                               success:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (plate) {
        [parameters setObject:plate forKey:@"plate"];
    }
    if (category) {
        [parameters setObject:category forKey:@"category"];
    }
    if (item_id) {
        [parameters setObject:item_id forKey:@"item_id"];
    }

    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }

    if (goodsId) {
        [parameters setObject:goodsId forKey:@"id"];
    }
    
    if (itemSource) {
        if ([itemSource isEqual:[NSNull null]]) {
            itemSource = @"";
        }
        [parameters setObject:itemSource forKey:@"item_source"];
    }

    return [XLTNetworkHelper GET:kGoodsDescDetailUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model,task);
            } else {
               failure(Data_Error,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,task);
    }];
}
// 店铺推荐商品
- (void)xingletaonetwork_requestStoreRecommendGoodsDataWithStoreId:(NSString * _Nullable)letaoStoreId
                                        letaoGoodsId:(NSString * _Nullable)letaoGoodsId
                                     itemSource:(NSString *)itemSource
                                        success:(void(^)(NSArray *goodsArray))success
                                        failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoStoreId) {
        [parameters setObject:letaoStoreId forKey:@"id"];
    }
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"goods_id"];
    }
    if (itemSource) {
        if ([itemSource isEqual:[NSNull null]]) {
            itemSource = @"";
        }
        [parameters setObject:itemSource forKey:@"item_source"];
    }

    [XLTNetworkHelper GET:kStoreRecommendGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}

- (void)xingletaonetwork_requestGoodsRecommenDataWithGoodsId:(NSString *)letaoGoodsId
                              itemSource:(NSString *)itemSource
                                  success:(void(^)(NSArray *goodsArray))success
                                  failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"id"];
    }
    if (itemSource) {
        if ([itemSource isEqual:[NSNull null]]) {
            itemSource = @"";
        }
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    [parameters setObject:@20 forKey:@"row"];
    [parameters setObject:@1 forKey:@"page"];
    [XLTNetworkHelper GET:kGoodDetailRecommendGoodUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}


// 猜你喜欢
- (void)xingletaonetwork_requestYouLikeGoodsDataSuccess:(void(^)(NSArray *goodsArray))success
                             failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kGuessYouLikeGoodsUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}





//- {
//    "link_type": - [                //类型：Array  必有字段  备注：连接类型
//        "2",                //类型：String  必有字段  备注：无
//        "3"                //类型：String  必有字段  备注：无
//    ],
//    "tid":"39997",                //类型：String  必有字段  备注：操作id
//    "link_url":"mock",                //类型：String  必有字段  备注：操作转链url
//    "item_source":"P",                //类型：String  必有字段  备注：平台
//    "need_code":1                //类型：Number  必有字段  备注：0 不需要口令 1 需要口令
//}

// 转链商品接口
- (void)xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:(NSString *)letaoGoodsId
                                                 itemSource:(NSString *)itemSource
                                       isAliCommandTextOnly:(BOOL)isAliCommandTextOnly
                                                    success:(void(^)(XLTBaseModel *model, BOOL isAliCommandTextOnly))success
                                                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"tid"];
    }
    parameters[@"link_type"] = @[@"2",@"1"];
    [parameters setObject:@1 forKey:@"need_code"];
    if (itemSource) {
        if ([itemSource isEqual:[NSNull null]]) {
            itemSource = @"";
        }
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    
    [XLTNetworkHelper POST:kNewGoodsCopoUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model]) {
                success(model,isAliCommandTextOnly);
            } else if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                success(model,isAliCommandTextOnly);
            } else if ([model isCorrectCode]) {
                success(model,isAliCommandTextOnly);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}



#define kAliAuthorizationCode 423
+ (BOOL)letaoIsNeedAliAuthorizationCode:(XLTBaseModel *)model {
    BOOL letaoIsNeedAliAuthorizationCode = ([model.xlt_rcode isKindOfClass:[NSString class]] && [model.xlt_rcode integerValue] == kAliAuthorizationCode)
            || ([model.xlt_rcode isKindOfClass:[NSNumber class]] && [model.xlt_rcode integerValue] == kAliAuthorizationCode);
    return letaoIsNeedAliAuthorizationCode;
}
#define kPDDAuthorizationCode 500002
+ (BOOL)letaoIsNeedPDDAuthorizationCode:(XLTBaseModel *)model {
    BOOL letaoIsNeedAliAuthorizationCode = ([model.xlt_rcode isKindOfClass:[NSString class]] && [model.xlt_rcode integerValue] == kPDDAuthorizationCode)
            || ([model.xlt_rcode isKindOfClass:[NSNumber class]] && [model.xlt_rcode integerValue] == kPDDAuthorizationCode);
    return letaoIsNeedAliAuthorizationCode;
}
- (void)letaoIsAddBrowsingHistoWithId:(NSString *)letaoGoodsId
                                itemSource:(NSString *)itemSource {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"_id"];
    }
    if (itemSource) {
        if ([itemSource isEqual:[NSNull null]]) {
            itemSource = @"";
        }
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    [XLTNetworkHelper POST:kGoodsBrowsingHistoryUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        dispatch_async(dispatch_get_main_queue(), ^{
                    // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kXLTAddBrowsingHistorySuccessNotification" object:letaoGoodsId];
        });

    } failure:^(NSError *error,NSURLSessionDataTask * task) {

    }];
}


// 获取商品推荐语

+ (void)requestEditorsRecommendWithGoodsId:(NSString *)letaoGoodsId
                                itemSource:(NSString *)itemSource
                                   success:(void(^)(XLTBaseModel *model))success
                                   failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = letaoGoodsId;
    parameters[@"item_source"] = itemSource;
    [XLTNetworkHelper GET:kGoodsEditorsRecommendUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model);
            } else {
                failure(Data_Error);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}
@end
