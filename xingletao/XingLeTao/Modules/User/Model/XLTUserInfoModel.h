//
//  XLTUserInfoModel.h
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019 . All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLTUserLoginType){
   XLTUserLoginUnknowType = 0,//未知
};

@interface XLTUserInfoConfigModel : XLTBaseModel
@property (nonatomic, copy) NSNumber *xlt_withdraw_date;               //类型：String  必有字段  备注：提现到账天
@property (nonatomic, copy) NSNumber *xlt_min_withdraw_amount;   //类型：String  必有字段  备注：提现最小金额
@property (nonatomic, copy) NSNumber *xlt_rebate_time;              //类型：String  必有字段  备注：结算时间 天

@property (nonatomic, copy) NSString *helpvideo_url;              //


@end

@interface XLTUserInfoModel : XLTBaseModel

@property (nonatomic,copy) NSString * token; //用户token
@property (nonatomic,copy) NSString * _id; //用户ID
@property (nonatomic,copy) NSString * userName; //名称
@property (nonatomic, copy) NSNumber *is_new; //登录类型;

@property (nonatomic, copy) NSNumber *has_bind_tb; //是否绑定淘宝;
@property (nonatomic, copy) NSNumber *phone;
@property (nonatomic, copy) NSNumber *last_login;
@property (nonatomic, copy) NSNumber *bind_alipay;
@property (nonatomic, copy) NSNumber *is_new_user;
@property (nonatomic, copy) NSString *userNameInfo;
//星乐桃添加
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSNumber *invite_link;
@property (nonatomic, copy) NSString *invite_link_code;
@property (nonatomic, copy) NSString *svip_expire;

@property (nonatomic, copy) NSString *inviter;
@property (nonatomic, copy) NSString *inviter_avatar;
@property (nonatomic, copy) NSString *inviter_link_code;
@property (nonatomic, copy) NSNumber *level; //类型：String  必有字段  备注：用户等级 1=>用户 2=>会员 3=>超级会员 4=>最高级(名称未定)
@property (nonatomic, copy) NSNumber *wechat_info;
@property (nonatomic, strong) XLTUserInfoConfigModel *config;

// 新增字段
@property (nonatomic, copy) NSString *phone_hide;
@property (nonatomic, copy) NSNumber *invited;
@property (nonatomic, copy) NSString *xlt_new_code;

@property (nonatomic, copy) NSString *wechat_show_uid; //类型：String  必有字段  备注：我的微信
@property (nonatomic, copy) NSString *tutor_wechat_show_uid;   //类型：Mixed  必有字段  备注：上级导师微信
@property (nonatomic, copy) NSString *tutor_wechat_show_name;   //类型：Mixed  必有字段  备注：上级导师微信
@property (nonatomic ,copy) NSString *tutor_inviter_username; //导师名字
@property (nonatomic, copy) NSString *tutor_inviter_avatar;
@property (nonatomic ,copy) NSNumber *canSkipInvited; //是否调过绑定邀请码
@property (nonatomic, copy) NSString *itime; //注册时间

@property (nonatomic, copy) NSString *isTutor; //1导师 0不是导师

@property (nonatomic ,copy) NSNumber *is_logout;

@end

@interface XLTLoginVerificationCodeModel : XLTBaseModel
@end

NS_ASSUME_NONNULL_END
