//
//  XLTStreetLogic.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTHomePageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLDStreetLogic : NSObject
//大V主页
+ (void)xingletaonetwork_requestBigVHomeWithSourece:(NSString *)itemSource vid:(NSString *)vid sort:(NSString *)sortStr success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//大V主页商品
+ (NSURLSessionTask *)xingletaonetwork_requestBigVHomeGoodsWithIndex:(NSInteger)index
                                       pageSize:(NSInteger)pageSize
                                        sourece:(NSString * _Nullable)itemSource vid:(NSString * _Nullable)vid sort:(NSString * _Nullable)sortStr postage:(NSNumber * _Nullable)post
                                                             startPrice:(NSNumber  * _Nullable )startPrice
                                                             endPrice:(NSNumber  * _Nullable )endPrice
                                                             success:(void(^)(NSArray  * _Nonnull goodArray, NSURLSessionDataTask *task))success failure:(void(^)(NSString *errorMsg, NSURLSessionDataTask *task))failure;
//大V列表
+ (void)xingletaonetwork_requestBigVListWithIndex:(NSInteger)index
                    pageSize:(NSInteger)pageSize
                     success:(void(^)(NSArray * _Nonnull daVArray))success failure:(void(^)(NSString *errorMsg))failure;
//爆款分类
+ (void)xingletaonetwork_requestRedCateListSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//爆款商品列表
+ (NSURLSessionDataTask *)xingletaonetwork_requestRedGoodsListWithIndex:(NSInteger)index
                                                               pageSize:(NSInteger)pageSize
                                                                sourece:(NSString * _Nullable)itemSource
                                                                   sign:(NSString * _Nullable)sign
                                                             categoryId:(NSString * _Nullable)categoryId
                                                                postage:(NSNumber * _Nullable)post t:(NSString * _Nullable)t
                                                             startPrice:(NSNumber  * _Nullable )startPrice
                                                               endPrice:(NSNumber  * _Nullable )endPrice
                                                                success:(void(^)(id goodArray,NSURLSessionDataTask *task))success
                                                                failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask *task))failure;
//获取好物说
+ (void)xingletaonetwork_requestGoodItemWithIndex:(NSInteger)index
                    pageSize:(NSInteger)pageSize
                     success:(void(^)(NSArray * _Nonnull goodsArray))success failure:(void(^)(NSString *errorMsg))failure ;
//获取网红店铺列表
+ (void)xingletaonetwork_requestRedShopListWithIndex:(NSInteger)index
                       pageSize:(NSInteger)pageSize
                        success:(void(^)(NSArray *shopArray))success
                        failure:(void(^)(NSString *errorMsg))failure;


+ (XLTHomeCategoryModel *)letaoDefualtCategory;
@end

NS_ASSUME_NONNULL_END
