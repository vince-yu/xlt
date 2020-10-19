//
//  XLDGoodsImageCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN


@interface XLDGoodsDetailCollectionViewCellDisplayModel : NSObject
@property (nonatomic, assign) BOOL isImageType;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *text;
@end

@class XLDGoodsImageCollectionViewCell;
@protocol XLDGoodsImageCollectionViewCellDelegate <NSObject>

- (void)letaGoods:(XLDGoodsImageCollectionViewCell *)cell imageSizeChanged:(UIImage *)image imageSize:(CGSize)size;
@end

@interface XLDGoodsImageCollectionViewCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, weak) IBOutlet UIImageView *detailImageView;
@property (nonatomic, weak) id<XLDGoodsImageCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
