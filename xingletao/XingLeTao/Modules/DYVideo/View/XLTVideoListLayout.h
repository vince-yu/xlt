//
//  XLTVideoListLayout.h
//  XingLeTao
//
//  Created by SNQU on 2020/4/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UICollectionViewLayout;
@protocol  XLTVideoListLayoutDelegate<NSObject>

@required
/**
 * 每个item的高度
 */
- (CGFloat)waterFallLayout:(UICollectionViewLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

/**
 * 每个item的宽度
 */
- (CGFloat)waterFallLayout:(UICollectionViewLayout *)waterFallLayout withForItemAtIndexPath:(NSUInteger)indexPath;


@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterFallLayout:(UICollectionViewLayout *)waterFallLayout;

/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInWaterFallLayout:(UICollectionViewLayout *)waterFallLayout;

/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInWaterFallLayout:(UICollectionViewLayout *)waterFallLayout;

/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(UICollectionViewLayout *)waterFallLayout;


@end
@interface XLTVideoListLayout : UICollectionViewLayout
@property (nonatomic, weak) id<XLTVideoListLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
