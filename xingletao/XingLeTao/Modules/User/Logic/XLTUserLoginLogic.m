//
//  XLTUserLoginLogic.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserLoginLogic.h"
#import "XLTUserManager.h"

@implementation XLTUserLoginLogic
- (void)xingletaonetwork_requestVerificationCodeWithPhone:(NSString *)phone
                               success:(void(^)(XLTLoginVerificationCodeModel *model))success
                               failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    [XLTNetworkHelper POST:kLoginFetchVerificationCodeUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTLoginVerificationCodeModel *model = [XLTLoginVerificationCodeModel automaticParserDataWithJSON:responseObject];
            success(model);
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}
- (void)xingletaonetwork_requesLoginWithPhone:(NSString *)phone
                                         code:(NSString *)code
                               success:(void(^)(XLTUserInfoModel *model))success
                               failure:(void(^)(NSString *errorMsg,NSNumber  * _Nullable code))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (code) {
        [parameters setObject:code forKey:@"code"];
    }
    [XLTNetworkHelper POST:kLoginWithPhoneAndCodeUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                // save
//                [[XLTUserManager shareManager] loginUserInfo:model];
                [XLTUserManager shareManager].curUserInfo = model;
                [XLTNetworkHelper setValue:model.token forHTTPHeaderField:@"Authorization"];
                success(model);
//                [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLoginSuccess object:nil];
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,model.xlt_rcode);
            }
        } else {
            failure(Data_Error,nil);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,nil);
    }];
}
- (void)bindInvitorWithCode:(NSString *)invite_code
                    success:(void(^)(XLTUserInfoModel *model))success
                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    if (invite_code) {
        [parameters setObject:invite_code forKey:@"invite_code"];
    }
    NSString *uid = [XLTUserManager shareManager].curUserInfo._id;
    if (uid) {
        [parameters setObject:uid forKey:@"uid"];
    }
    [XLTNetworkHelper POST:kBindInviterUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserInfoModel *userModel = XLTUserManager.shareManager.curUserInfo;
                userModel.invited = model.invited;
                userModel.inviter = model.inviter;
                userModel.inviter_avatar = model.inviter_avatar;
                userModel.inviter_link_code = model.inviter_link_code;
                [[XLTUserManager shareManager] loginUserInfo:userModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLoginSuccess object:nil];
                success(userModel);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}
- (void)loginWithWXinCode:(NSString *)code
                  success:(void(^)(XLTUserInfoModel *model))success
                  failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    if (code) {
        [parameters setObject:code forKey:@"code"];
    }
    [XLTNetworkHelper POST:kLoginWithWXUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}

- (void)loginWithPhone:(NSString *)phone
      verificationCode:(NSString *)verificationCode
                   sid:(NSString * _Nullable)sid
            inviteCode:(NSString * _Nullable)inviteCode
                         success:(void(^)(XLTUserInfoModel *model))success
               failure:(void(^)(NSString *errorMsg,NSNumber  * _Nullable code))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (verificationCode) {
         [parameters setObject:verificationCode forKey:@"code"];
    }
    if (sid) {
        [parameters setObject:sid forKey:@"sid"];
    }
    if (inviteCode) {
        [parameters setObject:inviteCode forKey:@"invite_code"];
    }
    NSString *url   = sid ? kLoginWithWXBindPhoneUrl :kLoginUrl;
    [XLTNetworkHelper POST:url parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                // save
                [[XLTUserManager shareManager] loginUserInfo:model];
                success(model);
                [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLoginSuccess object:nil];
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,model.xlt_rcode);
            }
        } else {
            failure(Data_Error,nil);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,nil);
    }];
}

- (void)verificationPhone:(NSString *)phone
         verificationCode:(NSString *)verificationCode
                      sid:(NSString *)sid
                  success:(void(^)(XLTUserInfoModel *model))success
                  failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (verificationCode) {
         [parameters setObject:verificationCode forKey:@"code"];
    }
    if (sid) {
        parameters[@"sid"] = sid;
    }
    [XLTNetworkHelper POST:kVerificationPhoneCodeUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserInfoModel *userModel = [XLTUserInfoModel automaticParserDataWithJSON:model.data];
                success(userModel);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}

- (NSURLSessionTask *)fecthInviteInfoForCode:(NSString *)inviteCode
                       success:(void(^)(NSDictionary *inviteInfo ,NSURLSessionTask *task))success
                       failure:(void(^)(NSString *errorMsg ,NSURLSessionTask *task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    if (inviteCode) {
        [parameters setObject:inviteCode forKey:@"code"];
    }
    return [XLTNetworkHelper GET:kUserFindInvatorNoAuthUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data,task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,task);
    }];
}


- (void)bindInviteCode:(NSString *)inviteCode
         isRecommendFlag:(BOOL)flag
                 success:(void(^)(XLTUserInfoModel *model))success
                 failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    if (inviteCode) {
        [parameters setObject:inviteCode forKey:@"invite_code"];
    }
    parameters[@"recommed"] = [NSNumber numberWithBool:flag];
    
    [XLTNetworkHelper POST:kBindInviteCodeUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}

+ (void)fetchRecommendInviterSuccess:(void(^)(NSDictionary *inviteInfo ,NSURLSessionTask *task))success
                             failure:(void(^)(NSString *errorMsg ,NSURLSessionTask *task))failure {
    [XLTNetworkHelper GET:kUserRecommendInviterUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data,task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,task);
    }];
}

- (void)skipInviteCodeSuccess:(void(^)(XLTUserInfoModel *model))success
                      failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper POST:kLoginSkipInviteUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTUserInfoModel *model = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error);
    }];
}
@end
