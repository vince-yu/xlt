//
//  XLTStartRecommedMediaCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTStartRecommedMediaCell;
@protocol XLTStartRecommedMediaCellDelegate <NSObject>

- (void)recommedMediaCell:(XLTStartRecommedMediaCell *)cell clearPhoto:(UIImage *)photo;

@end

@interface XLTStartRecommedMediaCell : UICollectionViewCell
@property (nonatomic, readonly) id itemPhoto;
@property (nonatomic, weak) id<XLTStartRecommedMediaCellDelegate> delegate;

- (void)updatePhoto:(UIImage *)photo isVideo:(BOOL)isVideo;

- (void)updatePhotoUrl:(NSString *)photoUrl isVideo:(BOOL)isVideo;
@end

NS_ASSUME_NONNULL_END
