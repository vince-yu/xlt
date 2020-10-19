//
//  XLTStartRecommedTextCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTStartRecommedTextCell;
@protocol XLTStartRecommedTextCellDelegate <NSObject>

- (void)recommedTextCell:(XLTStartRecommedTextCell *)cell textDidChanged:(NSString *)text;

@end

@interface XLTStartRecommedTextCell : UICollectionViewCell
@property (nonatomic, weak) id<XLTStartRecommedTextCellDelegate> delegate;
- (void)updateFeedText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
