//
//  XLTCancelAccountLogic.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTCancelAccountLogic : XLTNetBaseLogic
// 获取注销信息
+ (void)requestAccountInfoSuccess:(void(^)(NSDictionary * _Nonnull info))success
                                failure:(void(^)(NSString *errorMsg))failure;
// 撤消注销
+ (void)requestRevocationCancelAccountSuccess:(void(^)(NSDictionary * _Nonnull info))success
                                      failure:(void(^)(NSString *errorMsg))failure;
// 注销
+ (void)requestCancelAccountWithPhone:(NSString *)phone
                                 code:(NSString *)code
                               reason:(NSArray *)reason
                              Success:(void(^)(NSDictionary * _Nonnull info))success
                              failure:(void(^)(NSString *errorMsg))failure;
// 获取注销手机验证码

+ (void)requestCancelAccountSendCodeWithPhone:(NSString *)phone
                                      success:(void(^)(NSDictionary * _Nonnull info))success
                                      failure:(void(^)(NSString *errorMsg))failure;
// 获取注销原因
/*
 type:1-注销原因 2-放弃以下权益 3-重要提示
 */
+ (void)requestCancelAccountReasonWithType:(NSString *)type
                                   success:(void(^)(NSDictionary * _Nonnull info))success
                                   failure:(void(^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
