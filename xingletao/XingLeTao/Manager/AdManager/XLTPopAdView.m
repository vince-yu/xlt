//
//  XLTPopAdView.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTPopAdView.h"
#import "SDWebImageManager.h"
#import "XLTAdManager.h"
#import "XLTPopTaskViewManager.h"
#import "SDCycleScrollView.h"

@interface XLTPopAdView () <SDCycleScrollViewDelegate>
{
    UIWindow    *_adWindow;
    UIView      *_masksView;
    UIImageView      *_closeImageView;
   
}
@property (nonatomic, strong) SDCycleScrollView *letaoCycleScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *adArray;
@end

@implementation XLTPopAdView

#define kContentImageViewWidth kScreenWidth
#define kContentImageViewHeight kContentImageViewWidth

- (void)dealloc {

}

- (void)updateAdInfo:(NSArray *)adArray {
    self.adArray = adArray;
    if ([adArray isKindOfClass:[NSArray class]] && adArray.count > 0) {
        NSUInteger imageUrlCount = adArray.count;
        __block NSUInteger downloadImageUrlCount = 0;
        NSMutableArray *imageUrlArray = [NSMutableArray array];
        [adArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull adInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imageUrl = nil;
              if ([adInfo isKindOfClass:[NSDictionary class]]) {
                  imageUrl = adInfo[@"image"];
              }
              if ([imageUrl isKindOfClass:[NSString class]] && imageUrl.length > 0) {
                  __weak typeof(self)weakSelf = self;
                  [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                      if (image) {
                          [imageUrlArray addObject:image];
                      }
                      downloadImageUrlCount ++ ;
                      if (downloadImageUrlCount == imageUrlCount) { // 完成
                          if (imageUrlArray.count == imageUrlCount) {
                              // 完成
                              [weakSelf loadImageFinishedWithImagArray:imageUrlArray];
                          } else {
                              // 图片数量不对
                               [[XLTPopTaskViewManager shareManager] removePopedView:weakSelf];
                          }
                      }
                  }];
              } else {
                  [[XLTPopTaskViewManager shareManager] removePopedView:self];
                  *stop = YES;
              }
        }];
    } else {
        [[XLTPopTaskViewManager shareManager] removePopedView:self];
    }
  
}

- (void)loadImageFinishedWithImagArray:(NSArray *)imagArray {
    [[XLTAdManager shareManager] savePopAdShowDate:[NSDate date]];
    [self showAds:imagArray imageSize:CGSizeMake(kContentImageViewWidth, kContentImageViewHeight)];
}

- (void)showAds:(NSArray *)images imageSize:(CGSize)imageSize {
    if(_adWindow == nil) {
        _adWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _adWindow.backgroundColor = [UIColor clearColor];
        _adWindow.hidden = YES;
        _adWindow.windowLevel = (UIWindowLevelStatusBar -2.0);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.cancelsTouchesInView = NO;
        [tap addTarget:self action:@selector(tap:)];
        [_adWindow addGestureRecognizer:tap];
        
        // 底层黑背景
        _masksView = [[UIView alloc] initWithFrame:_adWindow.bounds];
        _masksView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _masksView.userInteractionEnabled = NO;
        [_adWindow addSubview:_masksView];
        
        if (self.letaoCycleScrollView == nil) {
            self.letaoCycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            self.letaoCycleScrollView.delegate = self;
            self.letaoCycleScrollView.backgroundColor = [UIColor clearColor];
            self.letaoCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
            self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
            self.letaoCycleScrollView.autoScroll = NO;
        }
        self.letaoCycleScrollView.center = _adWindow.center;
        self.letaoCycleScrollView.localizationImageNamesGroup = images;
        
        [_adWindow addSubview:self.letaoCycleScrollView];
        
        UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.letaoCycleScrollView.frame) -25-15, CGRectGetMinY(self.letaoCycleScrollView.frame)- 30, 25, 25)];
        if (self.isZeroBuyAd) {
            closeImageView.frame = CGRectMake(ceilf((_adWindow.bounds.size.width - 25)/2), CGRectGetMaxY(self.letaoCycleScrollView.frame) +30, 25, 25);
        }
        closeImageView.image = [UIImage imageNamed:@"xinletao_close_icon_white"];
        [_adWindow addSubview:closeImageView];
        _closeImageView = closeImageView;
        
        if (self.pageControl == nil) {
            CGSize pageControlDotSize = CGSizeMake(10, 10);
            CGSize size = CGSizeMake(images.count * pageControlDotSize.width * 1.5, pageControlDotSize.height);
            CGRect pageControlFrame = CGRectMake(ceilf((_adWindow.bounds.size.width - size.width)/2), CGRectGetMaxY(self.letaoCycleScrollView.frame)+26, size.width, size.height);

            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
            pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.userInteractionEnabled = NO;
            self.pageControl = pageControl;
        }
        self.pageControl.numberOfPages = images.count;
        self.pageControl.currentPage = 0;
        self.pageControl.hidden = (images.count <= 1);
        [_adWindow addSubview:self.pageControl];

    }
    [self showAd];
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
    if (!CGRectContainsPoint(self.letaoCycleScrollView.frame, [gestureRecognizer locationInView:_masksView])) {
        [self hiddenAd];
    }
    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (index < self.adArray.count) {
        NSDictionary *adInfo = self.adArray[index];
        [self adJumpWithInfo:adInfo];
        [self hiddenAdNoneAnimate];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didScrollToIndex:(NSInteger)index {
    self.pageControl.currentPage = index;
}

- (void)adJumpWithInfo:(NSDictionary *)adInfo {
    
    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        XLTBaseViewController *base = navigationController.viewControllers.lastObject;
        
        if ([base isKindOfClass:[XLTBaseViewController class]]) {
            [[XLTAdManager shareManager] adJumpWithInfo:adInfo sourceController:base];

        } else if ([base isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController *)base;
            XLTBaseViewController *base2 = tabBarController.selectedViewController;
            if ([base2 isKindOfClass:[XLTBaseViewController class]]) {
                [[XLTAdManager shareManager] adJumpWithInfo:adInfo sourceController:base];

            }
        }
    }
}

#define kAnimateWithDuration  0.3
- (void)showAd {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenAd) object:nil];
    
    // 如果已经显示，不再作重复动作
    if(_adWindow.hidden != NO) {
        _adWindow.hidden = NO;
        _masksView.alpha = 0.0;
        self.letaoCycleScrollView.alpha = 0.0;
        self.pageControl.alpha = 0.0;
        _closeImageView.alpha = 0.0;
        [UIView animateWithDuration:kAnimateWithDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self->_masksView.alpha = 1.0;

        } completion:^(BOOL finished) {
            self.letaoCycleScrollView.alpha = 1.0;
            self->_closeImageView.alpha = 1.0;
            self.pageControl.alpha = 1.0;
        }];
    }
    if (self.isZeroBuyAd) {
        [[XLTAppPlatformManager shareManager] makeLocalZeroBuyAddDateInfo];
    }
}

- (void)hiddenAd {
    if(_adWindow.hidden == NO) {
        [UIView animateWithDuration:kAnimateWithDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.letaoCycleScrollView.alpha = 0.5;
            self.pageControl.alpha = 0.5;
            self->_closeImageView.alpha = 0.5;
        } completion:^(BOOL finished) {
            self.letaoCycleScrollView.alpha = 0;
            self.pageControl.alpha = 0;
            self->_closeImageView.alpha = 0;
             [UIView animateWithDuration:0.2 animations:^{
                 self->_masksView.alpha = 0;
             } completion:^(BOOL finished) {
                 self->_adWindow.hidden = YES;
             }];
         }];
    }
    [[XLTPopTaskViewManager shareManager] removePopedView:self];
}

- (void)hiddenAdNoneAnimate {
    if(_adWindow.hidden == NO) {
        _adWindow.hidden = YES;
    }
    [[XLTPopTaskViewManager shareManager] removePopedView:self];
}


@end

