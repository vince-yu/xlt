//
//  XLTURLConstant.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#ifndef XLTURLConstant_h
#define XLTURLConstant_h



/**测试服务器Url*/
#define  kXLTTestApiSeverUrl    @"https://api-t.xin1.cn/"
//#define  kXLTTestApiSeverUrl    @"http://192.168.100.86:8091/"
#define  kXLTTestH5SeverUrl     @"https://m-xlt-t.xin1.cn/"
#define  kXLTTestACH5SeverUrl   @"https://ac-t.xin1.cn/"
#define  kXLTTestRepoSeverUrl   @"https://report-t.xin1.cn/"
/**预发布服务器Url*/
#define  kXLTPreProductApiSeverUrl   @"https://api-t2.xin1.cn/"
#define  kXLTPreProductH5SeverUrl    @"https://m-xlt-t2.xin1.cn/"
#define  kXLTPreProductACH5SeverUrl  @"https://ac-t2.xin1.cn/"
#define  kXLTPreProductRepoSeverUrl  @"https://report-t2.xin1.cn/"
/**生产服务器Url*/
#define  kXLTProductApiSeverUrl      @"https://api.xinletao.vip/"
#define  kXLTProductH5SeverUrl       @"https://m.xinletao.vip/"
#define  kXLTProductACH5SeverUrl     @"https://ac.xinletao.vip/"
#define  kXLTProductRepoSeverUrl     @"https://report.xin1.cn/"





#pragma mark -———————-———————-——————————— 超时时间 -———————-———————-———————-———————————

#define NetWork_TimeoutInterval            30.0f

#pragma mark -———————-———————-——————————— H5 -———————-———————-———————-———————————

#define kXLTPrivacyProtocal [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseH5SeverUrl,@"article-privacy.html"]
#define kXLTHelpUrl [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseH5SeverUrl,@"help.html"]
#define kXLTServerUrl [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseH5SeverUrl,@"service.html"]

#define kXLTUserTaskH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202002missionactivity/index.html"]

// 地推物料
#define kXLTCloudH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"activity/ac202004dtwl/index.html"]

// 商家合作
#define kXLTMerchantsH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202004business/index.html"]


// 批量转链
#define kXLTZhuanLianH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202004turnlink/index.html"]

// 出单榜
#define kXLTCDPH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202005orderrank/index.html"]

// 微信助手
#define kXLTWXinAssistant5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202005yfd/index.html?hideTitlebar=1"]

//奖励规则
#define kXLTRewardRule5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/feed-recommend"]

//推广规范
#define kXLTTGGFeH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202007promotionnorm/index.html"]

//联系我们
#define kXLTContactUsH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202007contactus/index.html"]

//新手教程
#define kXLTNewJCH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202007guide/index.html"]

//尊享特权
#define kXLTTQJCH5Url [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202008privilege/index.html"]

#pragma mark -———————-———————-——————————— 接口地址 -———————-———————-———————-———————————

#define kLoginNewPhoneFetchVerificationCodeUrl    @"login/code"
//#define kLoginUrl                         @"login/code-login"
//xlt login
#define kLoginFetchVerificationCodeUrl    @"/v2/login/send-bind-code"
#define kLoginUrl                         @"/v2/login/code-login"
#define kLoginWithPhoneAndCodeUrl         @"/v2/login/verify-code-chang"
//xlt add wx
#define kLoginWithWXUrl                   @"/v2/login/wx-app-login"
#define kLoginWithWXBindPhoneUrl          @"/v2/login/bind-phone"
#define kVerificationPhoneCodeUrl         @"/v2/login/verify-code"
#define kBindInviterUrl                   @"/v2/login/bind"


#define kBindInviteCodeUrl                @"/v2/user/bind-invite"

#define kLoginSkipInviteUrl               @"share-log/escape-verify"

#define kHomePagesLayoutUrl               @"v3/home-page/index"

#define kHomeDailyRecommendUrl            @"goods/day-recommend"

#define kHomePlateListUrl                 @"plate/list"
#define kHomePlateFilterOptionsUrl        @"plate/get-options"

#define kCategorysUrl                     @"category/list"
#define kGoodsDetailUrl                   @"v2/goods/detail"
#define kGoodsDescDetailUrl               @"v2/goods/desc"
#define kStoreRecommendGoodsUrl           @"seller/recommend"
#define kGoodDetailRecommendGoodUrl       @"goods/recommend"
#define kGuessYouLikeGoodsUrl             @"goods/like"
#define kJDGoodsJumpUrl                   @"goods-rebate/jdcopo"
#define kAliGoodsJumpUrl                  @"goods-rebate/tcopo"
#define kPDDGoodsJumpUrl                  @"v2/goods-rebate/pdd-copo"

#define kNewGoodsJumpUrl                  @"v2/goods-rebate/copo"

#define kNewGoodsCopoUrl                  @"v3/copo/cover"

#define kGoodsEditorsRecommendUrl         @"v2/goods/rec-text"

#define kGoodsBrowsingHistoryUrl          @"user-foot-print/add"

// mall
#define kMallGoodsDetailUrl               @"v2/vip-goods"
#define kMallGenOrderUrl                  @"v2/vip-order/buy"

// 地址
#define kAddressListUrl                   @"v2/vip-order/get-addr"
#define kAddAddressUrl                    @"v2/vip-order/put-addr"


#define kVersionCheckUrl                    @"version/get-last"


#define kHomeAdUrl                        @"v3/ad/index"
#define kAdListUrl                        @"v3/ad/list"
#define kAdClickRepoUrl                   @"v3/ad/click"
#define kTaoboAuthUrl                     @"taobao/get-auth-url"

#define kCollectListUrl                   @"v2/fav/list"
#define kCollectCancelUrl                 @"fav/del"

#define kCollectGoodslUrl                 @"fav/add"
#define kCancelCollectGoodsUrl            @"fav/del-item"
#define kCancelCollectInvalidGoodUrl      @"fav/del-fail"
#define kGoodsIsCollectUrl                @"v2/goods/fav"
//原生活动页
#define kActivityUrl                      @"/v2/activity-pages/details"
//#define kQRCodeScanUrl                  @"v2/goods/de-url"
//#define kQRCodeScanCodeUrl              @"v2/goods/de-code"
#define kDecodePasteboardGoodsUrl         @"v3/de/code"

#define kV3GoodListUrl                    @"v3/goods-list/get"

#define kStoreInfoUrl                   @"seller/info"

//搜索
#define kSearchHotKeyWordsUrl                  @"hot-search"
#define kSearchSuggestionUrl                   @"search/slug"
#define kSearchGoodsUrl                        @"v2/goods/search"
#define kPasteboardSearchGoodsUrl              @"v2/goods/search-clipboard"
#define kSearchHotKeyWordsGoodsUrl             @"hot-search/click"
#define kSearchStoreUrl                        @"seller/list"
#define kStoreRecommendUrl                     @"seller/recm"

// 订单
//#define kOrderListUrl                       @"order"
//#define kOrderSeekUrl                       @"order/retrieve"
#define kOrderRebateUrl                     @"order/rebate"
#define kOrderShareInviteCodeUrl            @"/share-log/add-log"
#define kMakeOrderUrl                     @"order/pay"

//xlt
#define kOrderListUrl                       @"v2/xlt-order/index"
#define KGroupOrderListUrl                  @"v2/xlt-order/team"
#define kGenOrderUrl                        @"order/gen-order"
#define kOrderSeekUrl                       @"v2/xlt-order/retrieve"

// 开关
#define kClientVersionStateUrl              @"client-version-state"
#define kIcon11StatusUrl                    @"client/ico"
#define kSupportGoodsPlatformUrl            @"v3/item-source/list"
//
#define kSupportGoodsShareTemplateUrl       @"v2/item-source/share-template"

//个人中心
#define kUserBalanceOfWithDraw              @"user-account/amount-avail"
//#define kUserBalanceDeatil                  @"user-account-log"
//#define kUserBalance                        @"user-account"
#define kUserWithDraw                       @"/v2/account/withdraw"
#define kUserFootList                       @"user-foot-print"

#define kUserMiniAmountOfWithDraw           @"user-account/min-widthdraw-limit"
#define kUserOldPhoneSendCode               @"user/code"
#define kUserOldPhoneverifyCode             @"user/verify-code"
#define kUserChangeNewPhone                 @"user/new-phone"
#define kUserLogout                         @"user/logout"
#define kUserBindAlipay                     @"user/bind-alipay"
#define kUserAlipayCode                     @"user/alipay-code"
#define kUserAlipayInfo                     @"user/alipay"
//#define kUserInfo                           @"user"
//xlt user about
#define KUserBindInvate                     @"/v2/user/bind-invite"
#define kUserBindWX                         @"/v2/user/bind-wechat-app"
#define kUserBalanceDeatil                  @"/v2/account/changes"
#define kUserFindInvator                    @"/v2/user/find-inviter"
#define kUserFindInvatorNoAuthUrl           @"/v2/login/find-inviter"
#define kUserRecommendInviterUrl           @"/v3/recommend-superior/index"

#define kUserBalance                        @"/v2/account"
#define kUserTeamInfo                       @"/v2/user/fans"
#define kUserGeamItemList                   @"/v2/user/fans-list"
#define KUserInvatePicList                  @"v2/invite-code-images/list"
#define kUserInvateClick                    @"invite-code-images/click"
#define kUserInfo                           @"/v2/user"
#define kUserIncome                         @"/v2/account/info"
#define kUserTeamIncome                     @"/v2/account/group-info"
#define kUserMinceIncome                    @"/v2/account/mine-info"
#define kUserRecommendGoodsUrl              @"goods/recommend-user"
#define KUserIncomList                      @"v2/xlt-income-rank/index"
#define kUserNewContributList               @"/v2/rank/week-invite"
#define KUserCommissionContributeList       @"/v2/rank/commission"
#define KUserMonthContributeList            @"/v2/rank/month"
// 新手任务汇报
#define kUserTaskRepoUrl                      @"v2/task/task/new-task"
// 日常任务汇报
#define kUserDayTaskRepoUrl                   @"/v2/task/everyday/everyday-task"
// 任务状态
#define kUserTaskStatusUrl                   @"/v2/task/task/x-number"

// 检查提现金额是否需要签署协议
#define kPigContractCheckUrl                 @"v2/account/pig-contract-check"
#define kAccountTipsUrl                      @"v2/account/tips"


#define kPushSwitchsUrl                     @"/v2/umeng/list"
#define kUpdatePushSwitchsUrl               @"v2/umeng/ban"
#define kUpdateShowWX                       @"v2/user/set-wechat-id"
#define kUpdateInviterUrl                   @"v2/user/set-invite-code"
#define kGetInviterInfoUrl                  @"v2/user/get-invite-code"
#define kCheckInviterUrl                    @"v2/user/check-invite-code"
#define kVailedinvitCodeUrl                 @"v2/user/get-rand-code"
#define kinvitImageUrl                      @"v2/invite-code-images/gen"

//红人街
#define kStreetShopList                     @"hot-street/seller"
#define kStreetBigVHome                     @"hot-street/v-detail"
#define kStreetBigVHomeGoodList             @"hot-street/v-goods"
#define kStreetBigVList                     @"hot-street/v-recommend"
#define kStreetRedCateList                  @"hot-street/red-cate"
#define kStreetRedGoodList                  @"hot-street/red-good"
#define kStreetGoodItemList                 @"hot-street/good-item"

// 发圈
#define kShareFeedChannelListUrl               @"v3/community/get-plate"
#define kShareFeedListUrl                      @"community/list"
#define kShareFeedRepoClickUrl                 @"community/click"


#define kSchoolArticleListUrl               @"v2/article/list"
#define kSchoolArticleSearchUrl             @"v2/article/search"
#define kSchoolHotCateUrl                   @"v2/article/hot-cate"

//VIP
#define kVipGoodsList                       @"/v2/vip-goods/list"
#define kVipOrderList                       @"/v2/vip-order/list"
#define kVipTaskList                        @"/v2/user-task/list"
#define kVipRightsList                      @"/v2/user/rights"

//vdieo
#define kVideoCategaryUrl                   @"v2/activity/ac202004dydh/main/category"
#define kVideoListUrl                       @"v2/activity/ac202004dydh/main/list"

// 意见反馈
#define kFeedBackListUrl                    @"v2/feedback/list"
#define kFeedBackUrl                        @"v2/feedback/send"
#define kFeedBackDetailUrl                  @"v2/feedback/detail"

#define kMyWatermarkInfoUrl                  @"v2/xlt-user-watermark/index"
#define kUpdateMyWatermarkInfoUrl            @"/v2/xlt-user-watermark/save"


// 推荐
#define kGoodsCanRecommendUrl              @"/v2/community-goods-recm/can-share"
#define kSendRecommendFeedUrl              @"/v2/community-goods-recm/share"
#define kRecommendFeedListUrl              @"/v2/community-goods-recm/list"
//我的推荐
#define kMyRecommendDeleteUrl              @"v2/community-goods-recm/del"
#define kMyRecommendListUrl                @"v2/community-goods-recm/m-list"
#define kMyRewardListUrl                   @"v2/community-goods-recm/reward-list"
#define kMyRewardInfoUrl                   @"v2/community-goods-recm/info"

//账号注销
#define kCancelAccountDetailsUrl           @"/v2/xlt-account-logout/logout-details"
#define kCancelAccountSendCodeUrl          @"/v2/xlt-account-logout/send-code"
#define kCancelAccountUrl                  @"/v2/xlt-account-logout/logout"
#define kCancelAccountReasonUrl            @"/v2/xlt-account-logout/reason"
#define kCancelAccountRevocationUrl        @"/v2/xlt-account-logout/revocation-logout"

//导师分享
#define kTeacherShareTutorShareListUrl     @"v2/tutor-share/list"
#define kTeacherShareTutorShareMListUrl    @"v2/tutor-share/m-list"
#define kTeacherShareSetShowStautsUrl      @"v2/tutor-share/set-status"
#define kTeacherShareSetShowTopUrl         @"v2/tutor-share/top"
#define kTeacherShareMoveListUrl           @"v2/tutor-share/move"

#endif /* XLTURLConstant_h */


