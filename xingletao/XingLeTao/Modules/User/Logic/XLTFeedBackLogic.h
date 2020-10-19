//
//  XLTFeedBackLogic.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTFeedBackLogic : XLTNetBaseLogic
// list
+ (NSURLSessionDataTask *)requestFeedBackListDataForIndex:(NSInteger)index
                                                pageSize:(NSInteger)pageSize
                                                success:(void(^)(NSArray *feedArray,NSURLSessionDataTask * task))success
                                                failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
+ (NSURLSessionDataTask *)requestFeedBackDetailWitdhId:(NSString *)feedId
                                               success:(void(^)(NSDictionary *info,NSURLSessionDataTask * task))success
                                               failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

+ (NSURLSessionDataTask *)requestCustomerServiceSuccess:(void(^)(NSDictionary *info,NSURLSessionDataTask * task))success
                                                failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;

+ (NSURLSessionDataTask *)uploadFeedBackImageData:(NSData *)fileData
                                          success:(void(^)(NSDictionary *info))success
                                          failure:(void(^)(NSString *errorMsg))failure;

+ (NSURLSessionDataTask *)uploadFeedBackFileType:(NSString *)fileType
                                        filePath:(NSString *)filePath
                                         success:(void(^)(NSDictionary *info))success
                                         failure:(void(^)(NSString *errorMsg))failure;

+ (NSURLSessionDataTask *)feedBackWithPhone:(NSString * _Nullable)phone
                                    log_url:(NSString *)log_url
                                    content:(NSString *)content
                                  enclosure:(NSArray *)enclosure
                                    success:(void(^)(NSDictionary *info,NSURLSessionDataTask * task))success
                                    failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;
@end

NS_ASSUME_NONNULL_END
