//
//  CollectionViewItemCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeKingKongItemCell.h"
#import "UIImageView+WebCache.h"
@interface XLTHomeKingKongItemCell ()

@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;
@property (nonatomic, weak) IBOutlet UILabel *itemLabel;


@end


@implementation XLTHomeKingKongItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.contentView.backgroundColor = [UIColor yellowColor];
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *subjectText = nil;
        NSString *subjectPicUrlString = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            subjectText = [info[@"name"]isKindOfClass:[NSString class]] ? info[@"name"] : nil;
            if (subjectText == nil) {
                subjectText = [info[@"title"]isKindOfClass:[NSString class]] ? info[@"title"] : nil;
            }
            subjectPicUrlString = [info[@"image"]isKindOfClass:[NSString class]] ? info[@"image"] : nil;
        }
        NSString *picUrl = [subjectPicUrlString letaoConvertToHttpsUrl];
        __weak typeof(self)weakSelf = self;

        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
        UIImage *picImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
        if ([picImage isKindOfClass:[UIImage class]]) {
            self.itemImageView.image = picImage;
            // 直接设置有webp会有bug，需要重新设置
            [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
        } else {
            [weakSelf.itemImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:kPlaceholderSmallImage];
        }
        _itemLabel.text = subjectText;
    }
}

    
@end
