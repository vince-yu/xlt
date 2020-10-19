//
//  XLTGoodsDetailLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsDetailLogic : XLTNetBaseLogic

// 商品详情数据[第一部分]
- (NSURLSessionTask *)xingletaonetwork_requestGoodsDetailDataWithPlate:(NSString * _Nullable)plate
                                                     category:(NSString * _Nullable)category
                                                 letaoGoodsId:(NSString *)letaoGoodsId
                                                      item_id:(NSString * _Nullable)item_id
                                                      user_id:(NSString * _Nullable)user_id
                                                   itemSource:(NSString *)itemSource
                                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                                      success:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                                                      failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

// 商品详情数据[第二部分]
- (NSURLSessionTask *)xingletaonetwork_requestGoodsDescDataWithPlate:(NSString * _Nullable)plate
                                              category:(NSString * _Nullable)category
                                               goodsId:(NSString *)goodsId
                                               item_id:(NSString * _Nullable)item_id
                                               user_id:(NSString * _Nullable)user_id
                                            itemSource:(NSString *)itemSource
                                               success:(void(^)(XLTBaseModel *goodsDetail,NSURLSessionDataTask * task))success
                                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

// 店铺推荐商品
- (void)xingletaonetwork_requestStoreRecommendGoodsDataWithStoreId:(NSString * _Nullable)letaoStoreId
                                        letaoGoodsId:(NSString * _Nullable)letaoGoodsId
                                     itemSource:(NSString *)itemSource
                                        success:(void(^)(NSArray *goodsArray))success
                                        failure:(void(^)(NSString *errorMsg))failure ;

// 推荐商品
- (void)xingletaonetwork_requestGoodsRecommenDataWithGoodsId:(NSString *)letaoGoodsId
                               itemSource:(NSString *)itemSource
                                  success:(void(^)(NSArray *goodsArray))success
                                  failure:(void(^)(NSString *errorMsg))failure;


// 猜你喜欢
- (void)xingletaonetwork_requestYouLikeGoodsDataSuccess:(void(^)(NSArray *goodsArray))success
                             failure:(void(^)(NSString *errorMsg))failure;






// 转链商品接口
- (void)xingletaonetwork_requestGoodsJumpUrlDataWithGoodsId:(NSString *)letaoGoodsId
                                                 itemSource:(NSString *)itemSource
                                       isAliCommandTextOnly:(BOOL)isAliCommandTextOnly
                                                    success:(void(^)(XLTBaseModel *model, BOOL isAliCommandTextOnly))success
                                                    failure:(void(^)(NSString *errorMsg))failure;
// 是否是阿里要求授权code
+ (BOOL)letaoIsNeedAliAuthorizationCode:(XLTBaseModel *)model;

// 是否是拼多多要求授权code
+ (BOOL)letaoIsNeedPDDAuthorizationCode:(XLTBaseModel *)model;
// 淘宝口令
/*
- (void)xingletaonetwork_requestAliCommandTextActionWithGoodsId:(NSString *)letaoGoodsId
                                     success:(void(^)(NSString *commandText))success
                                     failure:(void(^)(NSString *errorMsg))failure;*/

// 商品浏览记录

- (void)letaoIsAddBrowsingHistoWithId:(NSString *)letaoGoodsId
                                itemSource:(NSString *)itemSource;

// 获取商品推荐语
+ (void)requestEditorsRecommendWithGoodsId:(NSString *)letaoGoodsId
                                itemSource:(NSString *)itemSource
                                    success:(void(^)(XLTBaseModel *model))success
                                    failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
