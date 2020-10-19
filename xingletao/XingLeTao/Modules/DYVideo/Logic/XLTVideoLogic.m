//
//  XLTVideoLogic.m
//  XingLeTao
//
//  Created by SNQU on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTVideoLogic.h"

@implementation XLTVideoLogic
//video 视频列表
+ (void)getVideoListWithCid:(NSString *)cid page:(NSString *)page row:(NSString *)row success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    if (!cid.length) {
        return;
    }
    [XLTNetworkHelper GET:kVideoListUrl parameters:@{@"page":page,@"row":row,@"cid":cid} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTVideoListModel class] json:model.data];
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
//video 视频分类
+ (void)getVideoCategarySuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kVideoCategaryUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTVideoCategaryModel class] json:model.data];
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



+ (NSURLSessionDataTask *)requestVideosDataForIndex:(NSInteger)index
                                           pageSize:(NSInteger)pageSize
                                          channelId:(NSString*)channelId
                                            success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                            failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (channelId) {
        [parameters setObject:channelId forKey:@"cid"];
    }

    return [XLTNetworkHelper GET:kVideoListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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
