//
//  XLTScrolledPageView.m
//
//  Created by chenhg on 2018/8/20.
//  Copyright © 2018年 fi. All rights reserved.
//

#import "XLTScrolledPageView.h"

@interface XLTScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end

@implementation XLTScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}
@end


@interface XLTScrolledPageView () {
    CGRect              _scrollRect;
    BOOL                _changePageInner;
}

@property (nonatomic, strong) NSMutableArray    *pageViewControllers;
@property (nonatomic, assign) NSUInteger        firstPageIndex;
@property (nonatomic, assign) CGRect            scrollRect;
@end

@implementation XLTScrolledPageView
static const NSUInteger kDefaultFirstPageIndex = 0;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.firstPageIndex = kDefaultFirstPageIndex;
        self.shouldPreLoadSiblings = YES;
    }
    return self;
}

#pragma mark Setters & Getters
- (void)setDataSource:(id<XLTScrolledPageViewDataSource>)dataSource
{
    if (dataSource && _dataSource != dataSource)
    {
        _dataSource = dataSource;
        [self resetComplete:YES];
    }
}
#pragma mark Override from UIView
- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;
    CGSize contentSize = _scrollView.contentSize;
    contentSize.height = _scrollView.frame.size.height;
    _scrollView.contentSize = contentSize;
    [self initScrollRect];
    //Notes: it's necessary to verify these states, otherwise the scrollView may be stuck on some iOS versions
    if (!_scrollView.dragging && !_scrollView.decelerating && !_scrollView.tracking)
    {
        [self adjustScrollView2RightState];
    }
    
    NSInteger pageCount = [_pageViewControllers count];
    for (int i = 0; i < pageCount; i++)
    {
        id ctl = [_pageViewControllers objectAtIndex:i];
        if ([ctl isKindOfClass:[UIViewController class]])
        {
            [self confingPage:ctl atIndex:i];
        }
    }
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // bad performance
    //    CGFloat pageWidth = _scrollView.frame.size.width;
    //    _currentPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //    [self loadPagesForPage:_currentPage];
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _changePageInner = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
    
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadPages];
    _changePageInner = NO;
    [self adjustPageView];
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadPages];
    _changePageInner = NO;
    [self adjustPageView];
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark Public Methods
- (void)reloadData
{
    [self loadScrollView];
}

- (void)resetComplete:(BOOL)complete
{
    if (complete || _currentPageIndex > [_dataSource numberOfPages])
    {
        _currentPageIndex = _firstPageIndex;
    }
    
    [_pageViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController *ctl = (UIViewController *)obj;
            [ctl.view removeFromSuperview];
        }
    }];
    
    // create pages container
    NSInteger pageCount = [_dataSource numberOfPages];
    self.pageViewControllers = [NSMutableArray array];
    for (int i = 0; i < pageCount; ++i)
    {
        [_pageViewControllers addObject:[NSNull null]];
    }
    
    // reload scroll view
    [_scrollView removeFromSuperview];
    [self loadScrollView];
}

- (void)releasePage:(UIViewController *)viewController
{
    if ([_pageViewControllers containsObject:viewController])
    {
        [viewController.view removeFromSuperview];
        NSInteger page = [_pageViewControllers indexOfObject:viewController];
        [_pageViewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)enablePreloadSiblings
{
    self.shouldPreLoadSiblings = YES;
    [self loadPageAtIndexIfNotLoaded:_currentPageIndex];
    [self loadPageAtIndexIfNotLoaded:_currentPageIndex + 1];
    [self loadPageAtIndexIfNotLoaded:_currentPageIndex - 1];
}

- (CGPoint)contentOffset
{
    return _scrollView.contentOffset;
}

- (void)goToNextAnimated:(BOOL)animated;
{
    NSInteger pageIndex = _currentPageIndex;
    [self goToPageAtIndex:++pageIndex animated:animated];
}

- (void)goToPreAnimated:(BOOL)animated
{
    NSInteger pageIndex = _currentPageIndex;
    [self goToPageAtIndex:--pageIndex animated:animated];
}

- (void)goToPageController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger pageIndex = [_pageViewControllers indexOfObject:viewController];
    if (pageIndex != NSNotFound)
    {
        [self goToPageAtIndex:pageIndex animated:animated];
    }
}

- (void)goToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated
{
    if (pageIndex == _currentPageIndex)
    {
        return;
    }
    
    NSInteger pageCount = [_pageViewControllers count];
    
    if (0 <= pageIndex && pageIndex < pageCount)
    {
        if (animated)
        {
            [_scrollView setContentOffset:CGPointMake(self.scrollRect.size.width * pageIndex, 0.f) animated:YES];
        }
        else
        {
            [_scrollView setContentOffset:CGPointMake(self.scrollRect.size.width * pageIndex, 0.f)];
            
            //no animation, load imediately.
            [self loadPages];
        }
    }
}

#pragma mark Private Methods

- (void)loadScrollView
{
    [self initScrollRect];
    
    // create scroll view if necessary
    if (!_scrollView)
    {
        _scrollView = [[XLTScrollView alloc] initWithFrame:self.scrollRect];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _scrollView.clipsToBounds = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollsToTop = NO;
    }
    
    // set frame
    _scrollView.frame = self.scrollRect;
    
    // make sure scrollview is a subview.
    if (![_scrollView isDescendantOfView:self])
    {
        [self addSubview:_scrollView];
    }
    
    // get total pages count
    NSUInteger pages = [_dataSource numberOfPages];
    
    // set content size
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * pages,_scrollView.frame.size.height);
    
    if (_currentPageIndex >= _firstPageIndex && _currentPageIndex < pages)
    {
        _scrollView.contentOffset = CGPointMake(_currentPageIndex * _scrollView.frame.size.width, 0);
    }
    
    [self loadPages];
}


- (void)loadPages
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    NSInteger pageIndex = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self loadPagesAtIndex:pageIndex];
}

- (void)loadPagesAtIndex:(NSUInteger)pageIndex
{
    // load the current page
    [self loadPageAtIndex:pageIndex];
    
    // load siblings
    if (self.shouldPreLoadSiblings)
    {
        [self loadPageAtIndex:pageIndex + 1];
        [self loadPageAtIndex:pageIndex - 1];
    }
    
    
    if ((_changePageInner) &&
        (_currentPageIndex != pageIndex) &&
        _delegate && [_delegate respondsToSelector:@selector(didScrollToPage:)])
    {
        [_delegate didScrollToPage:pageIndex];
    }
    
    _currentPageIndex = pageIndex;
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didLoadPagesAtIndex:)])
    {
        [self.delegate didLoadPagesAtIndex:pageIndex];
    }
}

- (void)loadPageAtIndex:(NSUInteger)pageIndex
{
    UIViewController *viewController = (( pageIndex >= [_pageViewControllers count] ) ? nil : [_pageViewControllers objectAtIndex:pageIndex]);
    if (viewController)
    {
        UIViewController *addViewCtl = [_dataSource viewControllerForPageIndex:pageIndex];
        if ([viewController isKindOfClass:[NSNull class]])
        {
            [_pageViewControllers replaceObjectAtIndex:pageIndex withObject:addViewCtl];
        }
        else if ([viewController isKindOfClass:[UIViewController class]])
        {
            if ( (viewController != addViewCtl) ||
                (![NSStringFromClass([viewController class]) isEqualToString:NSStringFromClass([addViewCtl class])]) )
            {
                [viewController.view removeFromSuperview];
                [_pageViewControllers replaceObjectAtIndex:pageIndex withObject:addViewCtl];
            }
            else
            {
                addViewCtl = viewController;
            }
        }
        
        if (addViewCtl.view.superview != _scrollView)
        {
            [self confingPage:addViewCtl atIndex:pageIndex];
            [_scrollView addSubview:addViewCtl.view];
        }
    }
}

- (void)confingPage:(UIViewController *)viewController atIndex:(NSUInteger)pageIndex
{
    viewController.view.frame = [self getFrameForPageAtIndex:pageIndex];
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (CGRect)getFrameForPageAtIndex:(NSUInteger)pageIndex
{
    CGRect frame = self.scrollRect;
    frame.origin.x = frame.size.width * pageIndex ;
    frame.size.width = frame.size.width ;
    
    return frame;
}

- (void)loadPageAtIndexIfNotLoaded:(NSInteger)pageIndex
{
    id element = (pageIndex > _pageViewControllers.count ? nil : [_pageViewControllers objectAtIndex:pageIndex]);
    if (element && ![element isKindOfClass:[UIViewController class]])
    {
        [self loadPageAtIndex:pageIndex];
    }
}

- (void)adjustPageView
{
    CGFloat pageWidth = self.scrollRect.size.width;
    CGFloat offset = _scrollView.contentOffset.x;
    CGFloat ajustFactor = 0.f;
    if (pageWidth > 0.f && offset > 0.f)
    {
        ajustFactor = fmodf(offset, pageWidth);
    }
    
    if (ajustFactor > 0.f || ajustFactor < 0.f)
    {
        CGFloat pageWidth = _scrollView.frame.size.width;
        _currentPageIndex = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self goToPageAtIndex:_currentPageIndex animated:YES];
    }
}

- (void)adjustScrollView2RightState
{
    CGPoint offset = CGPointMake(_currentPageIndex * self.scrollRect.size.width, _scrollView.contentOffset.y);
    [_scrollView setContentOffset:offset animated:NO];
}

- (void)initScrollRect
{
    _scrollRect = self.bounds;
}

@end


@implementation XLTCustomScrolledPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        

    
    }
    return self;
}

- (void)loadScrollView {
    [super loadScrollView];
    if (_customBgView == nil) {
        _customBgView = [[UIView alloc] init];
        _customBgView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
        [self.scrollView addSubview:_customBgView];
    }
    
    [self.scrollView sendSubviewToBack:_customBgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.contentSize.width - self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    if (!(rect.size.width > 0)) {
        rect = CGRectZero;
    }
    _customBgView.frame = rect;
    
}

@end
