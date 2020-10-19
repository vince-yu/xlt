//
//  XLTCancelAccountVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTCancelAccountVC.h"
#import "XLTCancelAccountLogic.h"
#import "XLTCancelAccountResultVC.h"
#import "XLTCancelAccountFirstStepVC.h"
#import "XLTCancelAccountLogic.h"
#import "LetaoEmptyCoverView.h"
#import "XLTUserManager.h"

@interface XLTCancelAccountVC ()
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;
@end

@implementation XLTCancelAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![[XLTUserManager shareManager].curUserInfo.is_logout boolValue]) {
        [self showFirstStepVC];
    }else{
        [self requestData];
    }
    
    self.title = @"账号注销";
}
- (void)requestData{
    [self letaoShowLoading];
    XLT_WeakSelf;
    [XLTCancelAccountLogic requestAccountInfoSuccess:^(NSDictionary * _Nonnull info) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        if ([info[@"status"] integerValue] == 1) {
            [self showResultVC:info[@"itime"]];
        }else{
            [self showFirstStepVC];
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self letaoShowErrorView];
        [self showTipMessage:errorMsg];
    }];
}
- (void)letaoShowErrorView {
    if (self.letaoErrorView == nil) {
        __weak typeof(self)weakSelf = self;
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"xinletao_page_error"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  [weakSelf letaoRemoveErrorView];
                                                                  [weakSelf requestData];
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 28.f;
        letaoEmptyCoverView.contentViewOffset = - 50;
        
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:14.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        letaoEmptyCoverView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        letaoEmptyCoverView.actionBtnTitleColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnHeight = 40.f;
        letaoEmptyCoverView.actionBtnHorizontalMargin = 62.f;
        letaoEmptyCoverView.actionBtnCornerRadius = 20.f;
        letaoEmptyCoverView.actionBtnBorderColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnBorderWidth = 0.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = self.view.backgroundColor;
        self.letaoErrorView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoErrorView];
}

- (void)letaoRemoveErrorView {
    [self.letaoErrorView removeFromSuperview];
}
- (void)showResultVC:(NSNumber *)time {
    XLTCancelAccountResultVC *resultVC = [[XLTCancelAccountResultVC alloc] init];
    resultVC.time = time;
    [self addChildViewController:resultVC];
    [self.view addSubview:resultVC.view];
    resultVC.view.frame = self.view.bounds;
    [resultVC didMoveToParentViewController:self];
    resultVC.time = time;
}

- (void)showFirstStepVC {
    XLTCancelAccountFirstStepVC *firstStepVC = [[XLTCancelAccountFirstStepVC alloc] init];
    [self addChildViewController:firstStepVC];
    [self.view addSubview:firstStepVC.view];
    firstStepVC.view.frame = self.view.bounds;
    [firstStepVC didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
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
