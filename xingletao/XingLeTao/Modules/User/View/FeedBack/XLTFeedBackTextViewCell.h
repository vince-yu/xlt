//
//  XLTFeedBackTextViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTFeedBackTextViewCell;
@protocol XLTFeedBackTextViewCellDelegate <NSObject>

- (void)feedBackTextViewCell:(XLTFeedBackTextViewCell *)cell textDidChanged:(NSString *)text;

@end

@interface XLTFeedBackTextViewCell : UICollectionViewCell
@property (nonatomic, weak) id<XLTFeedBackTextViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
