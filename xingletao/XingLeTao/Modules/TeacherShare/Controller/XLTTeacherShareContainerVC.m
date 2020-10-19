//
//  XLTTeacherShareContainerVC.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareContainerVC.h"
#import "XLTScrolledPageView.h"
#import "HMSegmentedControl.h"
#import "XLTTeacherShareListVC.h"
#import "XLTTeacherShareEmptyVC.h"
#import "NSArray+Bounds.h"
#import "XLTTeacherShareLogic.h"
#import "XLTTeacherShareTipView.h"

@interface XLTTeacherShareContainerVC ()<XLTScrolledPageViewViewDelegate, XLTScrolledPageViewDataSource,XLTTeacherShareListVCDelegate>
@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, strong) XLTScrolledPageView *letaoScrolledPageView;
@property (nonatomic,assign) NSInteger letaoCurrentPageIndex;

@property (nonatomic, strong) XLTTeacherShareListVC *allListVC;
@property (nonatomic, strong) XLTTeacherShareListVC *showListVC;
@property (nonatomic ,strong) NSMutableArray *listVCArray;
@property (nonatomic ,strong) XLTTeacherShareEmptyVC *emptyVC;
@property (nonatomic ,strong) XLTTeacherShareTipView *tipView;

@end

@implementation XLTTeacherShareContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导师分享";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tipView.frame = CGRectMake(0, 0, kScreenWidth, 45);
    [self.view addSubview:self.tipView];
    self.tipView.backgroundColor = [UIColor colorWithHex:0xF5F5F7];
    
    [self configSegement];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    self.emptyVC.view.frame = CGRectMake(0, 45, kScreenWidth, self.view.height - 45);
    [self.view addSubview:self.emptyVC.view];
    self.emptyVC.view.hidden = YES;
    [self.emptyVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.mas_equalTo(45);
    }];
    
    self.letaoSegmentedControl.frame = CGRectMake(0, 45, kScreenWidth, 50);
    [self.view addSubview:self.letaoSegmentedControl];
    self.letaoSegmentedControl.hidden = YES;
    [self.letaoSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(45);
        make.height.mas_equalTo(50);
    }];
    
    self.letaoScrolledPageView.frame = CGRectMake(0, 95, kScreenWidth, self.view.height - 95);
    [self.view addSubview:self.letaoScrolledPageView];
    self.letaoScrolledPageView.hidden = YES;
    [self.letaoScrolledPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.mas_equalTo(95);
    }];
    
}
- (XLTScrolledPageView *)letaoScrolledPageView{
    if (!_letaoScrolledPageView) {
        CGRect pageRect = CGRectMake(0,  95, self.view.bounds.size.width, kScreenHeight - 95 - kTopHeight);
        _letaoScrolledPageView = [[XLTCustomScrolledPageView alloc] initWithFrame:pageRect];
        _letaoScrolledPageView.backgroundColor = [UIColor clearColor];
        _letaoScrolledPageView.shouldPreLoadSiblings = YES;
        _letaoScrolledPageView.delegate = (id)self;
        _letaoScrolledPageView.dataSource = (id)self;
        _letaoScrolledPageView.scrollView.scrollEnabled = YES;
    }
    return _letaoScrolledPageView;
}
- (void)updateContentView:(BOOL )isEmpty{
    self.letaoSegmentedControl.hidden = isEmpty;
    self.letaoScrolledPageView.hidden = isEmpty;
    self.emptyVC.view.hidden = !isEmpty;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBarWithNoLine];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self letaoTriggerRefresh];
    [self allRefresh];
}
- (XLTTeacherShareTipView *)tipView{
    if (!_tipView) {
        _tipView = [[XLTTeacherShareTipView alloc] initWithNib];
        _tipView.letaoNav = self.navigationController;
    }
    return _tipView;
}
- (NSMutableArray *)listVCArray{
    if (!_listVCArray) {
        _listVCArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < _letaoSegmentedControl.sectionTitles.count; i ++) {
            XLTTeacherShareListVC *vc = [[XLTTeacherShareListVC alloc] init];
            vc.letaoNav = self.navigationController;
            vc.containVC = self;
            vc.deletgate = self;
            if (i == 0) {
                vc.type = 1;
            }else{
                vc.status = @2;
                vc.type = 2;
            }
            
            [_listVCArray addObject:vc];
        }
    }
    return _listVCArray;
}
- (void)letaoTriggerRefresh {
    XLT_WeakSelf;
    [self letaoShowLoading];
    [XLTTeacherShareLogic getTutorShareListFromMineWithStatus:nil index:@"1" page:@"5" success:^(id  _Nonnull object) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self updateContentView:![object count]];
    } failure:^(NSString * _Nonnull errorMsg) {
        XLT_StrongSelf;
        [self letaoRemoveLoading];
        [self updateContentView:YES];
    }];
}
- (XLTTeacherShareEmptyVC *)emptyVC{
    if (!_emptyVC) {
        _emptyVC = [[XLTTeacherShareEmptyVC alloc] init];
        _emptyVC.letaoNav = self.navigationController;
    }
    return _emptyVC;
}
- (void)showEmptyVC{
    
}
- (void)configSegement{
    _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth -20, 44)];
    _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _letaoSegmentedControl.backgroundColor = [UIColor whiteColor];
    _letaoSegmentedControl.selectionIndicatorHeight = 2.5;
    _letaoSegmentedControl.selectionIndicatorWidth = 23;
    _letaoSegmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0xFF8202];
//    _letaoSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 10);
    _letaoSegmentedControl.type = HMSegmentedControlTypeText;
    _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _letaoSegmentedControl.selectionStyle = HMSegmentedControlTypeText;
    _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0x26282E]};
    _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF8202]};
    _letaoSegmentedControl.sectionTitles = @[@"所有文档",@"展示中的文档"];
    [_letaoSegmentedControl addTarget:self action:@selector(letaoSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
}
- (void)letaoSegmentedValueChanged:(HMSegmentedControl *)segmentedControl {
    [_letaoScrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.letaoCurrentPageIndex = segmentedControl.selectedSegmentIndex;
}
#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    if ([XLTAppPlatformManager shareManager].isLimitModel) {
        return 1;
    } else {
        return _letaoSegmentedControl.sectionTitles.count;
    }
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    XLTTeacherShareListVC *vc = [self.listVCArray by_ObjectAtIndex:pageIndex];
//    [vc letaoTriggerRefresh];
    return vc;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_letaoScrolledPageView.currentPageIndex < self.letaoSegmentedControl.sectionTitles.count) {
        [self.letaoSegmentedControl setSelectedSegmentIndex:_letaoScrolledPageView.currentPageIndex animated:YES];
        self.letaoCurrentPageIndex = _letaoScrolledPageView.currentPageIndex;
    }
}
#pragma mark XLTTeacherShareListVCDelegate

- (void)loadDataCompelete:(NSNumber *)status empty:(BOOL)nodata{
    
}
- (void)allRefresh{
    for (XLTTeacherShareListVC *vc in self.listVCArray) {
        [vc letaoTriggerRefresh];
    }
}

@end
