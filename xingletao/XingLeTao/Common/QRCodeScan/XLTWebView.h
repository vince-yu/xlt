//
//  SGWebView.h
//  SGWebViewExample
//
//  Created by kingsic on 17/3/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//
//  SGWebView 使用注意点：
//  如果 self.navigationController.navigationBar.translucent = NO；或者导航栏不存在; 那么 SGWebView 的 isNavigationBarOrTranslucent属性 必须设置 NO)

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class XLTWebView;

@protocol XLTWebViewDelegate <NSObject>
@optional
/** 页面开始加载时调用 */
- (void)webViewDidStartLoad:(XLTWebView *)webView;
/** 内容开始返回时调用 */
- (void)webView:(XLTWebView *)webView didCommitWithURL:(NSURL *)url;
/** 页面加载失败时调用 */
- (void)webView:(XLTWebView *)webView didFinishLoadWithURL:(NSURL *)url;
/** 页面加载完成之后调用 */
- (void)webView:(XLTWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)webView:(XLTWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;


- (void)webView:(XLTWebView *)webView diChangeNavigationItemTitle:(NSString *)navigationItemTitle;

@end

@interface XLTWebView : UIView
/** SGDelegate */
@property (nonatomic, weak) id<XLTWebViewDelegate> webViewDelegate;
/** 进度条颜色(默认蓝色) */
@property (nonatomic, strong) UIColor *progressViewColor;
/** 导航栏标题 */
@property (nonatomic, copy) NSString *navigationItemTitle;
/** 导航栏存在且有穿透效果(默认导航栏存在且有穿透效果) */
@property (nonatomic, assign) BOOL isNavigationBarOrTranslucent;

/** 类方法创建 SGWebView */
+ (instancetype)webViewWithFrame:(CGRect)frame;
/** 加载 web */
- (void)loadRequest:(NSURLRequest *)request;
/** 加载 HTML */
- (void)loadHTMLString:(NSString *)HTMLString;
/** 刷新数据 */
- (void)reloadData;


/// WKWebView
@property (nonatomic, strong) WKWebView *wkWebView;
/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;
@end
