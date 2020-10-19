//
//  XLTVipPictureCell.m
//  XingLeTao
//
//  Created by SNQU on 2020/2/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTVipPictureCell.h"

@implementation XLTVipPictureCellDisplayModel
@end


@interface XLTVipPictureCell ()

@end

@implementation XLTVipPictureCell

- (void)letaoUpdateCellDataWithInfo:(XLTVipPictureCellDisplayModel *)model {
    XLT_WeakSelf;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[model.imageUrl letaoConvertToHttpsUrl]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XLT_StrongSelf;
        CGSize size = image.size;
        if (image.size.width > 0 && image.size.height > 0) {
            float proportion = (kScreenWidth)/size.width;//根据屏幕大小算出比例
            size.height = ceilf(image.size.height*proportion);
            size.width = kScreenWidth;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 高度变化了，刷新
            if (size.height - model.height > 0.1) {
                if ([self.delegate respondsToSelector:@selector(pictureCell:imageSizeChanged:imageSize:)]) {
                       [self.delegate pictureCell:self imageSizeChanged:image imageSize:size];
                }
                model.height = size.height;
            }
        });
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
