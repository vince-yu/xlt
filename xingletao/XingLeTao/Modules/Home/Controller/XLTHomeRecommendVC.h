//
//  XLTHomeRecommendVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"
@class XLTHomePageModel,XLTHomeRecommendVC;
NS_ASSUME_NONNULL_BEGIN

@protocol XLTHomeRecommendVCDelegate <NSObject>

- (void)letaoHomeTriggerRefreshAction;
- (void)scrollBanner:(NSDictionary *)startBanner toBanner:(NSDictionary * _Nullable)endBanner rate:(CGFloat)rate;
- (void)homeRecommendVCScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface XLTHomeRecommendVC : XLTBaseViewController
@property (nonatomic, copy) NSString *letaoChannelId;
@property (nonatomic, strong) XLTHomePageModel *pageModel;
@property (nonatomic, weak) id<XLTHomeRecommendVCDelegate> delegate;
- (void)letaoEndRefreshState;
- (void)pagerViewScrolToTop;
@end

@interface XLTHomeRecommendVC (QuickEntryView)
- (void)showTBAuthViewIfNeed;
- (void)showLoginBannerViewIfNeed;
- (void)requestRedPacketAdIfNeed;
- (void)showRedPacketIfNeed;
- (void)adjustBackToTopButtonFrame;
@end

@interface XLTHomeRecommendVC (ModelClickEvent)

- (void)moduleItemClickedNotification:(NSNotification *)notification;

- (void)goodsItemClickedNotification:(NSNotification *)notification;

- (void)goGoodDetailViewController:(NSDictionary *)itemInfo indexPath:(nullable NSIndexPath *)indexPath;

- (void)modulJumpWithInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END

