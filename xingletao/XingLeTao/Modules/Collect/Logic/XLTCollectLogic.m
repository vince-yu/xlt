//
//  XLTCollectLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCollectLogic.h"

@implementation XLTCollectLogic
- (void)xingletaonetwork_requestCollectDataSuccess:(void(^)(NSDictionary * _Nonnull collectInfo))success
                        failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kCollectListUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
           if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
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

- (void)xingletaonetwork_cancelCollectsWithCollectIds:(NSArray *)collectIds
               success:(void(^)(XLTBaseModel * _Nonnull model))success
               failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *ids = [collectIds componentsJoinedByString:@","];
    if (ids) {
        [parameters setObject:ids forKey:@"ids"];
    }
    [XLTNetworkHelper POST:kCollectCancelUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
           if ([model isCorrectCode]) {
                success(model);
               
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


- (NSURLSessionTask *)xingletaonetwork_goodsIsCollectWithGoodsId:(NSString *)goodsId
                            itemSource:(NSString *)itemSource
                               success:(void(^)(NSDictionary * _Nonnull info,NSURLSessionDataTask * task))success
                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"id"];
    }
    if (itemSource) {
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    return [XLTNetworkHelper GET:kGoodsIsCollectUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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


- (void)xingletaonetwork_collectGoodsWithId:(NSString *)letaoGoodsId
          itemSource:(NSString *)itemSource
             success:(void(^)(XLTBaseModel * _Nonnull model))success
             failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"id"];
    }
    if (itemSource) {
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    [XLTNetworkHelper POST:kCollectGoodslUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
           if ([model isCorrectCode]) {
                success(model);
               [MBProgressHUD letaoshowTipMessageInWindow:@"收藏成功"];
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

- (void)xingletaonetwork_cancelCollectWithGoodsId:(NSString *)letaoGoodsId
                itemSource:(NSString *)itemSource
                   success:(void(^)(XLTBaseModel * _Nonnull model))success
                   failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoGoodsId) {
        [parameters setObject:letaoGoodsId forKey:@"id"];
    }
    if (itemSource) {
        [parameters setObject:itemSource forKey:@"item_source"];
    }
    [XLTNetworkHelper POST:kCancelCollectGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
           if ([model isCorrectCode]) {
                success(model);
               [MBProgressHUD letaoshowTipMessageInWindow:@"取消成功"];
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


- (void)xingletaonetwork_requestCancelInvalidGoodsSuccess:(void(^)(XLTBaseModel * _Nonnull model))success
                                failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper POST:kCancelCollectInvalidGoodUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
           if ([model isCorrectCode]) {
                success(model);
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
- (void)xingletaonetwork_requestYouLikeGoodsDataWithIndex:(NSInteger)index
                              pageSize:(NSInteger)pageSize
                               success:(void(^)(NSArray *goodsArray))success
                             failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kGuessYouLikeGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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

@end
