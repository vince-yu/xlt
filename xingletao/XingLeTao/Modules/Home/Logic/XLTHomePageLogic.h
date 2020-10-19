//
//  XLTHomePageLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"
#import "XLTActivityModel.h"
#import "XLTHomePageModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface XLTHomePageLogic : XLTNetBaseLogic

// 推荐分类
+ (XLTHomeCategoryModel *)letaoDefualtCategory;
// 本地猜你喜欢分类
+ (XLTHomeCategoryModel *)letaoLocalGuessYouLikeCategory;
+ (NSString *)letaoLocalGuessYouLikeCategoryId;

// 首页布局数据
+ (void)requestHomePageDataSuccess:(void(^)(XLTHomePageModel *model))success
                           failure:(void(^)(NSString *errorMsg))failure;

// 首页布局缓存诗句
+ (XLTHomePageModel * _Nullable)localHomePageCacheData;

// 首页模块点击汇报【星乐桃】
+ (void)xinletaoRepoHomeModulClickWithId:(NSString *)itemId;


// 首页商品推荐数据
- (NSURLSessionTask *)requestHomeRecommendGoodsDataForIndex:(NSInteger)index
                                                   pageSize:(NSInteger)pageSize
                                                item_source:(NSString *)item_source
                                                    success:(void(^)(NSArray *goodArray,NSURLSessionDataTask * task))success
                                                    failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

// 首页每日推荐数据
- (void)xingletaonetwork_requestHomeDailyRecommendDataSuccess:(void(^)(NSArray *dailyRecommendArray))success
                                   failure:(void(^)(NSString *errorMsg))failure;



// 首页分类商品列表
- (NSURLSessionTask *)requestHomeCategoryGoodsListDataForIndex:(NSInteger)index
                                                      pageSize:(NSInteger)pageSize
                                                    categoryId:(NSString * _Nullable )categoryId
                                                          sort:(NSString  * _Nullable  )sort
                                                        source:(NSString  * _Nullable )source
                                                       postage:(NSNumber  * _Nullable )postage
                                                    startPrice:(NSNumber  * _Nullable )startPrice
                                                      endPrice:(NSNumber  * _Nullable )endPrice
                                                  letaoStoreId:(NSString * _Nullable)letaoStoreId
                                                     hasCoupon:(BOOL)hasCoupon
                                                       success:(void(^)(NSArray *goodsArray,NSURLSessionDataTask * task))success
                                                       failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;


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
                                                   failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;



// 首页Plate分类数据
- (void)xingletaonetwork_requestHomePlateDataForPlateId:(NSString*)letaoCurrentPlateId
                             success:(void(^)(NSArray *plateArray))success
                             failure:(void(^)(NSString *errorMsg))failure;

- (void)xingletaonetwork_requestPlateFilterOptionsWithPlateId:(NSString*)letaoCurrentPlateId
                                   success:(void(^)(NSDictionary *filterInfo))success
                                   failure:(void(^)(NSString *errorMsg))failure;


- (void)xingletaonetwork_requestPlateNextCategoryListWithPlateId:(NSString*)letaoCurrentPlateId
                                         level:(NSNumber *)level
                                       success:(void(^)(NSArray *plateArray))success
                                       failure:(void(^)(NSString *errorMsg))failure;
//原生活动页
+ (void)xingletaonetwork_requestActivityCode:(NSString*)codeId
                                     success:(void(^)(XLTActivityModel *model))success
                                     failure:(void(^)(NSString *errorMsg))failure;


// 9.9包邮新板块

+ (void)requestNineYuanNineListWithId:(NSString*)nine_cid
                          item_source:(NSString *)item_source
                            pageIndex:(NSInteger)index
                             pageSize:(NSInteger)pageSize
                              success:(void(^)(NSArray *goodArray))success
                              failure:(void(^)(NSString *errorMsg))failure;



/**
 * 猜你喜欢-sndo
 */
+ (void)requestSndoHomeGuessYouLikeWithIndex:(NSInteger)index
                                    pageSize:(NSInteger)pageSize
                                     success:(void(^)(NSArray *goodArray))success
                                     failure:(void(^)(NSString *errorMsg))failure;

/**
 * 猜你喜欢-taobap
*/
+ (void)requestTaobaoHomeGuessYouLikeWithIndex:(NSInteger)index
                                      pageSize:(NSInteger)pageSize
                                       success:(void(^)(NSArray *goodArray))success
                                       failure:(void(^)(NSString *errorMsg))failure;

@end
NS_ASSUME_NONNULL_END
