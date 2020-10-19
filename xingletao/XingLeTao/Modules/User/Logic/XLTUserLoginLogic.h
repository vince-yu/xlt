//
//  XLTUserLoginLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"
#import "XLTUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserLoginLogic : XLTNetBaseLogic
- (void)xingletaonetwork_requestVerificationCodeWithPhone:(NSString *)phone
                            success:(void(^)(XLTLoginVerificationCodeModel *model))success
                            failure:(void(^)(NSString *errorMsg))failure;


// 微信登录
- (void)loginWithWXinCode:(NSString *)code
success:(void(^)(XLTUserInfoModel *model))success
failure:(void(^)(NSString *errorMsg))failure;
//验证码登录与手机号
- (void)xingletaonetwork_requesLoginWithPhone:(NSString *)phone
                                         code:(NSString *)code
                                      success:(void(^)(XLTUserInfoModel *model))success
                                      failure:(void(^)(NSString *errorMsg,NSNumber  * _Nullable code))failure;
// 强制绑定邀请码
- (void)bindInvitorWithCode:(NSString *)invite_code
                    success:(void(^)(XLTUserInfoModel *model))success
                    failure:(void(^)(NSString *errorMsg))failure;
// 验证码登录
- (void)loginWithPhone:(NSString *)phone
      verificationCode:(NSString *)verificationCode
                   sid:(NSString * _Nullable)sid
            inviteCode:(NSString * _Nullable)inviteCode
               success:(void(^)(XLTUserInfoModel *model))success
               failure:(void(^)(NSString *errorMsg,NSNumber  * _Nullable code))failure;

//- (void)loginWithInviteCode:(NSString *)inviteCode
//verificationCode:(NSString *)verificationCode
//             sid:(NSString *)sid
//                   success:(void(^)(XLTUserInfoModel *model))success
//         failure:(void(^)(NSString *errorMsg))failure;

// 校验手机验证码
- (void)verificationPhone:(NSString *)phone
         verificationCode:(NSString *)verificationCode
                      sid:(NSString *)sid
                  success:(void(^)(XLTUserInfoModel *model))success
        failure:(void(^)(NSString *errorMsg))failure ;

- (void)bindInviteCode:(NSString *)inviteCode
         isRecommendFlag:(BOOL)flag
                 success:(void(^)(XLTUserInfoModel *model))success
                 failure:(void(^)(NSString *errorMsg))failure;

// 系统推荐人
+ (void)fetchRecommendInviterSuccess:(void(^)(NSDictionary *inviteInfo ,NSURLSessionTask *task))success
                             failure:(void(^)(NSString *errorMsg ,NSURLSessionTask *task))failure;

- (void)skipInviteCodeSuccess:(void(^)(XLTUserInfoModel *model))success
                      failure:(void(^)(NSString *errorMsg))failure;


- (NSURLSessionTask *)fecthInviteInfoForCode:(NSString *)inviteCode
                                     success:(void(^)(NSDictionary *inviteInfo ,NSURLSessionTask *task))success
                                     failure:(void(^)(NSString *errorMsg ,NSURLSessionTask *task))failure;
@end

NS_ASSUME_NONNULL_END
