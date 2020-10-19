
#import <UIKit/UIKit.h>
#import "XLTBaseViewController.h"
#import "XLTWebView.h"

typedef enum : NSUInteger {
    XLTPopBackTopType,
    XLTPopBackRootType
} XLTPopBackType;

@interface XLTWKWebViewController : XLTBaseViewController
/** 判断从哪个控制器 push 过来 */
@property (nonatomic, assign) XLTPopBackType popBackType;
/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;

@property (nonatomic , strong) XLTWebView *webView;
@property (nonatomic , assign) BOOL fullScreen;
@property (nonatomic , assign) BOOL showActivityShareButton;
@property (nonatomic ,assign) BOOL showCloseBtn;
@property (nonatomic , assign) BOOL isLightBarStyle;
@property (nonatomic, weak) UINavigationController *xlt_navigationController;

/** 是否处理商品活动调整  默认是YES*/
@property (nonatomic , assign) BOOL shouldDecideGoodsActivity;


///** 是否处淘宝/唯品会/拼多多 Scheme 默认 NO*/
@property (nonatomic , assign) BOOL disableTbPddVphScheme;

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)webViewloadRequest;

/** 使用web协议打开*/
- (void)webViewAskOpenPage:(NSString *)url showActivityShareButton:(BOOL)show;
 // 扫一扫
- (void)webViewOpenQRCodeScanPage:(NSDictionary *)data closepage:(NSNumber *)closepage;
@end
