//
//  XLTHomeSingleBannerCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/7.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeSingleBannerCell.h"
#import "SDCycleScrollView.h"

@interface XLTHomeSingleBannerCell () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) XLTHomeModuleModel *moduleModel;
@property (nonatomic, copy) NSString *bgImageUrl;
@property (nonatomic, copy) NSString *bgColorText;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) SDCycleScrollView *letaoCycleScrollView;
@end

@implementation XLTHomeSingleBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.backgroundColor = kHomeModuleDefaultBGColor;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_bgImageView];
    
    if (self.letaoCycleScrollView == nil) {
        self.letaoCycleScrollView = [XLTHomePageCycleScrollView cycleScrollViewWithFrame:self.contentView.bounds delegate:self placeholderImage:nil];
//        self.letaoCycleScrollView.layer.masksToBounds = YES;
//        self.letaoCycleScrollView.layer.cornerRadius = 15.0;
        UIColor *bgColor = [UIColor colorWithHex:0xFFFAFAFA];
        self.letaoCycleScrollView.backgroundColor = bgColor;
        self.letaoCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.letaoCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        self.letaoCycleScrollView.pageDotColor = [UIColor colorWithWhite:1.0 alpha:0.48];
        self.letaoCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.letaoCycleScrollView.backgroundImageView.backgroundColor = bgColor;
    }
    [self.contentView addSubview:self.letaoCycleScrollView];
    
}

- (void)letaoUpdateCellDataWithInfo:(XLTHomeModuleModel *)moduleModel {
    self.moduleModel = moduleModel;
    /*
    NSString *bgImageUrl = moduleModel.bgImageUrl;
    NSString *bgColorText = moduleModel.bgColorText;
    /// 设置背景图片和颜色
    [self setupBgImage:bgImageUrl bgColor:bgColorText];*/
    
    // 设置banner
    NSArray *modulesItemArray = moduleModel.modulesItemArray;
    NSMutableArray *imageArray = [NSMutableArray array];
    __block CGFloat contentHeight = 0;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        [modulesItemArray enumerateObjectsUsingBlock:^(XLTHomeModuleItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *info = obj.itemData.firstObject;
            if (!(contentHeight > 0)) {
                contentHeight = obj.contentHeight;
            }
            if ([info isKindOfClass:[NSDictionary class]]) {
                NSString *image = info[@"image"];
                if ([image isKindOfClass:[NSString class]]) {
                    [imageArray addObject:[image letaoConvertToHttpsUrl]];
                }
            }
        }];
    }
    self.letaoCycleScrollView.imageURLStringsGroup = imageArray;
    self.letaoCycleScrollView.frame = CGRectMake(0, 0, kScreenWidth, contentHeight);
    
    
    NSString *bgColorText = moduleModel.bgColorText;
    if ([bgColorText isKindOfClass:[NSString class]] && bgColorText.length > 0) {
        UIColor *color = [UIColor colorWithHexString:[bgColorText stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        if (color) {
            [self changeBgColor:color];
        }
    } else {
        [self changeBgColor:kHomeModuleDefaultBGColor];
    }
    CGFloat bgheight = moduleModel.moduleHeight - contentHeight;
    if (bgheight > 0) {
        CGRect bgRect =  CGRectMake(0, contentHeight, kScreenWidth, bgheight);
        self.bgImageView.frame = bgRect;
    }
}


- (void)cycleScrollView:(SDCycleScrollView *)letaoCycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSArray *modulesItemArray = self.moduleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        if (index >= 0 && index < modulesItemArray.count) {
            XLTHomeModuleItemModel *itemModel = modulesItemArray[index];
            NSDictionary *info = itemModel.itemData.firstObject;
            if ([info isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:XLTHomeModuleItemClickedNotification object:info];
            }
        }
    }
}


/*
- (void)setupBannersViewsWithItemArray:(NSArray *)modulesItemArray {
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        [modulesItemArray enumerateObjectsUsingBlock:^(XLTHomeModuleItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *info = obj.itemData.firstObject;
            if ([info isKindOfClass:[NSDictionary class]]) {
                UIImageView *banner = [self bannerImageViewForIndex:idx];
                banner.tag = idx;
                NSString *image = info[@"image"];
                if ([image isKindOfClass:[NSString class]]) {
                    NSString *picUrl = [image letaoConvertToHttpsUrl];
                    NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
                    UIImage *picImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
                    if ([picImage isKindOfClass:[UIImage class]]) {
                        banner.image = picImage;
                        // 直接设置有webp会有bug，需要重新设置
                        [banner sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
                    } else {
                        [banner sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
                    }
                }
                [self addjustBanner:banner contentHeight:obj.contentHeight atIndex:idx];
            }
        }];
        // 清理不用的banner
        NSUInteger modulesItemCount = modulesItemArray.count;
        if (modulesItemCount < self.itemArray.count) {
            NSMutableArray *uselessBannersArray = [NSMutableArray array];
            [self.itemArray enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!(idx < modulesItemCount)) {
                    [obj removeFromSuperview];
                    [uselessBannersArray addObject:obj];
                }
            }];
            [self.itemArray removeObjectsInArray:uselessBannersArray];
        }
    }
}


- (UIImageView *)bannerImageViewForIndex:(NSUInteger)index {
    if (index < self.itemArray.count) {
        return self.itemArray[index];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        [imageView addGestureRecognizer:tap];

        
        
        if (!self.itemArray) {
            self.itemArray = [NSMutableArray array];
        }
        [self.itemArray addObject:imageView];
        [self.contentView addSubview:imageView];
        return imageView;
    }
}

- (void)addjustBanner:(UIImageView *)banner contentHeight:(CGFloat)contentHeight atIndex:(NSUInteger)index {
    CGFloat itemSpace = [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:0];
    CGFloat y = (itemSpace + contentHeight) * index;
    banner.frame = CGRectMake(10, y, kScreenWidth - 20, contentHeight);
}



- (void)setupBgImage:(NSString *)imageUrl bgColor:(NSString *)bgColor {
    if ([imageUrl isKindOfClass:[NSString class]] && imageUrl.length > 0) {
        // 查看缓存
        NSString *picUrl = [imageUrl letaoConvertToHttpsUrl];
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
        UIImage *bgImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
        if ([bgImage isKindOfClass:[UIImage class]]) {
            [self changeBgImage:bgImage];
        } else {
            __weak typeof(self)weakSelf = self;
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:picUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if ([weakSelf.bgImageUrl isEqualToString:imageUrl]) {
                    if(image) {
                        [weakSelf changeBgImage:image];
                    }
                }
            }];
        }

    } else if ([bgColor isKindOfClass:[NSString class]] && bgColor.length > 0){
        UIColor *color =  [UIColor colorWithHexString:[bgColor stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        if (color) {
            [self changeBgColor:color];
        }
    }
}

- (void)changeBgImage:(UIImage *)image {
    // 设置背景图片
    if (image.size.width >0 && image.size.height > 0) {
        //  设置背景图片和动画
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.bgImageView.layer addAnimation:transition forKey:@"bgTransition"];
        self.bgImageView.image = image;
    }
}

- (void)changeBgColor:(UIColor *)color {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.bgImageView.layer addAnimation:transition forKey:@"bgTransition"];
    self.bgImageView.image = nil;
    self.bgImageView.backgroundColor = color;
}

- (void)itemClicked:(UIGestureRecognizer *)tap {
    NSArray *modulesItemArray = self.moduleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        NSInteger idx = tap.view.tag;
        if (idx >= 0 && idx < modulesItemArray.count) {
            XLTHomeModuleItemModel *itemModel = modulesItemArray[idx];
            NSDictionary *info = itemModel.itemData.firstObject;
            if ([info isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:XLTHomeModuleItemClickedNotification object:info];
            }
        }
    }
} */

- (void)changeBgColor:(UIColor *)color {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.bgImageView.layer addAnimation:transition forKey:@"bgTransition"];
    self.bgImageView.image = nil;
    self.bgImageView.backgroundColor = color;
}
@end
