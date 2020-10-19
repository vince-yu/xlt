//
//  XLTSearchLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTSearchLogic.h"
#import "AFHTTPSessionManager.h"
#import "XLTLogManager.h"

@interface XLTSearchLogic ()
@end


@implementation XLTSearchLogic
- (void)xingletaonetwork_xingletaonetwork_requestHotKeyWordsDataDataSuccess:(void(^)(NSArray *hotKeyWordsArray))success
                            failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper POST:kSearchHotKeyWordsUrl parameters:nil responseCache:^(id responseCache) {
        XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseCache];
        if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(model.data);
            });
        }
    } success:^(id responseObject, NSURLSessionDataTask *task) {
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
        failure(Data_Error);
    }];
 }


- (void)xingletaonetwork_xingletaonetwork_requestSearchSuggestionDataWithInputText:(NSString *)text success:(void(^)(NSArray * _Nonnull suggestionArray))success
                           failure:(void(^)(NSString *errorMsg))failure {
    if (!XLTAppPlatformManager.shareManager.checkEnable) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (text) {
        [parameters setObject:text forKey:@"search"];
    }
    [XLTNetworkHelper GET:kSearchSuggestionUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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

- (void)letaoCancelSearchSuggestionTask {
    [XLTNetworkHelper cancelRequestWithPath:kSearchSuggestionUrl];
}


- (NSURLSessionTask *)letaoRepoKeyWordsClickedWithId:(NSString *)hotId
                                   success:(void(^)(NSArray * _Nonnull goodsArray))success
                                   failure:(void(^)(NSString *errorMsg))failure {
     NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
     if (hotId) {
         [parameters setObject:hotId forKey:@"id"];
     }
    return [XLTNetworkHelper POST:kSearchHotKeyWordsGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
         if(responseObject != nil) {
             XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
             if ([model isCorrectCode]) {
                 if (![model.data isKindOfClass:[NSArray class]]) {
                     model.data = @[];
                 }
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

- (NSURLSessionTask *)letaoSearchGoodsWithIndex:(NSInteger)index
                                       pageSize:(NSInteger)pageSize
                                           sort:(NSString * _Nonnull)sort
                                         source:(NSString * _Nonnull)source
                                        postage:(NSNumber *)postage
                                      hasCoupon:(BOOL)hasCoupon
                                letaoSearchText:(NSString * _Nonnull)letaoSearchText
                                   letaoGoodsId:(NSString * _Nonnull)letaoGoodsId
                                     startPrice:(NSNumber  * _Nullable )startPrice
                                       endPrice:(NSNumber  * _Nullable )endPrice
                                        success:(void(^)(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task))success
                                        failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (sort) {
        [parameters setObject:sort forKey:@"sort"];
    }
    if (source) {
        [parameters setObject:source forKey:@"item_source"];
    }
    if (postage) {
        [parameters setObject:postage forKey:@"postage"];
    }
    
    if (hasCoupon) {
        [parameters setObject:@1 forKey:@"has_coupon"];
    }
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"goods_id"];
    }
    
    if (letaoSearchText) {
        [parameters setObject:letaoSearchText forKey:@"search"];
    }
    
    
    if (startPrice) {
        [parameters setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [parameters setObject:endPrice forKey:@"end_price"];
    }
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    NSString *checkEnable = XLTAppPlatformManager.shareManager.checkEnable ? @"1" : @"0";
    [sessionManager.requestSerializer setValue:checkEnable forHTTPHeaderField:@"check-enable"];
    NSString *url = kSearchGoodsUrl;
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:url parameters:parameters];
    return [sessionManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

// 剪贴板搜索
- (NSURLSessionTask *)letaoPasteboardSearchGoodsWithIndex:(NSInteger)index
                                            pageSize:(NSInteger)pageSize
                                                sort:(NSString * _Nonnull)sort
                                              source:(NSString * _Nonnull)source
                                             postage:(NSNumber *)postage
                                           hasCoupon:(BOOL)hasCoupon
                                          letaoSearchText:(NSString * _Nonnull)letaoSearchText
                                             letaoGoodsId:(NSString * _Nonnull)letaoGoodsId
                                               startPrice:(NSNumber  * _Nullable )startPrice
                                                 endPrice:(NSNumber  * _Nullable )endPrice
                                             success:(void(^)(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task))success
                                                  failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (sort) {
        [parameters setObject:sort forKey:@"sort"];
    }
    if (source) {
        [parameters setObject:source forKey:@"item_source"];
    }
    if (postage) {
        [parameters setObject:postage forKey:@"postage"];
    }
    
    if (hasCoupon) {
        [parameters setObject:@1 forKey:@"has_coupon"];
    }
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"goods_id"];
    }
    
    if (letaoSearchText) {
        [parameters setObject:letaoSearchText forKey:@"search"];
    }
    
    if (startPrice) {
        [parameters setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [parameters setObject:endPrice forKey:@"end_price"];
    }
    
    return [XLTNetworkHelper GET:kPasteboardSearchGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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



- (NSURLSessionTask *)letaorecommendGoodsWithIndex:(NSInteger)index
                                          pageSize:(NSInteger)pageSize
                                              sort:(NSString * _Nonnull)sort
                                            source:(NSString * _Nonnull)source
                                           postage:(NSNumber *)postage
                                         hasCoupon:(BOOL)hasCoupon
                                   letaoSearchText:(NSString * _Nonnull)letaoSearchText
                                      letaoGoodsId:(NSString * _Nonnull)letaoGoodsId
                                        startPrice:(NSNumber  * _Nullable )startPrice
                                          endPrice:(NSNumber  * _Nullable )endPrice
                                           success:(void(^)(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task))success
                                           failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (sort) {
        [parameters setObject:sort forKey:@"sort"];
    }
    if (source) {
        [parameters setObject:source forKey:@"item_source"];
    }
    if (postage) {
        [parameters setObject:postage forKey:@"postage"];
    }
    
    if (hasCoupon) {
        [parameters setObject:@1 forKey:@"has_coupon"];
    }
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"goods_id"];
    }
    
    if (letaoSearchText) {
        [parameters setObject:letaoSearchText forKey:@"search"];
    }
    
    if (startPrice) {
        [parameters setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [parameters setObject:endPrice forKey:@"end_price"];
    }
    parameters[@"source_type"] = @[@"1",@"4"];
    parameters[@"tid"] = @"layouts_index";
    
    return [XLTNetworkHelper GET:kV3GoodListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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



- (NSURLSessionTask *)letaoSearchStoreWithIndex:(NSInteger)index
                                  pageSize:(NSInteger)pageSize
                                letaoSearchText:(NSString *)letaoSearchText
                                    source:(NSString * _Nonnull)source
                                   success:(void(^)(NSArray * _Nonnull storeArray, NSURLSessionTask * _Nonnull task))success
                                   failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (source) {
        [parameters setObject:source forKey:@"seller_type"];
    }
    if (letaoSearchText) {
        [parameters setObject:letaoSearchText forKey:@"search"];
    }
    return [XLTNetworkHelper GET:kSearchStoreUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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

- (NSURLSessionTask *)letaoRecommendStoreWithIndex:(NSInteger)index
                                     pageSize:(NSInteger)pageSize
                                       source:(NSString * _Nonnull)source
                                      success:(void(^)(NSArray * _Nonnull storeArray, NSURLSessionTask * _Nonnull task))success
                                      failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (source) {
        [parameters setObject:source forKey:@"seller_type"];
    }
    return [XLTNetworkHelper GET:kStoreRecommendUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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
