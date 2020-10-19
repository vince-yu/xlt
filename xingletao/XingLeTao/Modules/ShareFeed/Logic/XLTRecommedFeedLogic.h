//
//  XLTRecommedFeedLogic.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"
#import "XLTMyRewardListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLTGoodsRecommendFeedStyle) {
    XLTGoodsRecommendFeedStyle_Unknow = -1,
    XLTGoodsRecommendFeedStyle_Hidden = 0,
    XLTGoodsRecommendFeedStyle_Enabled = 1 ,
    XLTGoodsRecommendFeedStyle_Disabled = 2,
    XLTGoodsRecommendFeedStyle_Recommend = 3,
};

@interface XLTRecommedFeedLogic : XLTNetBaseLogic

+ (NSURLSessionTask *)requestGoodsCanRecommend:(NSString *)goodsId
                      itemSource:(NSString *)itemSource
                         success:(void(^)(XLTBaseModel *model,NSURLSessionDataTask * task))success
                         failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

+ (NSURLSessionDataTask *)uploadFeedImageData:(NSData *)fileData
                                      success:(void(^)(NSDictionary *info))success
                                      failure:(void(^)(NSString *errorMsg))failure;
+ (NSURLSessionDataTask *)uploadFeedFileType:(NSString *)fileType
                                    filePath:(NSString *)filePath
                                     success:(void(^)(NSDictionary *info))success
                                     failure:(void(^)(NSString *errorMsg))failure;

+ (void)recommendGoods:(NSString *)goodsId
            itemSource:(NSString *)itemSource
                itemId:(NSString *)itemId
             imageUrls:(NSArray *)imageUrls
           contentText:(NSString *)contentText
              tomorrow:(NSString *)tomorrow
               success:(void(^)(NSDictionary *stateInfo))success
               failure:(void(^)(NSString *errorMsg))failure;
//删除我的推荐
+ (void)deleteMyRecommendWithId:(NSString *)recm_uid
                        success:(void(^)(NSArray *stateInfo))success
                        failure:(void(^)(NSString *errorMsg))failure;
/*
 获取我推荐的商品列表
 sort 排序 order_count reward_amount itime
 stauts 筛选类型 1 成功 2 审核失败
 date 筛选时间 精确到月份 2020-06
 */
+ (void)getMyRecommendListPage:(NSString *)page
                            row:(NSString *)row
                           sort:(nullable NSString *)sort
                         status:(nullable NSString *)stauts
                           date:(nullable NSString *)date
                        success:(void(^)(NSArray *stateInfo))success
                        failure:(void(^)(NSString *errorMsg))failure;
/*
 获取我推荐的奖励记录
 */
+ (void)getMyRewardListPage:(NSString *)page
                        row:(NSString *)row
                    success:(void(^)(NSArray *stateInfo))success
                    failure:(void(^)(NSString *errorMsg))failure;
/*
 获取我推荐的奖励信息
 */
+ (void)getMyRewardInfoSuccess:(void(^)(XLTMyRewardInfoModel *stateInfo))success
                       failure:(void(^)(NSString *errorMsg))failure;


+ (NSURLSessionDataTask *)requeFeedRecommedRankingListDataForIndex:(NSInteger)index
                                                          pageSize:(NSInteger)pageSize
                                                        rankingType:(NSString*)rankingType
                                                           success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                           failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
@end

NS_ASSUME_NONNULL_END
