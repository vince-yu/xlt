//
//  XLTShareFeedLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTShareFeedLogic : XLTNetBaseLogic

+ (void)xingletaonetwork_requestChannelListSuccess:(void(^)(NSArray *channelArray))success failure:(void(^)(NSString *errorMsg))failure;


+ (NSURLSessionDataTask *)xingletaonetwork_requestShareFeedDataForIndex:(NSInteger)index
                                            pageSize:(NSInteger)pageSize
                                           channelId:(NSString*)channelId
                                             success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                             failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

+ (void)repoClickWithId:(NSString *)itemId;


// 商学院文章列表
+ (NSURLSessionDataTask *)requestSchoolArticleListDataForIndex:(NSInteger)index
                                                      pageSize:(NSInteger)pageSize
                                                     channelId:(NSString  * _Nullable )channelId
                                                       success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                       failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
// 商学院文章搜索
+ (NSURLSessionDataTask *)requestSchoolArticleSearchDataForIndex:(NSInteger)index
pageSize:(NSInteger)pageSize searchText:(NSString  * _Nullable )search
       success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
       failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
// 商学院热门分类
+ (NSURLSessionDataTask *)requestSchoolHotCateWithCategory:(NSString *)categoryId success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                   failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
@end

NS_ASSUME_NONNULL_END
