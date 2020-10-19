//
//  XLTShareFeedLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareFeedLogic.h"

@implementation XLTShareFeedLogic

+ (void)xingletaonetwork_requestChannelListSuccess:(void(^)(NSArray *channelArray))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kShareFeedChannelListUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                
                NSArray *dataArray = ((NSArray *)model.data);
                NSMutableArray *channelArray = [NSMutableArray array];
                [dataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *channelInfo = obj.mutableCopy;
                        [channelArray addObject:channelInfo];
                        NSNumber *ptype = obj[@"ptype"];
                        if (!([ptype isKindOfClass:[NSNumber class]] && [ptype integerValue] ==2)){
                            NSArray *categories_list = obj[@"categories_list"];
                            NSMutableArray *categoriesArray = [NSMutableArray array];
                            if ([categories_list isKindOfClass:[NSArray class]]) {
                                if (categories_list.count > 0) {
                                    [categoriesArray addObjectsFromArray:categories_list];
                                } else {
                                    [categoriesArray addObject:@{@"_id":@"0",@"title":@"全部"}];
                                }
                            }
                            channelInfo[@"categories_list"] = categoriesArray;
                        }
                    }
                    
                }];
                success(channelArray);
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


+ (void)repoClickWithId:(NSString *)itemId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (itemId) {
        [parameters setObject:itemId forKey:@"id"];
    }
    [XLTNetworkHelper GET:kShareFeedRepoClickUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
    }];
}



+ (NSURLSessionDataTask *)xingletaonetwork_requestShareFeedDataForIndex:(NSInteger)index
                                            pageSize:(NSInteger)pageSize
                                           channelId:(NSString*)channelId
                                             success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                             failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
        [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
        if (channelId) {
            [parameters setObject:channelId forKey:@"plate"];
        }

        return [XLTNetworkHelper GET:kShareFeedListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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


+ (NSURLSessionDataTask *)requestSchoolArticleListDataForIndex:(NSInteger)index
                                                      pageSize:(NSInteger)pageSize
                                                     channelId:(NSString  * _Nullable )channelId
                                                       success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                       failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
        [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
        if (channelId) {
            [parameters setObject:channelId forKey:@"category_id"];
        }

        return [XLTNetworkHelper GET:kSchoolArticleListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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


+ (NSURLSessionDataTask *)requestSchoolArticleSearchDataForIndex:(NSInteger)index
                                                        pageSize:(NSInteger)pageSize searchText:(NSString  * _Nullable )search
                                                               success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (search) {
        [parameters setObject:search forKey:@"search"];
    }

        return [XLTNetworkHelper GET:kSchoolArticleSearchUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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


+ (NSURLSessionDataTask *)requestSchoolHotCateWithCategory:(NSString *)categoryId success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                              failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
      if (categoryId) {
          [parameters setObject:categoryId forKey:@"category_id"];
      }
        return [XLTNetworkHelper GET:kSchoolHotCateUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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
