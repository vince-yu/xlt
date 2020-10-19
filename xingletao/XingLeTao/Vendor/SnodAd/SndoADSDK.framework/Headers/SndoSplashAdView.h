//
//  SndoSplashAdView.h
//  SndoADSDK
//
//  Created by vince on 2020/7/21.
//  Copyright © 2020 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SndoADDataManger.h"

@class SndoSplashAdView;

@protocol SndoSplashAdViewDelegate <NSObject>
@optional
/**
 *  广告展示结束
 */
- (void)adViewfinish:(SndoSplashAdView *)splash;

/**
 *  广告加载完并成功
 */
- (void)successAdLoadView:(SndoSplashAdView *)splash;
/**
 *  广告加载结束且失败
 */
- (void)errorAdLoadView:(SndoMobleErrorReason )error withDescription:(NSString *)errorString;

/**
 *  用户点击广告
 */
- (void)userClickedAd:(SndoSplashAdView *)splash withCurrentURL:(NSString *)currentUrl;

/**
 * 广告网页返回代理
 */
- (void)adGoBackFromWebView;
@end

@interface SndoSplashAdView : UIView
/**
 *  设置/获取广告位id
 */
@property (nonatomic, copy) NSString *ADID;
/**
 * 倒计时时间多少S(默认3S,最少3S)
 */
@property (nonatomic, assign) NSInteger countDownTime;
/**
 *是否使用safeArea
 **/
@property (nonatomic, assign) BOOL showCountDownTime;

/**
 * 设置横竖屏展示(默认NO)
 */
@property (nonatomic, assign) BOOL isHorizontal;
/**
 *  设置开屏广告是否可以点击的属性,开屏默认可以点击。
 */
@property (nonatomic) BOOL canSplashClick;
/**
 * 代理
 */
@property (nonatomic, weak)id <SndoSplashAdViewDelegate> delegate;

/**
 *  设置是否在广告请求时显示进度菊花(默认YES)
 */
@property (nonatomic, assign) BOOL isShowIndicatorView;
/**
 *  点击广告是否在Safari中打开，默认为NO，在app内部跳转
 */
@property (nonatomic, assign) BOOL isOpenWeb;
/**
 *  点击广告是否用户自己处理，默认为NO，在app内部跳转
 */
@property (nonatomic, assign) BOOL customHandleClick;
/**
*  发起拉取广告请求，只拉取不展示
*  详解：广告素材及广告图片拉取成功后会回调splashAdDidLoad方法，当拉取失败时会回调splashAdFailToPresent方法
*/
- (SndoSplashAdView *)initWithPlacementId:(NSString *)adId;
/**
 *  发起拉取广告请求，只拉取不展示
 *  详解：广告素材及广告图片拉取成功后会回调splashAdDidLoad方法，当拉取失败时会回调splashAdFailToPresent方法
 */
- (void)loadAd;

/**
 *  展示广告，调用此方法前需调用isAdValid方法判断广告素材是否有效
 *  详解：广告展示成功时会回调splashAdSuccessPresentScreen方法，展示失败时会回调splashAdFailToPresent方法
 */
- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView;
/**
 * 返回广告是否可展示
 * 对于并行请求，在调用showAdInWindow前时需判断下
 * @return 当广告已经加载完成且未曝光时，为YES，否则为NO
 */
- (BOOL)isAdValid;
/**
* 关闭广告
*/
- (void)closeAD;
@end

