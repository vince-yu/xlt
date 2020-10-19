//
//  XLTStreetLogic.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDStreetLogic.h"
#import "XLTNetworkHelper.h"
#import "XLTBaseModel.h"
#import "XLTTipConstant.h"
#import "NSObject+YYModel.h"
#import "XLTBigVModel.h"

@implementation XLDStreetLogic
//大V主页
+ (void)xingletaonetwork_requestBigVHomeWithSourece:(NSString *)itemSource vid:(NSString *)vid sort:(NSString *)sortStr success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (itemSource.length) {
        [dic setObject:itemSource forKey:@"item_source"];
    }
    if (sortStr.length) {
        [dic setObject:sortStr forKey:@"sort"];
    }
    if (vid.length) {
        [dic setObject:vid forKey:@"certified_id"];
    }
    [XLTNetworkHelper GET:kStreetBigVHome parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                id resut = [XLTBigVModel modelWithDictionary:model.data];
                success(resut);
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
//大V主页商品
+ (NSURLSessionTask *)xingletaonetwork_requestBigVHomeGoodsWithIndex:(NSInteger)index
                         pageSize:(NSInteger)pageSize
                          sourece:(NSString * _Nullable)itemSource vid:(NSString * _Nullable)vid sort:(NSString * _Nullable)sortStr postage:(NSNumber * _Nullable)post
                                                          startPrice:(NSNumber  * _Nullable )startPrice
                                                            endPrice:(NSNumber  * _Nullable )endPrice success:(void(^)(NSArray  * _Nonnull goodArray, NSURLSessionDataTask *task))success failure:(void(^)(NSString *errorMsg, NSURLSessionDataTask *task))failure {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (itemSource) {
        [dic setObject:itemSource forKey:@"item_source"];
    }
    if (sortStr) {
        [dic setObject:sortStr forKey:@"sort"];
    }
    if (vid) {
        [dic setObject:vid forKey:@"certified_id"];
    }
    if (post) {
        [dic setObject:post forKey:@"postage"];
    }
    if (startPrice) {
        [dic setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [dic setObject:endPrice forKey:@"end_price"];
    }

    return [XLTNetworkHelper GET:kStreetBigVHomeGoodList parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error,task);
    }];
}
//大V列表
+ (void)xingletaonetwork_requestBigVListWithIndex:(NSInteger)index
                    pageSize:(NSInteger)pageSize
                     success:(void(^)(NSArray * _Nonnull daVArray))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kStreetBigVList parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
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
//爆款分类
+ (void)xingletaonetwork_requestRedCateListSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kStreetRedCateList parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithObjects:[XLDStreetLogic letaoDefualtCategory], nil];
                
                [model.data enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        XLTHomeCategoryModel *category = [XLTHomeCategoryModel modelWithDictionary:obj];
                        [categoryArray addObject:category];
                    }
                }];
                success(categoryArray);
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
//爆款商品列表
+ (NSURLSessionDataTask *)xingletaonetwork_requestRedGoodsListWithIndex:(NSInteger)index
                                                               pageSize:(NSInteger)pageSize
                                                                sourece:(NSString * _Nullable)itemSource sign:(NSString * _Nullable)sign
                                                             categoryId:(NSString * _Nullable)categoryId
                                                                postage:(NSNumber * _Nullable)post t:(NSString * _Nullable)t
                                                             startPrice:(NSNumber  * _Nullable )startPrice
                                                               endPrice:(NSNumber  * _Nullable )endPrice
                                                                success:(void(^)(id goodArray,NSURLSessionDataTask *task))success
                                                                failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask *task))failure {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    if (itemSource.length) {
        [dic setObject:itemSource forKey:@"item_source"];
    }
    if (sign.length) {
        [dic setObject:sign forKey:@"sign"];
    }
    if (categoryId.length) {
        [dic setObject:categoryId forKey:@"category_id"];
    }
    if (post) {
        [dic setObject:post forKey:@"postage"];
    }
    if (t.length) {
        [dic setObject:t forKey:@"_t"];
    }
    if (startPrice) {
        [dic setObject:startPrice forKey:@"start_price"];
    }
    
    if (endPrice) {
        [dic setObject:endPrice forKey:@"end_price"];
    }
    return [XLTNetworkHelper GET:kStreetRedGoodList parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error,task);
    }];
}
//获取好物说
+ (void)xingletaonetwork_requestGoodItemWithIndex:(NSInteger)index
                    pageSize:(NSInteger)pageSize
                     success:(void(^)(NSArray * _Nonnull goodsArray))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kStreetGoodItemList parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
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
//获取网红店铺列表
+ (void)xingletaonetwork_requestRedShopListWithIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(void(^)(NSArray *shopArray))success
                        failure:(void(^)(NSString *errorMsg))failure{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    [XLTNetworkHelper GET:kStreetShopList parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
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

+ (XLTHomeCategoryModel *)letaoDefualtCategory {
    XLTHomeCategoryModel *defualtCategory = [[XLTHomeCategoryModel alloc] init];
    defualtCategory.name = @"全部";
    defualtCategory._id = @"0";
    return defualtCategory;
}
@end
