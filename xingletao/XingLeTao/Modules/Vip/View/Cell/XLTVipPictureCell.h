//
//  XLTVipPictureCell.h
//  XingLeTao
//
//  Created by SNQU on 2020/2/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTVipPictureCellDisplayModel : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *jumpUrl;
@end



@class XLTVipPictureCell;
@protocol XLTVipPictureCellDelegate <NSObject>

- (void)pictureCell:(XLTVipPictureCell *)cell imageSizeChanged:(UIImage *)image imageSize:(CGSize)size;

@end

@interface XLTVipPictureCell : UICollectionViewCell
@property (nonatomic ,weak) id<XLTVipPictureCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
- (void)letaoUpdateCellDataWithInfo:(XLTVipPictureCellDisplayModel *)model;
@end

NS_ASSUME_NONNULL_END
