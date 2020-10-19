//
//  XLTHomePageLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomePageLogic.h"


@implementation XLTHomePageLogic

+ (XLTHomePageModel * _Nullable)localHomePageCacheData {
    NSDictionary *responseCache = [XLTNetworkCache httpCacheForURL:kHomePagesLayoutUrl parameters:nil];
    if ([responseCache isKindOfClass:[NSDictionary class]]) {
        NSDictionary *cacheInfo = responseCache;
        NSDictionary *pageInfo = cacheInfo[@"data"];
        if ([pageInfo isKindOfClass:[NSDictionary class]] && pageInfo.count > 0) {
            XLTHomePageModel *pageModel =  [[XLTHomePageModel alloc] initWithPageInfo:pageInfo];
            pageModel.isLocalCacheData = YES;
            return pageModel;
        }
    }
    return nil;
}

+ (void)requestHomePageDataSuccess:(void(^)(XLTHomePageModel *model))success
                           failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kHomePagesLayoutUrl parameters:nil responseCache:^(id responseCache) {
        // do noting
    } success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                XLTHomePageModel *pageModel =  [[XLTHomePageModel alloc] initWithPageInfo:model.data];
                success(pageModel);
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


// 首页模块点击汇报【星乐桃】
+ (void)xinletaoRepoHomeModulClickWithId:(NSString *)itemId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"_id"] = itemId;
    [XLTNetworkHelper GET:@"v3/home-page/click" parameters:parameters success:nil failure:nil];
}



+ (XLTHomeCategoryModel *)letaoDefualtCategory {
    XLTHomeCategoryModel *defualtCategory = [[XLTHomeCategoryModel alloc] init];
    defualtCategory.name = @"推荐";
    defualtCategory._id = @"0";
    return defualtCategory;
}


+ (NSString *)letaoLocalGuessYouLikeCategoryId {
    return @"LocalCategory_GuessYouLike";
}

+ (XLTHomeCategoryModel *)letaoLocalGuessYouLikeCategory {
    XLTHomeCategoryModel *defualtCategory = [[XLTHomeCategoryModel alloc] init];
    defualtCategory.name = @"猜你喜欢";
    defualtCategory._id = [self letaoLocalGuessYouLikeCategoryId];
    return defualtCategory;
}


- (NSURLSessionTask *)requestHomeRecommendGoodsDataForIndex:(NSInteger)index
                                     pageSize:(NSInteger)pageSize
                                  item_source:(NSString *)item_source
                                      success:(void(^)(NSArray *goodArray,NSURLSessionDataTask * task))success
                              failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"source_type"] = @[@"1",@"4"];
    parameters[@"tid"] = @"layouts_index";
    parameters[@"item_source"] = item_source;
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    return [XLTNetworkHelper GET:kV3GoodListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSArray class]]) {
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


// 首页每日推荐数据
- (void)xingletaonetwork_requestHomeDailyRecommendDataSuccess:(void(^)(NSArray *dailyRecommendArray))success
                                   failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper POST:kHomeDailyRecommendUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
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

// 首页分类商品列表
- (NSURLSessionTask *)requestHomeCategoryGoodsListDataForIndex:(NSInteger)index
                                                      pageSize:(NSInteger)pageSize
                                                    categoryId:(NSString *)categoryId
                                                          sort:(NSString * )sort
                                                        source:(NSString *)source
                                                       postage:(NSNumber *)postage
                                                    startPrice:(NSNumber  * _Nullable )startPrice
                                                      endPrice:(NSNumber  * _Nullable )endPrice
                                                  letaoStoreId:(NSString * _Nullable)letaoStoreId
                                                     hasCoupon:(BOOL)hasCoupon
                                                       success:(void(^)(NSArray *goodsArray,NSURLSessionDataTask * task))success
                                                        failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    
    if (letaoStoreId) {
        [parameters setObject:letaoStoreId forKey:@"tid"];
         parameters[@"source_type"] = @[@"1",@"6"];
    }
    
    if (categoryId) {
        [parameters setObject:categoryId forKey:@"tid"];
         parameters[@"source_type"] = @[@"1",@"2"];
    }
    
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
    if (letaoStoreId) {
        [parameters setObject:letaoStoreId forKey:@"seller_shop_id"];
    }
    
    if (startPrice) {
        [parameters setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [parameters setObject:endPrice forKey:@"end_price"];
    }
   
    
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

// 首页板块商品列表
- (NSURLSessionTask *)requestHomePlateGoodsListDataForIndex:(NSInteger)index
                                                  pageSize:(NSInteger)pageSize
                                                      sort:(NSString  * _Nullable  )sort
                                                    source:(NSString  * _Nullable )source
                                                   postage:(NSNumber  * _Nullable )postage
                                                startPrice:(NSNumber  * _Nullable )startPrice
                                                  endPrice:(NSNumber  * _Nullable )endPrice
                                              letaoStoreId:(NSString * _Nullable)letaoStoreId
                                                 hasCoupon:(BOOL)hasCoupon
                                                     plate:(NSString  * _Nullable )plate
                                                   success:(void(^)(NSArray *goodsArray,NSURLSessionDataTask * task))success
                                                   failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (plate) {
        [parameters setObject:plate forKey:@"tid"];
    }
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
    if (letaoStoreId) {
        [parameters setObject:letaoStoreId forKey:@"seller_shop_id"];
    }
    
    if (startPrice) {
        [parameters setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [parameters setObject:endPrice forKey:@"end_price"];
    }
    parameters[@"source_type"] = @[@"1",@"3"];
    
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
// 首页Plate分类数据
- (void)xingletaonetwork_requestHomePlateDataForPlateId:(NSString*)letaoCurrentPlateId
                             success:(void(^)(NSArray *plateArray))success
                             failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoCurrentPlateId) {
        [parameters setObject:letaoCurrentPlateId forKey:@"pid"];
    }
    [XLTNetworkHelper GET:kHomePlateListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
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

- (void)xingletaonetwork_requestPlateFilterOptionsWithPlateId:(NSString*)letaoCurrentPlateId
                                   success:(void(^)(NSDictionary *filterInfo))success
                                   failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoCurrentPlateId) {
        [parameters setObject:letaoCurrentPlateId forKey:@"id"];
    }
    [XLTNetworkHelper GET:kHomePlateFilterOptionsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSDictionary class]]) {
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


- (void)xingletaonetwork_requestPlateNextCategoryListWithPlateId:(NSString*)letaoCurrentPlateId
                                          level:(NSNumber *)level
                                        success:(void(^)(NSArray *plateArray))success
                                        failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (letaoCurrentPlateId) {
        [parameters setObject:letaoCurrentPlateId forKey:@"pid"];
    }
    if (level) {
        [parameters setObject:level forKey:@"level"];
    }
    [parameters setObject:@1 forKey:@"need_three"];

    [XLTNetworkHelper GET:kCategorysUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSArray class]]) {
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
//原生活动页
+ (void)xingletaonetwork_requestActivityCode:(NSString*)codeId
                                     success:(void(^)(XLTActivityModel *model))success
                                     failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (codeId.length) {
        [parameters setObject:codeId forKey:@"code"];
    }

    [XLTNetworkHelper GET:kActivityUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSDictionary class]]) {
                XLTActivityModel *ac = [XLTActivityModel modelWithDictionary:model.data];
                ac.data = model.data;
                success(ac);
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


// 9.9包邮新板块

+ (void)requestNineYuanNineListWithId:(NSString*)nine_cid
                          item_source:(NSString *)item_source
                            pageIndex:(NSInteger)index
                             pageSize:(NSInteger)pageSize
                              success:(void(^)(NSArray *goodArray))success
                              failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"source_type"] = @[@"1",@"4"];
    parameters[@"tid"] = @"recommend_nine_p_nine";
    parameters[@"item_source"] = item_source;
    parameters[@"nine_cid"] = nine_cid;
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kV3GoodListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSArray class]]) {
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


/**
 * 猜你喜欢-sndo
 */
+ (void)requestSndoHomeGuessYouLikeWithIndex:(NSInteger)index
                                    pageSize:(NSInteger)pageSize
                                     success:(void(^)(NSArray *goodArray))success
                                     failure:(void(^)(NSString *errorMsg))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"source_type"] = @[@"1",@"9"];
    parameters[@"tid"] = @"1";
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kV3GoodListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSArray class]]) {
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

/**
 * 猜你喜欢-taobap
*/
+ (void)requestTaobaoHomeGuessYouLikeWithIndex:(NSInteger)index
                                      pageSize:(NSInteger)pageSize
                                       success:(void(^)(NSArray *goodArray))success
                                       failure:(void(^)(NSString *errorMsg))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"item_source"] = XLTTaobaoPlatformIndicate;
    parameters[@"source_type"] = @[@"1",@"7"];
    parameters[@"tid"] = @"1";
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kV3GoodListUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]
                && [model.data isKindOfClass:[NSArray class]]) {
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
