//
//  XLTPrivilegeViewController.m
//  XingLeTao
//
//  Created by vince on 2020/8/24.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTPrivilegeViewController.h"

@interface XLTPrivilegeViewController ()
@property (nonatomic ,strong) UIView *navView;
@property (nonatomic ,strong) UIButton *refreshBtn;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *leftBtn;
@end

@implementation XLTPrivilegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.frame = CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight);
    [self letaoSetupCustomNavView];
}
- (void)configFullScreenLeftButton{
}
- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self letaohiddenNavigationBar:YES];
}
- (void)letaoSetupCustomNavView {
    if (self.navView == nil) {
        self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
        self.navView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.navView];


        UILabel *letaoNavTitleLabel = [[UILabel alloc] init];
        letaoNavTitleLabel.text = @"尊享特权";
        letaoNavTitleLabel.textColor = [UIColor blackColor];
        letaoNavTitleLabel.font = [UIFont letaoMediumBoldFontWithSize:18.0];
        letaoNavTitleLabel.textAlignment = NSTextAlignmentCenter;
        letaoNavTitleLabel.frame = CGRectMake(0, kStatusBarHeight, self.navView.bounds.size.width, 44);
        self.titleLabel = letaoNavTitleLabel;
        [self.navView addSubview:letaoNavTitleLabel];
        if (self.needBack) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.frame = CGRectMake(0, kStatusBarHeight, 50, 44);
            [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
            leftButton.tag = 45564;
            [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            [self.navView addSubview:leftButton];
            self.leftBtn = leftButton;
            self.leftBtn.hidden = YES;
        }
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake(kScreenWidth - 50, kStatusBarHeight, 50, 44);
        [refreshButton setImage:[UIImage imageNamed:@"nav_refresh_icon"] forState:UIControlStateNormal];
        refreshButton.tag = 45564;
        [refreshButton addTarget:self action:@selector(refreshWebAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:refreshButton];
    }
    
}
- (void)backAction{
    if (self.webView.wkWebView.canGoBack) {
        [self.webView.wkWebView goBack];
    }
}
- (void)refreshWebAction {
    //测试用的
//    self.jump_URL = [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202008privilege/index.html"];
//    [self webViewloadRequest];
    
    [self.webView reloadData];
}
- (void)webView:(XLTWebView *)webView diChangeNavigationItemTitle:(NSString *)navigationItemTitle {
    self.titleLabel.text = webView.navigationItemTitle;
    self.leftBtn.hidden = !self.webView.wkWebView.canGoBack;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
