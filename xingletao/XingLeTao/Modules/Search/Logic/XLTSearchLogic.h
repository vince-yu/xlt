//
//  XLTSearchLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTSearchLogic : XLTNetBaseLogic
- (void)xingletaonetwork_xingletaonetwork_requestHotKeyWordsDataDataSuccess:(void(^)(NSArray *hotKeyWordsArray))success
                            failure:(void(^)(NSString *errorMsg))failure;

- (void)xingletaonetwork_xingletaonetwork_requestSearchSuggestionDataWithInputText:(NSString *)text
                                   success:(void(^)(NSArray * _Nonnull suggestionArray))success
                                   failure:(void(^)(NSString *errorMsg))failure;
- (void)letaoCancelSearchSuggestionTask;


- (NSURLSessionTask *)letaoRepoKeyWordsClickedWithId:(NSString *)hotId
                           success:(void(^)(NSArray * _Nonnull goodsArray))success
                           failure:(void(^)(NSString *errorMsg))failure;


- (NSURLSessionTask *)letaoSearchGoodsWithIndex:(NSInteger)index
                                       pageSize:(NSInteger)pageSize
                                           sort:(NSString * _Nonnull)sort
                                         source:(NSString * _Nonnull)source
                                        postage:(NSNumber *)postage
                                      hasCoupon:(BOOL)hasCoupon
                                letaoSearchText:(NSString * _Nonnull)letaoSearchText
                                   letaoGoodsId:(NSString * _Nonnull)letaoGoodsId
                                     startPrice:(NSNumber  * _Nullable )startPrice
                                       endPrice:(NSNumber  * _Nullable )endPrice
                                        success:(void(^)(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task))success
                                        failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

// 剪贴板搜索
- (NSURLSessionTask *)letaoPasteboardSearchGoodsWithIndex:(NSInteger)index
                                            pageSize:(NSInteger)pageSize
                                                sort:(NSString * _Nonnull)sort
                                              source:(NSString * _Nonnull)source
                                             postage:(NSNumber *)postage
                                           hasCoupon:(BOOL)hasCoupon
                                          letaoSearchText:(NSString * _Nonnull)letaoSearchText
                                             letaoGoodsId:(NSString * _Nonnull)letaoGoodsId
                                               startPrice:(NSNumber  * _Nullable )startPrice
                                                 endPrice:(NSNumber  * _Nullable )endPrice
                                             success:(void(^)(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task))success
                                             failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

- (NSURLSessionTask *)letaorecommendGoodsWithIndex:(NSInteger)index
                                          pageSize:(NSInteger)pageSize
                                              sort:(NSString * _Nonnull)sort
                                            source:(NSString * _Nonnull)source
                                           postage:(NSNumber *)postage
                                         hasCoupon:(BOOL)hasCoupon
                                   letaoSearchText:(NSString * _Nonnull)letaoSearchText
                                      letaoGoodsId:(NSString * _Nonnull)letaoGoodsId
                                        startPrice:(NSNumber  * _Nullable )startPrice
                                          endPrice:(NSNumber  * _Nullable )endPrice
                                           success:(void(^)(NSArray * _Nonnull goodsArray, NSURLSessionTask * _Nonnull task))success
                                           failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;


- (NSURLSessionTask *)letaoSearchStoreWithIndex:(NSInteger)index
                                  pageSize:(NSInteger)pageSize
                                letaoSearchText:(NSString *)letaoSearchText
                                    source:(NSString * _Nonnull)source
                                   success:(void(^)(NSArray * _Nonnull storeArray, NSURLSessionTask * _Nonnull task))success
                                   failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

- (NSURLSessionTask *)letaoRecommendStoreWithIndex:(NSInteger)index
                                     pageSize:(NSInteger)pageSize
                                       source:(NSString * _Nonnull)source
                                      success:(void(^)(NSArray * _Nonnull storeArray, NSURLSessionTask * _Nonnull task))success
                                      failure:(void(^)(NSString *errorMsg, NSURLSessionTask * _Nonnull task))failure;

@end

NS_ASSUME_NONNULL_END
