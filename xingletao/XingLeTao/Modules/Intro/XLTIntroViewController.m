//
//  XLTViewController.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTIntroViewController.h"
#import "AppDelegate+Coordinator.h"
#import "XLTIntroVideoViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "XLTFullScreenVideoVC.h"

@interface XLTIntroViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *introArray;
@property (nonatomic, assign) BOOL shouldShowVideo;
@property (nonatomic ,strong) UIImageView *lastImageView;
@end

@implementation XLTIntroViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reachabilityChanged) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)reachabilityChanged {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWWAN
        || status == AFNetworkReachabilityStatusReachableViaWiFi) {
        [[XLTAppPlatformManager shareManager] xingletaonetwork_requestConfig];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shouldShowVideo = ![[XLTAppPlatformManager shareManager] isDidPalyTeachingVideo];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 11.0, *)) {
        self.contentScrollView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    NSMutableArray *imageArray = iPhoneX_All ? @[@"intro_x_1",@"intro_x_2",@"intro_x_3"].mutableCopy : @[@"intro_1",@"intro_2",@"intro_3"].mutableCopy;
    self.introArray =  imageArray;
    NSUInteger imageCount = imageArray.count;
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth * imageCount, kScreenHeight);
    [self.view addSubview:self.contentScrollView];


    [imageArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect =  CGRectMake(idx *kScreenWidth , 0, kScreenWidth, kScreenHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:obj];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentScrollView addSubview:imageView];
        NSUInteger enterPageIndex = imageCount -1;
        
        if (idx == enterPageIndex) {
            self.lastImageView = imageView;
            self.lastImageView.userInteractionEnabled = YES;
             UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
             CGFloat y = rect.size.height - kScreen_iPhone375Scale(67) - kScreen_iPhone375Scale(40);
             CGFloat h = kScreen_iPhone375Scale(40);
             if (iPhoneX_All) {
                 h = (kScreenHeight/2668.0*133);
                 y = rect.size.height - (kScreenHeight/2668.0*458) - h;
             }
            
             enterButton.frame = CGRectMake(0 + ceilf(( kScreenWidth - 140)/2), ceilf(y), 140, ceilf(h));
             enterButton.layer.masksToBounds = YES;
             enterButton.layer.cornerRadius = ceilf(h/2);
             enterButton.layer.borderColor = [UIColor colorWithHex:0xFFFD7739].CGColor;
             enterButton.layer.borderWidth = 0.5;
             enterButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:18];
             [enterButton setTitleColor:[UIColor colorWithHex:0xFFFD7739] forState:UIControlStateNormal];
             [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
             [enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
             [self.lastImageView addSubview:enterButton];
        }
        
        
    }];
    [self updateImageStatus];
}
- (void)updateImageStatus{
    XLT_WeakSelf;
    [[XLTAppPlatformManager shareManager] xingletaonetwork_requestLimitModelStatus:^{
        XLT_StrongSelf;
        if ([XLTAppPlatformManager shareManager].checkEnable) {
            [self updateLastImageView];
        }
    }];
}
- (void)updateLastImageView{
    
    for (UIView *view in self.lastImageView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGRect rect =  CGRectMake(0 , 0, kScreenWidth, kScreenHeight);
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat h = kScreen_iPhone375Scale(40);
     CGFloat y = rect.size.height - kScreen_iPhone375Scale(50) - kScreen_iPhone375Scale(40) - h - 25;
     
     if (iPhoneX_All) {
         h = (kScreenHeight/2668.0*133);
         y = rect.size.height - (kScreenHeight/2668.0*458) - h - h - 25;
     }
    
     enterButton.frame = CGRectMake(CGRectGetMinX(rect) + ceilf(( kScreenWidth - 140)/2), ceilf(y), 140, ceilf(h));
     enterButton.layer.masksToBounds = YES;
     enterButton.layer.cornerRadius = ceilf(h/2);
     enterButton.layer.borderColor = [UIColor colorWithHex:0xFFFD7739].CGColor;
     enterButton.layer.borderWidth = 0.5;
     enterButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:18];
     [enterButton setTitleColor:[UIColor colorWithHex:0xFFFD7739] forState:UIControlStateNormal];
     [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
     [enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.lastImageView addSubview:enterButton];
     
     UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
      CGFloat vy = rect.size.height - kScreen_iPhone375Scale(50) - kScreen_iPhone375Scale(40);
      CGFloat vh = kScreen_iPhone375Scale(40);
      if (iPhoneX_All) {
          vh = (kScreenHeight/2668.0*133);
          vy = rect.size.height - (kScreenHeight/2668.0*458) - vh;
      }
     
      videoButton.frame = CGRectMake(0 + ceilf(( kScreenWidth - 140)/2), ceilf(vy), 140, ceilf(vh));
      videoButton.layer.masksToBounds = YES;
      videoButton.layer.cornerRadius = ceilf(vh/2);
      videoButton.layer.borderColor = [UIColor colorWithHex:0xFFFD7739].CGColor;
      videoButton.layer.borderWidth = 0.5;
      videoButton.titleLabel.font = [UIFont letaoMediumBoldFontWithSize:18];
      [videoButton setTitleColor:[UIColor colorWithHex:0xFFFD7739] forState:UIControlStateNormal];
      [videoButton setTitle:@"省钱操作介绍" forState:UIControlStateNormal];
      [videoButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
      [self.lastImageView addSubview:videoButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaohiddenNavigationBar:YES];
}
//https://resource.xin1.cn/static/video/xkd_lingquan.mp4
- (void)playButtonAction{
    XLTFullScreenVideoVC *vc = [[XLTFullScreenVideoVC alloc] initWithNibName:@"XLTFullScreenVideoVC" bundle:[NSBundle mainBundle]];
    vc.letaoVideoUrl = @"https://resources.xinletao.vip/p/static/video/common/start_page.mp4";
    NSMutableArray *viewControllers = self. navigationController.viewControllers.mutableCopy;
    [viewControllers addObject:vc];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}
- (void)enterButtonAction {
    /*
    if (self.shouldShowVideo && [XLTAppPlatformManager shareManager].checkEnable) {
        [self startPalyVideo];
    } else {
        [self enterMainVC];
    }*/
    [self enterMainVC];
}

- (void)enterMainVC {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        [appDelegate displayRootViewControllerForLaunching];
    }
}

/*

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / [UIScreen mainScreen].bounds.size.width;
    if (currentPage == self.introArray.count - 1) {
        [self startPalyVideoIfNeed];
    }
}

- (void)startPalyVideoIfNeed {
    if (self.shouldShowVideo) {
        [[XLTAppPlatformManager shareManager] didPalyTeachingVideo:YES];
        // 禁止滑动了
        self.contentScrollView.scrollEnabled = NO;
        // 播放视频
        [self startPalyVideo];
    }
}*/


- (void)startPalyVideo {
    XLTIntroVideoViewController *introVideoViewController = [[XLTIntroVideoViewController alloc] init];
    NSUInteger idx = self.introArray.count - 1;
    CGRect rect =  CGRectMake(idx *kScreenWidth , 0, kScreenWidth, kScreenHeight);
    introVideoViewController.view.frame = rect;
    [self.contentScrollView addSubview:introVideoViewController.view];
    
    [self addChildViewController:introVideoViewController];
    [introVideoViewController didMoveToParentViewController:self];
    
    [[XLTAppPlatformManager shareManager] didPalyTeachingVideo:YES];
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
