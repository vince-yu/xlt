//
//  XLTUserInfoLogic.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/16.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTNetBaseLogic.h"
NS_ASSUME_NONNULL_BEGIN
@interface XLTUserInfoLogic : XLTNetBaseLogic
#pragma mark 个人中心账号相关
//获取可提现全部余额
+ (void)xingletaonetwork_requestBalanceOfWithDrawSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;

//获取余额明细 list
+ (void)xingletaonetwork_requestBalanceDetailWith:(NSString *)yearMonth type:(NSString *)type page:(NSString *)page limit:(NSString *)limit success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//获取余额信息
+ (void)xingletaonetwork_requestBalanceDetailSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//提现
+ (void)xingletaonetwork_requestWithDrawWith:(NSString *)money totalAmount:(NSString *)total success:(void(^)(NSString *msg))success failure:(void(^)(NSString *errorMsg))failure;
//我的足迹
- (void)xingletaonetwork_requestUserFootList:(NSInteger)page row:(NSInteger)row success:(void(^)(NSArray *goodsArray))success failure:(void(^)(NSString *errorMsg))failure;
//我的专属推荐
+ (NSURLSessionDataTask *)xingletaonetwork_requestUserRecommendGoodsDataForIndex:(NSInteger)index
                                   pageSize:(NSInteger)pageSize
                                goodsSource:(NSString*)goodsSource
                                       sort:(NSString * _Nullable)sort
                                    success:(void(^)(NSArray *goodsArray,NSURLSessionDataTask * task))success
                                    failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure;  
//获取最小提现金额
+ (void)xingletaonetwork_requestMiniAmountWithDrawSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
#pragma mark 个人中心用户操作
//获取用户信息
+ (void)xingletaonetwork_requestUserInfoSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//原手机号发送验证码
+ (void)xingletaonetwork_requestoldPhoneSendCodeWith:(NSString *)phone success:(void(^)(XLTBaseModel *model))success failure:(void(^)(NSString *errorMsg))failure;

//新手机号发送验证码
+ (void)xingletaonetwork_requestphoneSendCodeWith:(NSString *)phone success:(void(^)(XLTBaseModel *model))success failure:(void(^)(NSString *errorMsg))failure;
//原手机号验证码验证
+ (void)xingletaonetwork_requestoldPhoneVerifyCodeWith:(NSString *)phone code:(NSString *)code success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//更换手机号并重新登录
+ (void)xingletaonetwork_requestnewPhoneChangeAndLoginWith:(NSString *)phone code:(NSString *)code success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//登出
+ (void)xingletaonetwork_requestlogout:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//绑定支付宝
+ (void)xingletaonetwork_bindAlipayWith:(NSString *)realname alipay:(NSString *)alipay code:(NSString *)code success:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//绑定支付宝前发送验证短信
+ (void)xingletaonetwork_bindAlipaySnedCodeWithSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//获取支付宝信息
+ (void)xingletaonetwork_requestAlipayInfoWithSuccess:(void(^)(id balance))success failure:(void(^)(NSString *errorMsg))failure;
//我的粉丝粉丝列表
//sort itime:排序注册时间 fans_all 排序粉丝数 加-号代表倒序
//fans 0:直接一级 1:二级 缺省为全部
+ (void)xingletaonetwork_requestTeamListWithUid:(NSString *)uid Page:(NSString *)page row:(NSString *)row sort:(NSString *)sort fans:(NSString *)fans search:(NSString *)search success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//我的粉丝信息
+ (void)xingletaonetwork_requestTeamWithSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//查询邀请人
+ (void)xingletaonetwork_requestInvatorWith:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//绑定微信
+ (void)xingletaonetwork_bindWXWithCode:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//绑定邀请码
+ (void)xingletaonetwork_bindInvateCode:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//获取邀请图片列表
+ (void)xingletaonetwork_requestInvatePicListWithInviteCode:(NSString *)invitecode
                                                    success:(void(^)(id object))success
                                                    failure:(void(^)(NSString *errorMsg))failure;
//统计邀请图片分享
//+ (void)getUserIncomeWithId:(NSString *)userId Success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//获取我的收益信息
+ (void)getMineIncomeSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//获取粉丝收益信息
+ (void)getTeamIncomeSuccess:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
+ (void)xingletaonetwork_requestUserIncomeWithId:(NSString *)userId Success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//绑定微信
+ (void)bindWeiXinWithCode:(NSString *)code success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//获取乐桃收益榜信息
+ (void)getIncomeListWithType:(NSString *)type  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//粉丝贡献榜——本月预估佣金
+ (void)getMonthContributListWithPage:(NSString* )page row:(NSString *)row sort:(NSString *)sort relation:(NSString *)relation  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//粉丝贡献榜——总预估佣金
+ (void)getCommissionContributListWithPage:(NSString* )page row:(NSString *)row sort:(NSString *)sort relation:(NSString *)relation  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;
//粉丝贡献榜——7日拉新
+ (void)getNewContributListWithPage:(NSString* )page row:(NSString *)row sort:(NSString *)sort relation:(NSString *)relation  success:(void(^)(id object))success failure:(void(^)(NSString *errorMsg))failure;


// 获取push开关状态
+ (void)requestPushSwitchsWithUserId:(NSString *)userId success:(void(^)(NSArray  * _Nonnull switchList))success failure:(void(^)(NSString *errorMsg))failure;


// 更新push开关状态
+ (void)updatePushSwitchsWithUserId:(NSString *)userId
                           switchId:(NSString *)switchId
                           switchOn:(BOOL)switchOn
                            success:(void(^)(NSDictionary  * _Nonnull info))success
                            failure:(void(^)(NSString *errorMsg))failure;


// 设置给粉丝显示的微信ID
+ (void)updateShowWXWith:(NSString *)wechat_show_uid success:(void(^)(NSDictionary  * _Nonnull info))success
                 failure:(void(^)(NSString *errorMsg))failure;
//获取用户邀请码
+ (void)getInviterInfoSuccess:(void(^)(id  _Nonnull info))success
                      failure:(void(^)(NSString *errorMsg))failure;
//设置用户邀请码
+ (void)updateInviter:(NSString *)inviter success:(void(^)(NSDictionary  * _Nonnull info))success
              failure:(void(^)(NSString *errorMsg))failure;
//获取推荐未使用的邀请码
+ (void)getInviterCodeArraySuccess:(void(^)(id  _Nonnull info))success
                           failure:(void(^)(NSString *errorMsg))failure;
//检测邀请码是否被使用
+ (void)checkInviter:(NSString *)inviter
             success:(void(^)(NSDictionary  * _Nonnull info))success
             failure:(void(^)(NSString *errorMsg))failure;
//获取分享使用的邀请码图片
+ (void)getInviterImageUseShareWithPid:(NSString *)pid
                                  code:(NSString *)code
                                   pre:(NSString *)pre
                               setNick:(NSString *)set_user_nick
                                userId:(NSString *)userId
                               Success:(void(^)(id  _Nonnull info))success
                               failure:(void(^)(NSString *errorMsg))failure;


// 检查提现金额是否需要签署协议
+ (void)requestPigContractWithAmount:(NSString *)amount
                             success:(void(^)(NSDictionary * _Nonnull info))success
                             failure:(void(^)(NSString *errorMsg))failure;

// 获取Account提醒
+ (void)requestAccountTipsInfoSuccess:(void(^)(NSDictionary * _Nonnull info))success
                              failure:(void(^)(NSString *errorMsg))failure;

@end
NS_ASSUME_NONNULL_END
