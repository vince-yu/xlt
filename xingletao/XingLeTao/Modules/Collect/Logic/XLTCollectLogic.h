//
//  XLTCollectLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTCollectLogic : XLTNetBaseLogic
- (void)xingletaonetwork_requestCollectDataSuccess:(void(^)(NSDictionary * _Nonnull collectInfo))success
                        failure:(void(^)(NSString *errorMsg))failure;
//取消收藏
- (void)xingletaonetwork_cancelCollectsWithCollectIds:(NSArray *)collectIds
               success:(void(^)(XLTBaseModel * _Nonnull model))success
               failure:(void(^)(NSString *errorMsg))failure;
//收藏商品
- (void)xingletaonetwork_collectGoodsWithId:(NSString *)letaoGoodsId
          itemSource:(NSString *)itemSource
             success:(void(^)(XLTBaseModel * _Nonnull model))success
             failure:(void(^)(NSString *errorMsg))failure;

//是否收藏
- (NSURLSessionTask *)xingletaonetwork_goodsIsCollectWithGoodsId:(NSString *)goodsId
                            itemSource:(NSString *)itemSource
                               success:(void(^)(NSDictionary * _Nonnull info,NSURLSessionDataTask * task))success
                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

- (void)xingletaonetwork_cancelCollectWithGoodsId:(NSString *)letaoGoodsId
                itemSource:(NSString *)itemSource
                   success:(void(^)(XLTBaseModel * _Nonnull model))success
                   failure:(void(^)(NSString *errorMsg))failure;


- (void)xingletaonetwork_requestCancelInvalidGoodsSuccess:(void(^)(XLTBaseModel * _Nonnull model))success
                                failure:(void(^)(NSString *errorMsg))failure;


// 猜你喜欢
- (void)xingletaonetwork_requestYouLikeGoodsDataWithIndex:(NSInteger)index
                              pageSize:(NSInteger)pageSize
                               success:(void(^)(NSArray *goodsArray))success
                               failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
