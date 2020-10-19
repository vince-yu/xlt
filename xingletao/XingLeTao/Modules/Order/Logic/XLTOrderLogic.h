//
//  XLTOrderLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderLogic : XLTNetBaseLogic

//我的订单列表
- (NSURLSessionTask *)xingletaonetwork_requestOrdersWithIndex:(NSInteger)index
                                  pageSize:(NSInteger)pageSize
                                 yearMonth:(NSString * _Nullable)yearMonth
                                    source:(NSString * _Nullable)source
                                    status:(NSNumber * _Nullable)status
                                letaoSearchText:(NSString * _Nullable)letaoSearchText
                           retrieveOrderId:(NSString * _Nullable)retrieveOrderId
                                   success:(void(^)(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task))success
                                   failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

//找回订单
- (NSURLSessionTask *)findOrders:(NSArray *)orderIds
        success:(void(^)(NSDictionary * _Nonnull info, NSURLSessionTask * _Nonnull task))success
        failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

//领取订单返利
- (NSURLSessionTask *)rebatWithOrderId:(NSString *)orderId
success:(void(^)(NSDictionary * _Nonnull info, NSURLSessionTask * _Nonnull task))success
failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

//下单
- (NSURLSessionTask *)makeOrderWithGoodsId:(NSString *)letaoGoodsId
                                    source:(NSString * _Nullable)source
                                   success:(void(^)(NSString * _Nonnull info, NSURLSessionTask * _Nonnull task))success
                                   failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure ;


- (NSURLSessionTask *)xingletaonetwork_requestGroupOrdersWithIndex:(NSInteger)index
                                       pageSize:(NSInteger)pageSize
                                      yearMonth:(NSString * _Nullable)yearMonth
                                         source:(NSString * _Nullable)source
                                         status:(NSNumber * _Nullable)status
                                     letaoSearchText:(NSString * _Nullable)letaoSearchText
                                retrieveOrderId:(NSString * _Nullable)retrieveOrderId
                                        success:(void(^)(NSArray * _Nonnull orderArray, NSURLSessionTask * _Nonnull task))success
                                        failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;
@end

NS_ASSUME_NONNULL_END
