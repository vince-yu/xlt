//
//  XLTTeachShareWebVC.m
//  XingLeTao
//
//  Created by vince on 2020/9/29.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeachShareWebVC.h"

@interface XLTTeachShareWebVC ()

@end

@implementation XLTTeachShareWebVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jump_URL = @"https://www.youku.com/";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeScreen:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)didChangeScreen:(NSNotification *)note{
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statu
//    [self switchNewOrientation:UIInterfaceOrientationPortrait];
    
}
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{

        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];

        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];

        NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];

        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];

}
- (void)webView:(XLTWebView *)webView diChangeNavigationItemTitle:(NSString *)navigationItemTitle {
    self.title = webView.navigationItemTitle;
    self.showCloseBtn = self.webView.wkWebView.canGoBack;
}
@end
