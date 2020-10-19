//
//  XLTFeedBackMediaCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTFeedBackMediaCell;
@protocol XLTFeedBackMediaCellDelegate <NSObject>

- (void)feedBackMediaCell:(XLTFeedBackMediaCell *)cell clearPhoto:(UIImage *)photo;

@end

@interface XLTFeedBackMediaCell : UICollectionViewCell

@property (nonatomic, weak) id<XLTFeedBackMediaCellDelegate> delegate;

- (void)updatePhoto:(UIImage *)photo isVideo:(BOOL)isVideo;

- (void)updatePhotoUrl:(NSString *)photoUrl isVideo:(BOOL)isVideo;
@end

NS_ASSUME_NONNULL_END
