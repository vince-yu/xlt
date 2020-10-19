//
//  XLTRecommedFeedLogic.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTRecommedFeedLogic.h"
#import "AFHTTPSessionManager.h"

@implementation XLTRecommedFeedLogic
+ (NSURLSessionTask *)requestGoodsCanRecommend:(NSString *)goodsId
                      itemSource:(NSString *)itemSource
                         success:(void(^)(XLTBaseModel *model,NSURLSessionDataTask * task))success
                         failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = goodsId;
    parameters[@"item_source"] = itemSource;
    return [XLTNetworkHelper GET:kGoodsCanRecommendUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model,task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error,task);
    }];
}

+ (NSURLSessionDataTask *)uploadFeedImageData:(NSData *)fileData
                                    success:(void(^)(NSDictionary *info))success
                                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"save_type"] = @"images";
    
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    sessionManager.requestSerializer.timeoutInterval = 60;

    NSString *url = @"v2/community-goods-recm/upfile";
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    
    return [sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"files" fileName:@"feed.jpg" mimeType:@"image/jpg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *fileArray = model.data;
                success(fileArray.firstObject);
            } else {
                failure(Data_Error);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(Data_Error);
    }];
}

+ (NSURLSessionDataTask *)uploadFeedFileType:(NSString *)fileType
                                    filePath:(NSString *)filePath
                                     success:(void(^)(NSDictionary *info))success
                                     failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"save_type"] = fileType;
    
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    sessionManager.requestSerializer.timeoutInterval = 60*2;

    NSString *url = @"v2/community-goods-recm/upfile";
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    
    return [sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"files" error:&error];
        (failure && error) ? failure(Data_Error) : nil;
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *fileArray = model.data;
                success(fileArray.firstObject);
            } else {
                failure(Data_Error);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(Data_Error);
    }];
}

+ (void)recommendGoods:(NSString *)goodsId
            itemSource:(NSString *)itemSource
                itemId:(NSString *)itemId
             imageUrls:(NSArray *)imageUrls
           contentText:(NSString *)contentText
              tomorrow:(NSString *)tomorrow
               success:(void(^)(NSDictionary *stateInfo))success
               failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = goodsId;
    parameters[@"item_source"] = itemSource;
    parameters[@"item_id"] = itemId;
    parameters[@"share_content"] = contentText;
    parameters[@"tomorrow"] = tomorrow;
    parameters[@"images"] = imageUrls;
    [XLTNetworkHelper POST:kSendRecommendFeedUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}

/*
 获取我推荐的商品列表
 sort 排序 order_count reward_amount
 stauts 筛选类型 1 成功 2 审核失败
 date 筛选时间 精确到月份 2020-06
 */
+ (void)getMyRecommendListPage:(NSString *)page
                            row:(NSString *)row
                           sort:(NSString *)sort
                         status:(NSString *)stauts
                           date:(NSString *)date
                        success:(void(^)(NSArray *stateInfo))success
                        failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = page;
    parameters[@"row"] = row;
    parameters[@"sort"] = sort;
    parameters[@"stauts"] = stauts;
    parameters[@"date"] = date;
    
    [XLTNetworkHelper GET:kMyRecommendListUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        
    }];
}

+ (NSMutableDictionary *)commonParametersAdd:(NSDictionary *)parameters URLString:(NSString *)URLString sessionManager:(AFHTTPSessionManager *)sessionManager {
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

+ (void)deleteMyRecommendWithId:(NSString *)recm_uid
                        success:(void(^)(NSArray *stateInfo))success
                        failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"recm_id"] = recm_uid;
    [XLTNetworkHelper POST:kMyRecommendDeleteUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
/*
 获取我推荐的奖励记录
 */
+ (void)getMyRewardListPage:(NSString *)page
                        row:(NSString *)row
                    success:(void(^)(NSArray *stateInfo))success
                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = page;
    parameters[@"row"] = row;
    [XLTNetworkHelper GET:kMyRewardListUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *array = [NSArray modelArrayWithClass:[XLTMyRewardListModel class] json:model.data];
                success(array);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
/*
 获取我推荐的奖励信息
 */
+ (void)getMyRewardInfoSuccess:(void(^)(XLTMyRewardInfoModel *stateInfo))success
                    failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kMyRewardInfoUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTMyRewardInfoModel *info = [XLTMyRewardInfoModel modelWithDictionary:model.data];
                success(info);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}

+ (NSURLSessionDataTask *)requeFeedRecommedRankingListDataForIndex:(NSInteger)index
                                                          pageSize:(NSInteger)pageSize
                                                       rankingType:(NSString*)rankingType
                                                           success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                           failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (rankingType) {
        [parameters setObject:rankingType forKey:@"day-type"];
    }

    return [XLTNetworkHelper GET:kRecommendFeedListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                success(model.data,task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,task);
    }];
}
@end
