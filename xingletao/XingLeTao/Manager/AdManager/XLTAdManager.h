//
//  XLTAdManager.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTBaseViewController.h"
#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTAdManager : NSObject
+ (instancetype)shareManager;

- (void)xingletaonetwork_requestHomeAdSuccess:(void(^)(NSDictionary  * _Nonnull adInfo))success
failure:(void(^)(NSString *errorMsg))failure;


- (void)fetchAndPopZeroBuyAdIfNeed;

- (void)xingletaonetwork_requestAdListWithPosition:(NSString *)position
                    success:(void(^)(NSArray * _Nonnull adArray))success
                    failure:(void(^)(NSString *errorMsg))failure;

- (void)adJumpWithInfo:(NSDictionary *)adInfo sourceController:(XLTBaseViewController *)
sourceController;

- (void)webActivityJumpWithInfo:(NSDictionary *)adInfo sourceController:(XLTBaseViewController *)
sourceController;


- (void)repoAdClickWitdAdId:(NSString *)addId;

- (void)popAdWithInfo:(NSArray *)adInfo;
- (void)savePopAdShowDate:(NSDate *)date;


// 活动链接
- (void)xingletaonetwork_requestAdActivityWithUrl:(NSString * _Nonnull)link_url
                                        link_type:(NSArray * _Nonnull)link_type
                                              tid:(NSString * _Nonnull)tid
                                      item_source:(NSString * _Nonnull)item_source
                                          success:(void(^)(NSDictionary  * _Nonnull adInfo))success
                                          failure:(void(^)(NSString *errorMsg, NSString * _Nullable authUrl,XLTBaseModel * model))failure;
@end

NS_ASSUME_NONNULL_END
