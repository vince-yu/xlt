//
//  XLTHomeScrollGoodsCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/7.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeScrollGoodsCell.h"
#import "XLTHomeScrollGoodsModuleView.h"

@interface XLTHomeScrollGoodsCell () <XLTHomeScrollGoodsModuleViewDelegate>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) XLTHomeModuleModel *moduleModel;
@property (nonatomic, copy) NSString *bgImageUrl;
@property (nonatomic, copy) NSString *bgColorText;
@property (nonatomic, strong) UIImageView *bgImageView;


@end

@implementation XLTHomeScrollGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _bgImageView.backgroundColor = kHomeModuleDefaultBGColor;
    _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_bgImageView];
    
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
}

- (void)letaoUpdateCellDataWithInfo:(XLTHomeModuleModel *)moduleModel {
    self.moduleModel = moduleModel;
    NSString *bgImageUrl = moduleModel.bgImageUrl;
    NSString *bgColorText = moduleModel.bgColorText;
    /// 设置背景图片和颜色
    [self setupBgImage:bgImageUrl bgColor:bgColorText];
    
    // 设置banner
    NSArray *modulesItemArray = moduleModel.modulesItemArray;
    [self setupBannersViewsWithItemArray:modulesItemArray];
    
}

- (void)setupBannersViewsWithItemArray:(NSArray *)modulesItemArray {
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        [modulesItemArray enumerateObjectsUsingBlock:^(XLTHomeModuleItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *info = obj.itemData.firstObject;
            if ([info isKindOfClass:[NSDictionary class]]) {
                XLTHomeScrollGoodsModuleView *itemView = [self itemViewForIndex:idx];
                itemView.tag = idx;
                itemView.delegate = self;
                [itemView letaoUpdateInfo:info contentHeight:obj.contentHeight];
                [self addjustItemView:itemView contentHeight:obj.contentHeight atIndex:idx];
            }
        }];
        // 清理不用的banner
        NSUInteger modulesItemCount = modulesItemArray.count;
        if (modulesItemCount < self.itemArray.count) {
            NSMutableArray *uselessBannersArray = [NSMutableArray array];
            [self.itemArray enumerateObjectsUsingBlock:^(XLTHomeScrollGoodsModuleView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!(idx < modulesItemCount)) {
                    [obj removeFromSuperview];
                    [uselessBannersArray addObject:obj];
                }
            }];
            [self.itemArray removeObjectsInArray:uselessBannersArray];
        }
    }
}


- (XLTHomeScrollGoodsModuleView *)itemViewForIndex:(NSUInteger)index {
    if (index < self.itemArray.count) {
        return self.itemArray[index];
    } else {
        XLTHomeScrollGoodsModuleView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"XLTHomeScrollGoodsModuleView" owner:nil options:nil] lastObject];
        itemView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        [itemView addGestureRecognizer:tap];
        
        if (itemView) {
            if (!self.itemArray) {
                self.itemArray = [NSMutableArray array];
            }
            [self.itemArray addObject:itemView];
            [self.contentView addSubview:itemView];
        }
        return itemView;
    }
}

- (void)addjustItemView:(XLTHomeScrollGoodsModuleView *)itemView contentHeight:(CGFloat)contentHeight atIndex:(NSUInteger)index {
    NSInteger sectionCount = 1;
    CGFloat leftMargin = 10;
    CGFloat rightMargin = 10;
    CGFloat itemSpace = [XLTHomeModuleModel homeScaleContentHeight:kContentBottomMargin sectionCount:sectionCount];
    
    CGFloat itemWidth = floorf((kScreenWidth - leftMargin - rightMargin - MAX(0, (sectionCount -1) *kContentItemMargin))/sectionCount);
    NSInteger sectionIndex = index % sectionCount;
    CGFloat x = (itemWidth + itemSpace)*sectionIndex + leftMargin;

    NSInteger rowIndex = index/sectionCount;
    CGFloat y = (itemSpace + contentHeight) * rowIndex;
    
    [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(x);
        make.top.mas_equalTo(y);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(contentHeight);
    }];
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
    } else {
        [self changeBgColor:kHomeModuleDefaultBGColor];
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
}

- (void)moduleViewDidScrollToModuleEvent:(XLTHomeScrollGoodsModuleView *)moduleView {
    NSArray *modulesItemArray = self.moduleModel.modulesItemArray;
    if ([modulesItemArray isKindOfClass:[NSArray class]]) {
        NSInteger idx = moduleView.tag;
        if (idx >= 0 && idx < modulesItemArray.count) {
            XLTHomeModuleItemModel *itemModel = modulesItemArray[idx];
            NSDictionary *info = itemModel.itemData.firstObject;
            if ([info isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:XLTHomeModuleItemClickedNotification object:info];
            }
        }
    }
}
@end
