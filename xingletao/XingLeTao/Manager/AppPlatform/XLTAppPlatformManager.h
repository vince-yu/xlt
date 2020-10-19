//
//  XLTAppPlatformManager.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger, XLTAppPlatformServerType) {
    XLTAppPlatformServerReleaseType = 0,                         
    XLTAppPlatformServerTestType,
    XLTAppPlatformServerBetaType
};

@interface XLTAppPlatformManager : NSObject

// 优惠券是否有效
@property (nonatomic, assign) BOOL isLimitModel;
@property (nonatomic, assign) BOOL checkEnable;
@property (nonatomic, assign) BOOL debugModel;
@property (nonatomic, assign) BOOL showVipBuy;
@property (nonatomic, strong) NSDictionary *goodsPlatformConfigInfo;
@property (nonatomic, strong) NSDictionary *suportPlatformInfo;

@property (nonatomic, assign) XLTAppPlatformServerType serverType;
@property (nonatomic, assign) NSInteger letaoPasteboardChangeCount;
+ (instancetype)shareManager;

- (NSString *)appVersion;

// 订单分享提示
- (BOOL)isOrderShareTipSwitchOff;

- (void)orderShareTipSwitchOff:(BOOL)off;

- (void)xingletaonetwork_requestConfig;
- (void)xingletaonetwork_requestLimitModelStatus:(nullable void(^)(void))completeBlock;
- (void)requestSupportGoodsPlatform;
- (BOOL)isXinletaoSafeWebDomain:(NSString *)webDomain;
- (void)showbindWXTipViewIfNeed;
- (void)showbindInviterVC;

- (NSString *)baseH5SeverUrl;
- (NSString *)baseACH5SeverUrl;

- (NSString *)baseApiSeverUrl;

- (NSString *)repoApiSeverUrl;

// 检查剪贴板商品信息
- (void)checkPasteboardGoodsInfo;

- (void)saveGoodsPasteboardValue:(NSString *)string;

- (NSString *)platformText:(NSString *)text;

/// 商品Source Text
- (NSString *)letaoSourceTextForType:(NSString *)type;

/**
*  首页支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/
- (NSArray *)supportGoodsPlatformArrayForHome;

/**
*  订单中心支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/

- (NSArray *)supportGoodsPlatformArrayForOrder;


/**
*  搜索支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/

- (NSArray *)supportGoodsPlatformArrayForSearch;


/**
*  收益表报、我的收益支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/

- (NSArray *)supportGoodsPlatformArrayForMyIncome;



- (void)palyTeachingVideoIfNeed;

- (BOOL)isFristInstall;

- (BOOL)isDidPalyTeachingVideo;

- (void)didPalyTeachingVideo:(BOOL)flag;

/// 用户协议

- (BOOL)isAgreedUserAgreement;

- (void)agreedUserAgreement:(BOOL)flag;


// 未下单的用户（包含下单后又失效的用户），需要弹0元购弹窗,免单弹窗每天只弹一次
- (void)clearZeroBuyAdInfo;

- (BOOL)todayZeroBuyAdShowState;

- (void)makeLocalZeroBuyAddDateInfo;




// 新用户注册后，第二次进入我的页面，弹联系导师
- (BOOL)isNeedPopContactInstructor;
- (void)needPopContactInstructorState:(NSNumber *)state;
- (void)increasePopContactInstructorCountIfNeed;
@end

NS_ASSUME_NONNULL_END
