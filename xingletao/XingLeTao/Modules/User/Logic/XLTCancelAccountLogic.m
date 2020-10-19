//
//  XLTCancelAccountLogic.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountLogic.h"
#import "NSArray+Bounds.h"

@implementation XLTCancelAccountLogic
// 获取注销信息
+ (void)requestAccountInfoSuccess:(void(^)(NSDictionary * _Nonnull info))success
                          failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kCancelAccountDetailsUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
// 获取注销原因
/*
 type:1-注销原因 2-放弃以下权益 3-重要提示
 */
+ (void)requestCancelAccountReasonWithType:(NSString *)type
                                   success:(void(^)(NSDictionary * _Nonnull info))success
                                   failure:(void(^)(NSString *errorMsg))failure {
    if (![type isKindOfClass:[NSString class]] || !type.length) {
        failure(Data_Error);
        return;
    }
    [XLTNetworkHelper GET:kCancelAccountReasonUrl parameters:@{@"type":type} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
// 获取注销手机验证码

+ (void)requestCancelAccountSendCodeWithPhone:(NSString *)phone
                                      success:(void(^)(NSDictionary * _Nonnull info))success
                                      failure:(void(^)(NSString *errorMsg))failure {
    if (![phone isKindOfClass:[NSString class]] || !phone.length) {
        failure(Data_Error);
        return;
    }
    [XLTNetworkHelper POST:kCancelAccountSendCodeUrl parameters:@{@"phone":phone} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model.data);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
// 注销
+ (void)requestCancelAccountWithPhone:(NSString *)phone
                                 code:(NSString *)code
                               reason:(NSArray *)reason
                              Success:(void(^)(NSDictionary * _Nonnull info))success
                            failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"phone"] = phone;
    dic[@"code"] = code;
    NSMutableString *resonStr = [[NSMutableString alloc] initWithString:@""];
    for (NSInteger i = 0; i <= reason.count - 1 ; i ++) {
        NSString *str = [reason by_ObjectAtIndex:i];
        if (str) {
            [resonStr appendString:str];
            if (i != (reason.count - 1)) {
                [resonStr appendString:@","];
            }
        }
        
        
    }
    
    dic[@"reason"] = resonStr;
    if (dic.count != 3) {
        failure(Data_Error);
        return;
    }
    [XLTNetworkHelper POST:kCancelAccountUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model.data);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
// 撤消注销
+ (void)requestRevocationCancelAccountSuccess:(void(^)(NSDictionary * _Nonnull info))success
                          failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper POST:kCancelAccountRevocationUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model.data);
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
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
@end
