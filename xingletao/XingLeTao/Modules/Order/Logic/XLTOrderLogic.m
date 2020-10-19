//
//  XLTOrderLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTOrderLogic.h"
#import "FCUUID.h"
#import "AFNetworkReachabilityManager.h"
#import "XLTUserManager.h"
#import "AFHTTPSessionManager.h"
#import "XLTNetCommonParametersModel.h"
#import "XLTOrderListModel.h"
#import "NSString+XLTMD5.h"
#import "XLTLogManager.h"
#import <UTDID/UTDevice.h>

@implementation XLTOrderLogic

- (NSURLSessionTask *)xingletaonetwork_requestOrdersWithIndex:(NSInteger)index
                    pageSize:(NSInteger)pageSize
                    yearMonth:(NSString * _Nullable)yearMonth
                source:(NSString * _Nullable)source
                    status:(NSNumber * _Nullable)status
                 letaoSearchText:(NSString * _Nullable)letaoSearchText
                    retrieveOrderId:(NSString * _Nullable)retrieveOrderId
                    success:(void(^)(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task))success
                    failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (source) {
        [parameters setObject:source forKey:@"item_source"];
    }
    if (yearMonth) {
        [parameters setObject:yearMonth forKey:@"year_month"];
    }
    if (letaoSearchText) {
        [parameters setObject:letaoSearchText forKey:@"keyword"];
    }
    
    if (status) {
        [parameters setObject:status forKey:@"status"];
    }
    if (retrieveOrderId) {
        [parameters setObject:retrieveOrderId forKey:@"retrieve_order_id"];
    }
    
    return [XLTNetworkHelper GET:kOrderListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTOrderListModel class] json:model.data];
                success(letaoPageDataArray,task);
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

- (NSURLSessionTask *)findOrders:(NSArray *)orderIds
success:(void(^)(NSDictionary * _Nonnull info, NSURLSessionTask * _Nonnull task))success
                         failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (orderIds) {
        [parameters setObject:orderIds forKey:@"_id"];
    }
    
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    sessionManager.requestSerializer.timeoutInterval = NetWork_TimeoutInterval;
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSInteger dev_type = [[XLTNetCommonParametersModel defaultModel] dev_type];
    NSInteger client_type = [[XLTNetCommonParametersModel defaultModel] client_type];
    [sessionManager.requestSerializer setValue:[[NSNumber numberWithInteger:dev_type] stringValue] forHTTPHeaderField:@"dev-type"];
    [sessionManager.requestSerializer setValue:[[NSNumber numberWithInteger:client_type] stringValue] forHTTPHeaderField:@"client-type"];
    NSString *utdid = [UTDevice utdid];
    if (utdid) {
        [sessionManager.requestSerializer setValue:utdid forHTTPHeaderField:@"x-utdid"];
    }
    NSString *version =  [XLTNetCommonParametersModel defaultModel].version;
    [sessionManager.requestSerializer setValue:version forHTTPHeaderField:@"client-v"];
    NSString *token = [XLTUserManager shareManager].curUserInfo.token;
    if (token) {
        // 设置token
        [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    [sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"check-enable"];
    // udid
     
     NSString *udid =  [FCUUID uuidForDevice];
     if (udid) {
         [sessionManager.requestSerializer setValue:udid forHTTPHeaderField:@"x-m"];
     }
     
     NSString *appID =  [[XLTNetCommonParametersModel defaultModel] appID];
     if (appID) {
         [sessionManager.requestSerializer setValue:appID forHTTPHeaderField:@"x-appid"];
     }
     
     NSString *appName =  [[XLTNetCommonParametersModel defaultModel] appSource];
     if (appName) {
         [sessionManager.requestSerializer setValue:appName forHTTPHeaderField:@"x-app-source"];
     }
    NSString *url = kOrderSeekUrl;
    parameters = [XLTOrderLogic commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:url parameters:parameters];
    return [sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
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
    
   [self generateSecrtetWithParameters:parameters path:urlPath sessionManager:sessionManager];

    /*
    NSDictionary *commonParameters=  [[XLTNetWorkCommonParametersModel defaultModel] modelToJSONObject];
    if ([commonParameters isKindOfClass:[NSDictionary class]]){
        [result addEntriesFromDictionary:commonParameters];
    }
    
    // 修正dev_type参数为dev-type
//    NSNumber *dev_type
    [result removeObjectForKey:@"dev_type"];
    
    NSString *sign = [self generateSecrtetWithParameters:result];
    if (sign) {
        [result setObject:sign forKey:@"sign"];
    } */
    return result;
}

+ (NSString*)generateSecrtetWithParameters:(NSDictionary *)parameters path:(NSString *)path sessionManager:(AFHTTPSessionManager *)sessionManager{
//    if ([parameters isKindOfClass:[NSDictionary class]] && [parameters allValues].count > 0)
    {
        NSMutableString *resultStr  = [[NSMutableString alloc] initWithString:@""];
        NSArray *keys = [parameters allKeys];
        //排序
        NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        //拼接字符串
        for (NSString *key in sortedArray) {
            NSArray *ids = [parameters objectForKey:key];
            NSString *json = [ids modelToJSONString];
            NSString *modelToJSONString =  [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [resultStr appendFormat:@"%@=%@",key, modelToJSONString];

        }
        // 删除特殊字符
        resultStr = [resultStr letaomd5].mutableCopy;
        
        NSString *prefix = nil;
        if (resultStr.length > 5) {
            prefix = [NSString letaoSafeSubstring:resultStr toIndex:5];
        } else {
            prefix = [NSString stringWithFormat:@"%@",resultStr];
        }
        NSString *suffix = nil;
        if (resultStr.length > 5) {
            suffix = [NSString letaoSafeSubstring:resultStr fromReverseIndex:5];
        } else {
            suffix = [NSString stringWithFormat:@"%@",resultStr];
            
        }
        
        NSMutableString *signString = [NSMutableString string];
        [signString appendString:prefix];
        
        NSString *appID =  [[XLTNetCommonParametersModel defaultModel] appID];
        if (appID) {
            [signString appendString:appID];
        }
        if (path) {
            [signString appendString:path];
        }
        
        
        [signString appendString:resultStr];
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
        [signString appendString:timestamp];
        [signString appendString:suffix];
        
        NSString *appKey =  [[XLTNetCommonParametersModel defaultModel] appKey];
        if (appKey) {
            [signString appendString:appKey];
        }
        //得到MD5 sign签名
        NSString *md5Sign = [signString letaomd5];
        
        
        if (md5Sign) {
            [sessionManager.requestSerializer setValue:md5Sign forHTTPHeaderField:@"x-sign"];
        }
        [sessionManager.requestSerializer setValue:timestamp forHTTPHeaderField:@"x-timestamp"];
        return md5Sign;
    }
//    return nil;
}

- (NSURLSessionTask *)rebatWithOrderId:(NSString *)orderId
success:(void(^)(NSDictionary * _Nonnull info, NSURLSessionTask * _Nonnull task))success
                               failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (orderId) {
        [parameters setObject:orderId forKey:@"_id"];
    }
    return [XLTNetworkHelper POST:kOrderRebateUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
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

- (NSURLSessionTask *)makeOrderWithGoodsId:(NSString *)letaoGoodsId
                                    source:(NSString * _Nullable)source
                                   success:(void(^)(NSString * _Nonnull info, NSURLSessionTask * _Nonnull task))success
                                   failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"goods_id"];
    }
    if (source) {
        [parameters setObject:source forKey:@"item_source"];
    }
    return [XLTNetworkHelper POST:kGenOrderUrl parameters:parameters success:^(id    responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
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
//粉丝订单列表
- (NSURLSessionTask *)xingletaonetwork_requestGroupOrdersWithIndex:(NSInteger)index
                    pageSize:(NSInteger)pageSize
                    yearMonth:(NSString * _Nullable)yearMonth
                source:(NSString * _Nullable)source
                    status:(NSNumber * _Nullable)status
                 letaoSearchText:(NSString * _Nullable)letaoSearchText
                    retrieveOrderId:(NSString * _Nullable)retrieveOrderId
                    success:(void(^)(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task))success
                    failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (source) {
        [parameters setObject:source forKey:@"item_source"];
    }
    if (yearMonth) {
        [parameters setObject:yearMonth forKey:@"year_month"];
    }
    if (letaoSearchText) {
        [parameters setObject:letaoSearchText forKey:@"keyword"];
    }
    
    if (status) {
        [parameters setObject:status forKey:@"status"];
    }
    if (retrieveOrderId) {
        [parameters setObject:retrieveOrderId forKey:@"retrieve_order_id"];
    }
    
    return [XLTNetworkHelper GET:KGroupOrderListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTOrderListModel class] json:model.data];
                success(letaoPageDataArray,task);
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
