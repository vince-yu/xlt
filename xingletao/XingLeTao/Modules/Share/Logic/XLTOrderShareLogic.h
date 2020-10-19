//
//  XLTOrderShareLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderShareLogic : XLTNetBaseLogic
//1微信好友 2QQ 3微博 4邀请链接
+ (void)xingletaonetwork_requestInviteCodeWithOrderId:(NSString * _Nullable)orderId
                           channel:(NSString * _Nullable)channel
                           success:(void(^)(NSDictionary *inviteInfo))success
                           failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
