//
//  XLTVideoLogic.h
//  XingLeTao
//
//  Created by SNQU on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"
#import "XLTVideoListModel.h"

@interface XLTVideoLogic : XLTNetBaseLogic
//video 视频分类
+ (void)getVideoCategarySuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//video 视频列表
+ (void)getVideoListWithCid:(NSString *)cid page:(NSString *)page row:(NSString *)row success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;


+ (NSURLSessionDataTask *)requestVideosDataForIndex:(NSInteger)index
                                           pageSize:(NSInteger)pageSize
                                          channelId:(NSString*)channelId
                                            success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                            failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
@end

