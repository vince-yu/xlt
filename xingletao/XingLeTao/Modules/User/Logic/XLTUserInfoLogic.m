//
//  XLTUserInfoLogic.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserInfoLogic.h"
#import "XLTBalanceDetailModel.h"
#import "XLTBalanceInfoModel.h"
#import "XLTUserInfoModel.h"
#import "XLTUserManager.h"
#import "XLTUserTeamInfoModel.h"
#import "XLTUserInvateModel.h"
#import "XLTUserTeamIncomeModel.h"
#import "XLTUserIncomListModel.h"
#import "XLTUserContibuteModel.h"
#import "XLTInviterModel.h"

@implementation XLTUserInfoLogic
//获取可提现全部余额
+ (void)xingletaonetwork_requestBalanceOfWithDrawSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserBalanceOfWithDraw parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data[@"amount_avail"]);
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
//获取余额明细 list
//类型： 金额明细 type=null， 结算收益 type = 100 ，提现记录 type = 20
+ (void)xingletaonetwork_requestBalanceDetailWith:(NSString *)yearMonth type:(NSString *)type page:(NSString *)page limit:(NSString *)limit success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    if (!yearMonth.length || !page.length || !limit.length) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"month"] = yearMonth;
    dic[@"page"] = page;
    dic[@"limit"] = limit;
    dic[@"type"] = type;
    [XLTNetworkHelper GET:kUserBalanceDeatil parameters:@{@"month":yearMonth,@"page":page,@"limit":limit} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTBalanceDetailModel class] json:model.data];
                success(letaoPageDataArray);
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
//获取余额信息
+ (void)xingletaonetwork_requestBalanceDetailSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserBalance parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                XLTBalanceInfoModel *blance = [XLTBalanceInfoModel modelWithDictionary:model.data];
                success(blance);
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
//提现
+ (void)xingletaonetwork_requestWithDrawWith:(NSString *)money totalAmount:(NSString *)total success:(void(^)(NSString *msg))success failure:(void(^)(NSString *errorMsg))failure{
    if (!money.length || !total.length) {
        return;
    }
    [XLTNetworkHelper POST:kUserWithDraw parameters:@{@"amount":money,@"amount_useable":total} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSString class]]) {
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
//我的足迹
- (void)xingletaonetwork_requestUserFootList:(NSInteger)page row:(NSInteger )row success:(void(^)(NSArray *goodsArray))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserFootList parameters:@{@"page":[NSNumber numberWithInteger:page],@"row":[NSNumber numberWithInteger:row]} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
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
//我的专属推荐
+ (NSURLSessionDataTask *)xingletaonetwork_requestUserRecommendGoodsDataForIndex:(NSInteger)index
                                   pageSize:(NSInteger)pageSize
                                goodsSource:(NSString*)goodsSource
                                       sort:(NSString * _Nullable)sort
                                    success:(void(^)(NSArray *goodsArray,NSURLSessionDataTask * task))success
                                    failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:pageSize] forKey:@"row"];
    return [XLTNetworkHelper GET:kUserRecommendGoodsUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
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


//获取最小提现金额
+ (void)xingletaonetwork_requestMiniAmountWithDrawSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserMiniAmountOfWithDraw parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data[@"min_withdraw_amount"]);
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
//获取用户信息
+ (void)xingletaonetwork_requestUserInfoSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserInfo parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
           if(responseObject != nil) {
               XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
               if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                   XLTUserInfoModel *userInfo = [XLTUserInfoModel modelWithDictionary:model.data];
                   userInfo.token = XLTUserManager.shareManager.curUserInfo.token;
                   XLTUserManager.shareManager.curUserInfo = userInfo;
                   [[XLTUserManager shareManager] saveUserInfo];
                   success(userInfo);
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



//原手机号发送验证码
+ (void)xingletaonetwork_requestoldPhoneSendCodeWith:(NSString *)phone success:(void(^)(XLTBaseModel *model))success failure:(void(^)(NSString *errorMsg))failure {
    if (!phone.length) {
        return;
    }
    [XLTNetworkHelper POST:kUserOldPhoneSendCode parameters:@{@"phone":phone} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            success(model);
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}

//新手机号发送验证码
+ (void)xingletaonetwork_requestphoneSendCodeWith:(NSString *)phone success:(void(^)(XLTBaseModel *model))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper POST:kLoginNewPhoneFetchVerificationCodeUrl parameters:@{@"phone":phone} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            success(model);
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//原手机号验证码验证
+ (void)xingletaonetwork_requestoldPhoneVerifyCodeWith:(NSString *)phone code:(NSString *)code success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (phone.length) {
        [dic setObject:phone forKey:@"phone"];
    }
    if (code.length) {
        [dic setObject:code forKey:@"code"];
    }
    [XLTNetworkHelper POST:kUserOldPhoneverifyCode parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
           if(responseObject != nil) {
               XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
               if ([model isCorrectCode]) {
                   success(nil);
               } else {
                   NSString *msg = model.message;
                   if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                       msg = Data_Error;
                   }
                   failure(msg);
               }
           }
       } failure:^(NSError *error, NSURLSessionDataTask *task) {
           failure(Data_Error);
       }];
}
//更换手机号并重新登录
+ (void)xingletaonetwork_requestnewPhoneChangeAndLoginWith:(NSString *)phone code:(NSString *)code success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (phone.length) {
        [dic setObject:phone forKey:@"phone"];
    }
    if (code.length) {
        [dic setObject:code forKey:@"code"];
    }
    [XLTNetworkHelper POST:kUserChangeNewPhone parameters:@{@"phone":phone,@"code":code} success:^(id responseObject, NSURLSessionDataTask *task) {
           if(responseObject != nil) {
               XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
               if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                   XLTUserInfoModel *infomodel = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
                   [[XLTUserManager shareManager] loginUserInfo:infomodel];
                   success(model.data);
               } else {
                   NSString *msg = model.message;
                   if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                       msg = Data_Error;
                   }
                   failure(msg);
               }
           }
       } failure:^(NSError *error, NSURLSessionDataTask *task) {
           failure(Data_Error);
       }];
}
//登出
+ (void)xingletaonetwork_requestlogout:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserLogout parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
        if ([model isCorrectCode]) {
            [XLTUserManager.shareManager logout];
            success(nil);
        }else{
            failure(Data_Error);
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//绑定支付宝
+ (void)xingletaonetwork_bindAlipayWith:(NSString *)realname alipay:(NSString *)alipay code:(NSString *)code success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    if (!realname.length || !code.length || !alipay.length) {
        return;
    }
    [XLTNetworkHelper POST:kUserBindAlipay parameters:@{@"realname":realname,@"code":code,@"alipay":alipay} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//绑定支付宝前发送验证短信
+ (void)xingletaonetwork_bindAlipaySnedCodeWithSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserAlipayCode parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        success(nil);
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取支付宝信息
+ (void)xingletaonetwork_requestAlipayInfoWithSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserAlipayInfo parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//绑定邀请码
+ (void)xingletaonetwork_bindInvateCode:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    if (!code.length) {
        return;
    }
    [XLTNetworkHelper POST:KUserBindInvate parameters:@{@"invite_code":code} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//绑定微信
+ (void)xingletaonetwork_bindWXWithCode:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    if (!code.length) {
        return;
    }
    [XLTNetworkHelper POST:KUserBindInvate parameters:@{@"code":code} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserInfoModel *userModel = [XLTUserInfoModel automaticParserDataWithJSON:responseObject];
                userModel.token = XLTUserManager.shareManager.curUserInfo.token;
                XLTUserManager.shareManager.curUserInfo = userModel;
                [[XLTUserManager shareManager] saveUserInfo];
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//查询邀请人
+ (void)xingletaonetwork_requestInvatorWith:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    if (!code.length) {
        return;
    }
    [XLTNetworkHelper GET:kUserFindInvator parameters:@{@"code":code} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//我的粉丝信息
+ (void)xingletaonetwork_requestTeamWithSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kUserTeamInfo parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserTeamInfoModel *info = [XLTUserTeamInfoModel modelWithDictionary:model.data];
                success(info);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//我的粉丝粉丝列表
//sort itime:排序注册时间 fans_all 排序粉丝数 加-号代表倒序
//fans 0:直接一级 1:二级 缺省为全部
//uid:用户id
+ (void)xingletaonetwork_requestTeamListWithUid:(NSString *)uid Page:(NSString *)page row:(NSString *)row sort:(NSString *)sort fans:(NSString *)fans search:(NSString *)search success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    if (!page.length || !row.length || !sort.length) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"page":page,@"row":row,@"sort":sort}];
    
    if (search.length) {
        [dic setObject:search forKey:@"search"];
    }
    if (uid.length) {
        [dic setObject:uid forKey:@"uid"];
        [dic setObject:@"0" forKey:@"fans"];
    }else{
        if (fans.length) {
            [dic setObject:fans forKey:@"fans"];
        }
    }
                                                                                 
    
    [XLTNetworkHelper GET:kUserGeamItemList parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *letaoPageDataArray = [NSArray modelArrayWithClass:[XLTUserTeamItemListModel class] json:model.data];
                success(letaoPageDataArray);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取邀请图片列表
+ (void)xingletaonetwork_requestInvatePicListWithInviteCode:(NSString *)invitecode
                                                    success:(void(^)(id object))success
                                                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (invitecode) {
        parameters[@"code"] = invitecode;
    }
    [XLTNetworkHelper GET:KUserInvatePicList parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *info = [NSArray modelArrayWithClass:[XLTUserInvateModel class] json:model.data];
                success(info);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//统计邀请图片分享
+ (void)postInvateClistWithId:(NSString *)picId success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    if (!picId.length) {
        return;
    }
    [XLTNetworkHelper POST:kUserInvateClick parameters:@{@"id":picId} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取用户收益信息
+ (void)xingletaonetwork_requestUserIncomeWithId:(NSString *)userId Success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    if (!userId.length) {
        return;
    }
    [XLTNetworkHelper GET:kUserIncome parameters:@{@"_id":userId} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserIncomeModel *info = [XLTUserIncomeModel modelWithDictionary:model.data];;
                success(info);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取粉丝收益信息
+ (void)getTeamIncomeSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kUserTeamIncome parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserTeamIncomeModel *info = [XLTUserTeamIncomeModel modelWithDictionary:model.data];;
                success(info);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取我的收益信息
+ (void)getMineIncomeSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kUserMinceIncome parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserMineIncomeModel *info = [XLTUserMineIncomeModel modelWithDictionary:model.data];;
                success(info);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//绑定微信
+ (void)bindWeiXinWithCode:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure{
    if (!code.length) {
        return;
    }
    [XLTNetworkHelper POST:kUserBindWX parameters:@{@"code":code} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTUserInfoModel *user = [XLTUserInfoModel automaticParserDataWithJSON:model.data];
                [XLTUserManager shareManager].curUserInfo = user;
                success(user);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取乐桃收益榜信息
+ (void)getIncomeListWithType:(NSString *)type  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    if (!type.length) {
        return;
    }
    [XLTNetworkHelper GET:KUserIncomList parameters:@{@"type":type} success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *infoArrar = [NSArray modelArrayWithClass:[XLTUserIncomListModel class] json:model.data];;
                success(infoArrar);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//粉丝贡献榜——7日拉新
+ (void)getNewContributListWithPage:(NSString* )page row:(NSString *)row sort:(NSString *)sort relation:(NSString *)relation  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    if (!page.length || !row.length || !sort.length) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"page":page,@"row":row,@"sort":sort}];
    if (relation.length) {
        [dic setObject:relation forKey:@"relation"];
    }
    [XLTNetworkHelper GET:kUserNewContributList parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *infoArrar = [NSArray modelArrayWithClass:[XLTUserContibuteModel class] json:model.data];;
                success(infoArrar);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//粉丝贡献榜——总预估佣金
+ (void)getCommissionContributListWithPage:(NSString* )page row:(NSString *)row sort:(NSString *)sort relation:(NSString *)relation  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    if (!page.length || !row.length || !sort.length) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"page":page,@"row":row,@"sort":sort}];
    if (relation.length) {
        [dic setObject:relation forKey:@"relation"];
    }
    [XLTNetworkHelper GET:KUserCommissionContributeList parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *infoArrar = [NSArray modelArrayWithClass:[XLTUserContibuteModel class] json:model.data];;
                success(infoArrar);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//粉丝贡献榜——本月预估佣金
+ (void)getMonthContributListWithPage:(NSString* )page row:(NSString *)row sort:(NSString *)sort relation:(NSString *)relation  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure {
    if (!page.length || !row.length || !sort.length) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"page":page,@"row":row,@"sort":sort}];
    if (relation.length) {
        [dic setObject:relation forKey:@"relation"];
    }
    [XLTNetworkHelper GET:KUserMonthContributeList parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                NSArray *infoArrar = [NSArray modelArrayWithClass:[XLTUserContibuteModel class] json:model.data];;
                success(infoArrar);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}


// 获取push开关状态
+ (void)requestPushSwitchsWithUserId:(NSString *)userId success:(void(^)(NSArray  * _Nonnull switchList))success failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        parameters[@"userId"] = userId;
    }

    [XLTNetworkHelper GET:kPushSwitchsUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}


// 更新push开关状态
+ (void)updatePushSwitchsWithUserId:(NSString *)userId
                           switchId:(NSString *)switchId
                           switchOn:(BOOL)switchOn
                            success:(void(^)(NSDictionary  * _Nonnull info))success
                            failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        parameters[@"userId"] = userId;
    }
    if (switchId) {
        parameters[@"id"] = switchId;
    }
    parameters[@"enable"] = [NSNumber numberWithBool:switchOn];


    [XLTNetworkHelper POST:kUpdatePushSwitchsUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
// 设置给粉丝显示的微信ID
+ (void)updateShowWXWith:(NSString *)wechat_show_uid success:(void(^)(NSDictionary  * _Nonnull info))success
failure:(void(^)(NSString *errorMsg))failure{
    if (!wechat_show_uid.length) {
        return;
    }


    [XLTNetworkHelper POST:kUpdateShowWX parameters:@{@"wechat_show_uid":wechat_show_uid} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//设置用户邀请码
+ (void)updateInviter:(NSString *)inviter success:(void(^)(NSDictionary  * _Nonnull info))success
failure:(void(^)(NSString *errorMsg))failure{
    if (!inviter.length) {
        return;
    }


    [XLTNetworkHelper POST:kUpdateInviterUrl parameters:@{@"invite_code":inviter} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取用户邀请码
+ (void)getInviterInfoSuccess:(void(^)(id  _Nonnull info))success
                      failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kGetInviterInfoUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                XLTInviterModel *inviter = [XLTInviterModel modelWithJSON:model.data];
                success(inviter);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//检测邀请码是否被使用
+ (void)checkInviter:(NSString *)inviter success:(void(^)(NSDictionary  * _Nonnull info))success
failure:(void(^)(NSString *errorMsg))failure{
    if (!inviter.length) {
        return;
    }
    [XLTNetworkHelper POST:kCheckInviterUrl parameters:@{@"invite_code":inviter} success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取推荐未使用的邀请码
+ (void)getInviterCodeArraySuccess:(void(^)(id  _Nonnull info))success
                      failure:(void(^)(NSString *errorMsg))failure{
    [XLTNetworkHelper GET:kVailedinvitCodeUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
//获取分享使用的邀请码图片
+ (void)getInviterImageUseShareWithPid:(NSString *)pid
                                  code:(NSString *)code
                                   pre:(NSString *)pre
                               setNick:(NSString *)set_user_nick
                                userId:(NSString *)userId
                               Success:(void(^)(id  _Nonnull info))success
                               failure:(void(^)(NSString *errorMsg))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (pid.length) {
        [dic setObject:pid forKey:@"id"];
    }
    if (code.length) {
        [dic setObject:code forKey:@"code"];
    }
    if (pre.length) {
        [dic setObject:pre forKey:@"pre"];
    }
    if (set_user_nick.length) {
        [dic setObject:set_user_nick forKey:@"set_user_nick"];
    }
    if (userId.length) {
        [dic setObject:userId forKey:@"user_id"];
    }
    
    [XLTNetworkHelper GET:kinvitImageUrl parameters:dic success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}


// 检查提现金额是否需要签署协议
+ (void)requestPigContractWithAmount:(NSString *)amount
                             success:(void(^)(NSDictionary * _Nonnull info))success
                             failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"amount"] = amount;
    [XLTNetworkHelper GET:kPigContractCheckUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}


// 获取Account提醒
+ (void)requestAccountTipsInfoSuccess:(void(^)(NSDictionary * _Nonnull info))success
                              failure:(void(^)(NSString *errorMsg))failure {
    [XLTNetworkHelper GET:kAccountTipsUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
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
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}
@end
