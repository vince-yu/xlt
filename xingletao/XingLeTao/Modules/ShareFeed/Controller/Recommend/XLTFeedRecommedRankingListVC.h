//
//  XLTFeedRecommedRankingListVC.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTShareFeedListVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLTFeedRecommedRankingListVCDelagate <NSObject>

- (void)xlt_scrollPageViewDidScroll:(UIScrollView *)scrollView;
- (void)xlt_scrollPageViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)xlt_scrollPageViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)xlt_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
@end

@interface XLTFeedRecommedRankingListVC : XLTShareFeedListVC
@property (nonatomic, copy, nullable) NSString *rankingType;
@property (nonatomic, weak) id<XLTFeedRecommedRankingListVCDelagate> delegate;

@end

NS_ASSUME_NONNULL_END
