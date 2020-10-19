//
//  XLTNineYuanNinePlateContainerVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/20.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNineYuanNineContainerVC.h"
#import "XLTScrolledPageView.h"
#import "XLTNineYuanNineSecondContainerVC.h"
#import "LetaoEmptyCoverView.h"
#import "HMSegmentedControl.h"
#import "XLTNineYuanNineSecondContainerVC.h"
#import "XLTNineYuanNineListVC.h"

@interface XLTNineYuanNineHeadView : UIView
@property (nonatomic, strong) UIImageView *letaobgImageView;
@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, strong) UIImageView *indicatorLeftImageView;
@property (nonatomic, strong) UIImageView *indicatorRightImageView;
- (void)changeLayoutWithSelectIndex:(NSInteger )index;
@end

@implementation XLTNineYuanNineHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _letaobgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFFAE01]] gradientType:0 imgSize:_letaobgImageView.bounds.size];
        _letaobgImageView.image = bgImage;
        [self addSubview:_letaobgImageView];
        
        _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 36, self.bounds.size.width,  36)];
        _letaoSegmentedControl.backgroundColor = [UIColor letaomainColorSkinColor];
        _letaoSegmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0xFFF5F5F7];
        _letaoSegmentedControl.sectionTitles = @[@"淘宝",@"拼多多",@"京东"];
        _letaoSegmentedControl.type = HMSegmentedControlTypeText;
        _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
        _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
        _letaoSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _letaoSegmentedControl.selectionIndicatorBoxColor = [UIColor colorWithHex:0xFFF5F5F7];
        _letaoSegmentedControl.selectionIndicatorBoxOpacity = 1.0;
        _letaoSegmentedControl.shouldAnimateUserSelection = NO;
        [self addSubview:_letaoSegmentedControl];
    
        _indicatorLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 45.5)/3, self.bounds.size.height - 36, 45.5, 36)];
        _indicatorLeftImageView.image = [UIImage imageNamed:@"nineyuannine_indicator1"];
        _indicatorLeftImageView.backgroundColor = [UIColor letaomainColorSkinColor];
        [self addSubview:_indicatorLeftImageView];
        
        _indicatorRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 45.5)/3 * 2, self.bounds.size.height - 36, 45.5, 36)];
        _indicatorRightImageView.image = [UIImage imageNamed:@"nineyuannine_indicator2"];
        _indicatorRightImageView.backgroundColor = [UIColor letaomainColorSkinColor];
        _indicatorRightImageView.hidden = YES;
        [self addSubview:_indicatorRightImageView];
        
        
        [_letaoSegmentedControl addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(10.0, 10.0)];
    }
    return self;
}
- (void)changeLayoutWithSelectIndex:(NSInteger )index{
    if (index == 0) {
        self.indicatorLeftImageView.hidden = NO;
        self.indicatorRightImageView.hidden = YES;
        self.indicatorLeftImageView.image = [UIImage imageNamed:@"nineyuannine_indicator1"];
        self.indicatorLeftImageView.frame = CGRectMake((self.bounds.size.width - 45.5)/3, self.bounds.size.height - 36, 45.5, 36);
    } else if (index == 1){
        self.indicatorLeftImageView.hidden = NO;
        self.indicatorRightImageView.hidden = NO;
        self.indicatorLeftImageView.image = [UIImage imageNamed:@"nineyuannine_indicator2"];
        self.indicatorRightImageView.image = [UIImage imageNamed:@"nineyuannine_indicator1"];
        self.indicatorLeftImageView.frame = CGRectMake((self.bounds.size.width - 45.5)/3 - 45.5/2, self.bounds.size.height - 36, 45.5, 36);
        self.indicatorRightImageView.frame = CGRectMake((self.bounds.size.width - 45.5)/3 * 2 + 45.5/2, self.bounds.size.height - 36, 45.5, 36);
    }else{
        self.indicatorLeftImageView.hidden = YES;
        self.indicatorRightImageView.hidden = NO;
        self.indicatorRightImageView.image = [UIImage imageNamed:@"nineyuannine_indicator2"];
        self.indicatorRightImageView.frame = CGRectMake((self.bounds.size.width - 45.5)/3 * 2, self.bounds.size.height - 36, 45.5, 36);
    }
}





@end


@interface XLTNineYuanNineContainerVC ()

@property (nonatomic, strong) XLTNineYuanNineHeadView *letaoTopHeadView;
@property (nonatomic, strong) XLTScrolledPageView *scrolledPageView;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoEmptyCoverView;
@property (nonatomic, strong) LetaoEmptyCoverView *letaoErrorView;
@end

@implementation XLTNineYuanNineContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self letaoSetupTopHeadView];
    [self bulidPages];
    self.title = @"9.9包邮";
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoconfigTranslucentNavigation];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)letaoShowLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)letaoSetupTopHeadView {
    XLTNineYuanNineHeadView *letaoTopHeadView = [[XLTNineYuanNineHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSafeAreaInsetsTop + 36)];
    [letaoTopHeadView.letaoSegmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:letaoTopHeadView];
    self.letaoTopHeadView = letaoTopHeadView;
}

- (void)bulidPages {
    CGRect pageRect = CGRectMake(0, CGRectGetMaxY(self.letaoTopHeadView.frame), self.view.bounds.size.width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.letaoTopHeadView.frame));
    _scrolledPageView = [[XLTScrolledPageView alloc] initWithFrame:pageRect];
    _scrolledPageView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
    _scrolledPageView.shouldPreLoadSiblings = NO;
    _scrolledPageView.delegate = (id)self;
    _scrolledPageView.dataSource = (id)self;
    _scrolledPageView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrolledPageView];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [self.letaoTopHeadView changeLayoutWithSelectIndex:segmentedControl.selectedSegmentIndex];
    [_scrolledPageView goToPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
    self.currentPageIndex = segmentedControl.selectedSegmentIndex;
}

#pragma mark - ScrolledPageViewViewDelegate & ScrolledPageViewDataSource

- (NSUInteger)numberOfPages {
    return 3;
}

- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex {
    NSString *letaoChannelId = nil;
    switch (pageIndex) {
        case 0:
            letaoChannelId = XLTTaobaoPlatformIndicate;
            break;
        case 1:
            letaoChannelId = XLTPDDPlatformIndicate;
            break;
        case 2:
            letaoChannelId = XLTJindongPlatformIndicate;
            break;
        default:
            break;
    }
    UIViewController *viewController = [self pageViewControllerForChannelCode:letaoChannelId];
    
    if (viewController == nil) {
        viewController = [self letaoCreatePageVcForChannelCode:letaoChannelId];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    return viewController;
}

- (UIViewController *)pageViewControllerForChannelCode:(NSString *)letaoChannelId {
    __block XLTNineYuanNineSecondContainerVC *viewController = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLTNineYuanNineSecondContainerVC class]]
            || [obj isKindOfClass:[XLTNineYuanNineListVC class]]) {
            viewController = obj;
            if ([viewController.item_source isEqualToString:letaoChannelId]) {
                *stop = YES;
            } else {
                viewController = nil;
            }
        }
    }];
    return viewController;
}

- (UIViewController *)letaoCreatePageVcForChannelCode:(NSString *)letaoChannelId {
    if ([letaoChannelId isEqualToString:XLTTaobaoPlatformIndicate]) {
        XLTNineYuanNineSecondContainerVC *listViewController = [[XLTNineYuanNineSecondContainerVC alloc] init];
        listViewController.item_source = letaoChannelId;
        return listViewController;
    } else {
        XLTNineYuanNineListVC *listViewController = [[XLTNineYuanNineListVC alloc] init];
        listViewController.item_source = letaoChannelId;
        return listViewController;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrolledPageView.currentPageIndex < self.letaoTopHeadView.letaoSegmentedControl.sectionTitles.count) {
        [self.letaoTopHeadView.letaoSegmentedControl setSelectedSegmentIndex:_scrolledPageView.currentPageIndex animated:NO];
        self.currentPageIndex = _scrolledPageView.currentPageIndex;
        [self.letaoTopHeadView changeLayoutWithSelectIndex:self.currentPageIndex];
    }
}


- (void)letaoShowEmptyView {
    if (self.letaoEmptyCoverView == nil) {
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"page_empty"
                                                                   titleStr:@"暂无数据"
                                                                  detailStr:@""
                                                                btnTitleStr:@""
                                                              btnClickBlock:^(){
                                                                  // do nothings
                                                              }];
        letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = YES;
        letaoEmptyCoverView.subViewMargin = 14.f;
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:15.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(172, 172, 172);
        letaoEmptyCoverView.backgroundColor = [UIColor clearColor];
        self.letaoEmptyCoverView = letaoEmptyCoverView;
    }
    [self.view addSubview:self.letaoEmptyCoverView];

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
