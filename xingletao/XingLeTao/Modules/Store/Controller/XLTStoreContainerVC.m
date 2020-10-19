//
//  XLTStoreContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTStoreContainerVC.h"
#import "JXPagerListRefreshView.h"
#import "XLTStoreTopHeadView.h"
#import "XLTStoreViewController.h"
#import "XLTStoreLogic.h"


@interface XLTStoreContainerVC () <JXPagerViewDelegate,JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) UIView *letaoCustomNavView;
@property (nonatomic, strong) UILabel *letaoNavTitleLabel;

@property (nonatomic, strong) XLTStoreTopHeadView *storeHeadView;
@end

@implementation XLTStoreContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadStoreHeadView];
    self.pagerView = [self preferredPagingView];
    self.pagerView.backgroundColor = [UIColor clearColor];
    self.pagerView.mainTableView.backgroundColor =[UIColor clearColor];
    self.pagerView.pinSectionHeaderVerticalOffset = (NSInteger)kSafeAreaInsetsTop;
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];

    [self letaoSetupCustomNavView];
    
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];

    [self requestStoreInfo];
}

// 获取店铺信息
- (void)requestStoreInfo {
    NSString *seller_type = self.letaoStoreDictionary[@"seller_type"];
    [[[XLTStoreLogic alloc] init] xingletaonetwork_requestStoreInfoWithStoreId:self.letaoStoreId
                                                                    sellerType:seller_type
                                                                       success:^(NSDictionary * _Nonnull letaoStoreDictionary) {
        // do nothing
    } failure:^(NSString * _Nonnull errorMsg) {
        // do nothing
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];

}

- (void)letaoSetupCustomNavView{
    self.letaoCustomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
    self.letaoCustomNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.letaoCustomNavView];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(12, kStatusBarHeight +2, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"xinletao_gooddetail_graybackground_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(letaoLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:leftButton];
    
    UILabel *letaoNavTitleLabel = [[UILabel alloc] init];
    letaoNavTitleLabel.text = [self storeName];
    letaoNavTitleLabel.font = [UIFont letaoRegularFontWithSize:18.0];
    letaoNavTitleLabel.textAlignment = NSTextAlignmentLeft;
    letaoNavTitleLabel.frame = CGRectMake(12+40+15, kStatusBarHeight, self.letaoCustomNavView.bounds.size.width -  (12+40+15) - 15, 44);
    letaoNavTitleLabel.textColor = [UIColor colorWithHex:0xFF25282D];
    letaoNavTitleLabel.adjustsFontSizeToFitWidth = YES;
    letaoNavTitleLabel.alpha = 0;
    self.letaoNavTitleLabel = letaoNavTitleLabel;
    [self.letaoCustomNavView addSubview:letaoNavTitleLabel];

}

- (void)loadStoreHeadView {
    self.storeHeadView = [[NSBundle mainBundle] loadNibNamed:@"XLTStoreTopHeadView" owner:self options:nil].lastObject;
    [self.storeHeadView letaoUpdateStoreWithDictionary :self.letaoStoreDictionary];

}



- (NSString *)storeName {
    if ([self.letaoStoreDictionary isKindOfClass:[NSDictionary class]]) {
        NSString *storeNameString = self.letaoStoreDictionary[@"seller_shop_name"];
        if ([storeNameString isKindOfClass:[NSString class]]) {
            return storeNameString;;
        }
    }
    return nil;
}


- (void)letaoLeftButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = [self letaoTopHeaderHeight] - kSafeAreaInsetsTop;
    if (scrollView.contentOffset.y >= thresholdDistance) {
        self.letaoNavTitleLabel.alpha = 1.0;
        [self.storeHeadView letaoHiddenStoreInfo:YES];
    } else {
        self.letaoNavTitleLabel.alpha = 0;
        [self.storeHeadView letaoHiddenStoreInfo:NO];
    }
}


- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = self.view.bounds;
}

- (NSUInteger)letaoTopHeaderHeight {
    return 170;
}



- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.storeHeadView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
 
    return [self letaoTopHeaderHeight];;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 1;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 1;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    XLTStoreViewController *storeViewController = [[XLTStoreViewController alloc] init];
    storeViewController.letaoStoreId = self.letaoStoreId;
    if ([self.letaoStoreDictionary isKindOfClass:[NSDictionary class]]) {
        storeViewController.letaoStoreSource = self.letaoStoreDictionary[@"seller_type"];
    }
    storeViewController.letaonavigationController = self.navigationController;
    return storeViewController;
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
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
