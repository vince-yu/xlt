//
//  XLTBigVContainerViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBigVContainerVC.h"
#import "JXPagerListRefreshView.h"
#import "XLTBigVContainerHeadView.h"
#import "XLTBigVGoodsListVC.h"

@interface XLTBigVContainerVC () <JXPagerViewDelegate,JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *letaoJXPagerView;
@property (nonatomic, strong) UILabel *letaoNavTitleLabel;

@property (nonatomic, strong) XLTBigVContainerHeadView *topHeadView;
@property (nonatomic, strong) UIView *letaoCustomNavView;

@end

@implementation XLTBigVContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBigVHeadView];
    self.letaoJXPagerView = [self preferredPagingView];
    self.letaoJXPagerView.backgroundColor = [UIColor clearColor];
    self.letaoJXPagerView.mainTableView.backgroundColor =[UIColor clearColor];
    self.letaoJXPagerView.pinSectionHeaderVerticalOffset = (NSInteger)kSafeAreaInsetsTop;
    self.letaoJXPagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.letaoJXPagerView];
    
    [self.letaoJXPagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self letaoSetupCustomNavView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];

}


- (void)setupBigVHeadView {
    self.topHeadView = [[NSBundle mainBundle] loadNibNamed:@"XLTBigVContainerHeadView" owner:self options:nil].lastObject;
    [self.topHeadView updateDaVData:self.letaoBigVDictionary];

}


- (void)letaoSetupCustomNavView {
    self.letaoCustomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSafeAreaInsetsTop)];
    self.letaoCustomNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.letaoCustomNavView];
    
    NSString *name = nil;
    if ([self.letaoBigVDictionary isKindOfClass:[NSDictionary class]]) {
        name = [self.letaoBigVDictionary[@"name"] isKindOfClass:[NSString class]] ? self.letaoBigVDictionary[@"name"] : nil;
    }
    
    UILabel *letaoNavTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, kStatusBarHeight, self.letaoCustomNavView.bounds.size.width - 100, 44)];
    letaoNavTitleLabel.text = name;
    letaoNavTitleLabel.hidden = YES;
    letaoNavTitleLabel.font = [UIFont letaoMediumBoldFontWithSize:18];
    letaoNavTitleLabel.textAlignment = NSTextAlignmentCenter;
    letaoNavTitleLabel.textColor = [UIColor colorWithHex:0xFF25282D];
    [self.letaoCustomNavView addSubview:letaoNavTitleLabel];
    self.letaoNavTitleLabel = letaoNavTitleLabel;
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, kStatusBarHeight , 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(letaoLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.letaoCustomNavView addSubview:leftButton];

}


- (void)letaoLeftButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.letaoJXPagerView.frame = self.view.bounds;
}

- (NSUInteger)letaoTopHeaderHeight {
    return 220;
}



- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.topHeadView;
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
    XLTBigVGoodsListVC *goodsListViewController = [[XLTBigVGoodsListVC alloc] init];
    goodsListViewController.daVId = [self daVId];
    goodsListViewController.letaonavigationController = self.navigationController;
    goodsListViewController.letaoParentPlateId = self.letaoParentPlateId;
    return goodsListViewController;
}

- (NSString *)daVId {
    return self.letaoBigVDictionary[@"_id"];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = [self letaoTopHeaderHeight] - kSafeAreaInsetsTop;
    UIView *bgImageView = self.topHeadView.bgImageView;
    if (scrollView.contentOffset.y >= thresholdDistance) {
        self.letaoNavTitleLabel.hidden = NO;
        [self.topHeadView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = (obj != bgImageView);
        }];
    } else {
        self.letaoNavTitleLabel.hidden = YES;
        [self.topHeadView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
    }
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
