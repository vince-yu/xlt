//
//  XLDGoodsImageCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTUIConstant.h"

@interface XLDGoodsImageCollectionViewCell ()

@end

@implementation XLDGoodsImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)letaoUpdateCellDataWithInfo:(XLDGoodsDetailCollectionViewCellDisplayModel *)model {
    __weak typeof(self)weakSelf = self;
    if ([model.imageUrl isKindOfClass:[NSString class]]) {
        [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:[model.imageUrl letaoConvertToHttpsUrl]] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGSize size = image.size;
            if (image.size.width > 0 && image.size.height > 0) {
                float proportion = (kScreenWidth)/size.width;//根据屏幕大小算出比例
                size.height = ceilf(image.size.height*proportion);
                size.width = kScreenWidth;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 高度变化了，刷新
                if (size.height - model.height > 0.1) {
                    if ([weakSelf.delegate respondsToSelector:@selector(letaGoods:imageSizeChanged:imageSize:)]) {
                           [weakSelf.delegate letaGoods:weakSelf imageSizeChanged:image imageSize:size];
                    }
                    model.height = size.height;
                }
            });
        }];
    }
}

@end

@implementation XLDGoodsDetailCollectionViewCellDisplayModel

@end
