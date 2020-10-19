//
//  CZBInfoManager.h
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol CZBInfoManagerDelegate <NSObject>

/**
 CZBInfoManagerDelegate代理方法,实现代理可定制自己的导航方法

 @param startLat 起点的维度
 @param startLng 起点的经度
 @param endLat 终点的维度
 @param endLng 终点的经度
 */
- (void)czbNavigation:(NSString *)startLat startLng:(NSString *)startLng endLat:(NSString *)endLat endLng:(NSString *)endLng;

@end

@interface CZBInfoManager : NSObject
/// 单例对象
+ (CZBInfoManager *)shared;
/// 代理对象,如果需要定制导航方法,在代理中实现即可,如不需要则无需实现,默认会打开手机中安装的地图进行导航
@property (nonatomic, weak) id<CZBInfoManagerDelegate> delegate;
/// 注册webview和平台的scheme
+ (void)registerWebView:(WKWebView *)webView;

/**
 设置UA

 @param userAgent UA 合作方拼⾳缩写+IOS
 @param webView WKWebView
 @param completion 完成回掉
 */
+ (void)setUserAgent:(NSString *)userAgent webView:(WKWebView *)webView completion:(void(^)(void))completion;
/// 支付过程中拦截支付信息
+ (BOOL)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction;
@end

NS_ASSUME_NONNULL_END
