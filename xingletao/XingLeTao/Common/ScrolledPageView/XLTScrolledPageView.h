//
//  XLTScrolledPageView.h
//
//  Created by chenhg on 2018/8/20.
//  Copyright © 2018年 fi. All rights reserved.
//

#import <UIKit/UIKit.h>
/** DataSource Protocol**/
@protocol XLTScrolledPageViewDataSource <NSObject>
@required
- (NSUInteger)numberOfPages;
- (UIViewController *)viewControllerForPageIndex:(NSUInteger)pageIndex;
@end

/** Delegate Protocol**/
@protocol XLTScrolledPageViewViewDelegate <NSObject>
@optional
- (void)didScrollToPage:(NSUInteger)page;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

- (void)didLoadPagesAtIndex:(NSUInteger)pageIndex;
@end

@interface XLTScrolledPageView : UIView <UIScrollViewDelegate>
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) NSUInteger currentPageIndex;
@property (nonatomic, assign) id<XLTScrolledPageViewDataSource> dataSource;
@property (nonatomic, assign) id<XLTScrolledPageViewViewDelegate> delegate;
@property (nonatomic, assign) BOOL shouldPreLoadSiblings;

- (void)goToNextAnimated:(BOOL)animated;
- (void)goToPreAnimated:(BOOL)animated;
- (void)goToPageController:(UIViewController *)viewCtl animated:(BOOL)animated;
- (void)goToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated;
@end


@interface XLTCustomScrolledPageView : XLTScrolledPageView
@property (nonatomic, strong) UIView *customBgView;

@end

