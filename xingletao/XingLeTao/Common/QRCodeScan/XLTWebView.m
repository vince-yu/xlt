//
//  SGWebView.m
//  SGWebViewExample
//
//  Created by kingsic on 17/3/27.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "XLTWebView.h"

@interface XLTWebView () <WKNavigationDelegate, WKUIDelegate>

@end

@implementation XLTWebView

static CGFloat const progressViewHeight = 2;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.wkWebView];
        [self addSubview:self.progressView];
        [self setIsNavigationBarOrTranslucent:NO];
    }
    return self;
}

+ (instancetype)webViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc]init];
        // 视频页面播放支持
         if (@available(iOS 10.0, *)) {
            webViewConfig.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        } else {
            // Fallback on earlier versions
        }
        webViewConfig.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        webViewConfig.allowsAirPlayForMediaPlayback = YES;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:webViewConfig];
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        // KVO
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
        [self.wkWebView addObserver:self forKeyPath:@"title" options:0 context:nil];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
        // 高度默认有导航栏且有穿透效果
        _progressView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.frame.size.width, progressViewHeight);
        // 设置进度条颜色
        _progressView.tintColor = [UIColor greenColor];
    }
    return _progressView;
}

- (void)setProgressViewColor:(UIColor *)progressViewColor {
    _progressViewColor = progressViewColor;
    
    if (progressViewColor) {
        _progressView.tintColor = progressViewColor;
    }
}

- (void)setIsNavigationBarOrTranslucent:(BOOL)isNavigationBarOrTranslucent {
    _isNavigationBarOrTranslucent = isNavigationBarOrTranslucent;
    
    if (isNavigationBarOrTranslucent == YES) { // 导航栏存在且有穿透效果
        _progressView.frame = CGRectMake(0, kSafeAreaInsetsTop, self.frame.size.width, progressViewHeight);
    } else { // 导航栏不存在或者没有有穿透效果
        _progressView.frame = CGRectMake(0, 0, self.frame.size.width, progressViewHeight);
    }
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        self.progressView.alpha = 1.0;
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        if(self.wkWebView.estimatedProgress >= 0.97) {
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"] && object == self.wkWebView) {
         self.navigationItemTitle = self.wkWebView.title;
        if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:diChangeNavigationItemTitle:)]) {
            [self.webViewDelegate webView:self diChangeNavigationItemTitle:self.wkWebView.title];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - - - 加载的状态回调（WKNavigationDelegate）
/// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:self];
    }
}
/// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didCommitWithURL:)]) {
        [self.webViewDelegate webView:self didCommitWithURL:self.wkWebView.URL];
    }
}
/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFinishLoadWithURL:)]) {
        [self.webViewDelegate webView:self didFinishLoadWithURL:self.wkWebView.URL];
    }
    self.progressView.alpha = 0.0;
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:self didFailLoadWithError:error];
    }
    
    self.progressView.alpha = 0.0;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.webViewDelegate webView:self decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/// 加载 web
- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}
/// 加载 HTML
- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}
/// 刷新数据
- (void)reloadData {
    [self.wkWebView reload];
}

/// dealloc
- (void)dealloc {    
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}


@end
