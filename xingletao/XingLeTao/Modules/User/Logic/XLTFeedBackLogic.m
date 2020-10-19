//
//  XLTFeedBackLogic.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackLogic.h"
#import "AFHTTPSessionManager.h"

@implementation XLTFeedBackLogic
// list
+ (NSURLSessionDataTask *)requestFeedBackListDataForIndex:(NSInteger)index
                                                pageSize:(NSInteger)pageSize
                                                success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                  failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    parameters[@"sort"] = @"-itime";
    return [XLTNetworkHelper GET:kFeedBackListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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



+ (NSURLSessionDataTask *)requestFeedBackDetailWitdhId:(NSString *)feedId
                                                success:(void(^)(NSDictionary *info,NSURLSessionDataTask * task))success
                                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = feedId;
    return [XLTNetworkHelper GET:kFeedBackDetailUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
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
+ (NSURLSessionDataTask *)requestCustomerServiceSuccess:(void(^)(NSDictionary *info,NSURLSessionDataTask * task))success
                                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    return [XLTNetworkHelper GET:@"config/kefu" parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
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


+ (NSURLSessionDataTask *)uploadFeedBackImageData:(NSData *)fileData
                                          success:(void(^)(NSDictionary *info))success
                                          failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"save_type"] = @"images";
    
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    sessionManager.requestSerializer.timeoutInterval = 60*2;

    NSString *url = @"v2/feedback/upfile";
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    
    return [sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"files" fileName:@"feedback.jpg" mimeType:@"image/jpg"];
        
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

+ (NSURLSessionDataTask *)uploadFeedBackFileType:(NSString *)fileType
                                        filePath:(NSString *)filePath
                                         success:(void(^)(NSDictionary *info))success
                                         failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"save_type"] = fileType;
    
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    sessionManager.requestSerializer.timeoutInterval = 60*2;

    NSString *url = @"v2/feedback/upfile";
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

+ (NSURLSessionDataTask *)feedBackWithPhone:(NSString * _Nullable)phone
                                    log_url:(NSString *)log_url
                                    content:(NSString *)content
                                  enclosure:(NSArray *)enclosure
                                    success:(void(^)(NSDictionary *info,NSURLSessionDataTask * task))success
                                    failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = phone;
    parameters[@"log_url"] = log_url;
    parameters[@"content"] = content;
    parameters[@"enclosure"] = enclosure;
    return [XLTNetworkHelper POST:kFeedBackUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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



@end
