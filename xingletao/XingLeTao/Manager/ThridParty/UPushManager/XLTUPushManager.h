//
//  XLTUPushManager.h
//  XingLeTao
//
//  Created by chenhg on 2020/2/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTUPushManager : NSObject
+ (instancetype)shareManager;
//绑定别名
- (void)addAliasIfNeed;
//移除别名
- (void)removeAliasIfNeed;

- (void)receiveRemoteNotification:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
