//
//  XLTShareFeedMediaCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareFeedMediaCell.h"
#import "MASConstraint.h"
#import "UIButton+WebCache.h"
#import "SDWebImage.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface XLTShareVideosButton : UIButton
@property (nonatomic, copy) NSString *videoUrl;

@end

@implementation XLTShareVideosButton
- (void) setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    __weak typeof(self)weakSelf = self;
    [[SDWebImageManager sharedManager].imageCache queryImageForKey:videoUrl options:0 context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        if (image && [image isKindOfClass:[UIImage class]]) {
            [weakSelf setImage:image forState:UIControlStateNormal];

        } else {
            [self firstFrameWithVideoURL:[NSURL URLWithString:videoUrl] size:self.bounds.size completion:^(UIImage * _Nullable image) {
                if (image && [image isKindOfClass:[UIImage class]]) {
                    [[SDWebImageManager sharedManager].imageCache storeImage:image imageData:nil forKey:videoUrl cacheType:SDImageCacheTypeDisk completion:nil];
                    [weakSelf setImage:image forState:UIControlStateNormal];
                }
            }];

        }
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinletao_videos_small_icon"]];
    imageView.frame = CGRectMake(ceilf((self.bounds.size.width -35)/2), ceilf((self.bounds.size.height -35)/2), 35, 35);
    [self addSubview:imageView];
    
}

- (void)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size completion:(void(^)(UIImage * _Nullable image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取视频第一帧
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = CGSizeMake(size.width, size.height);
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                if (!error) {
                    UIImage *image = [UIImage imageWithCGImage:img];
                    completion(image);
                } else {
                    completion(nil);
                }
            }
        });

    });
   
}
@end

@interface XLTShareFeedMediaCell ()
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *videosArray;

@property (nonatomic, weak) IBOutlet UIView *contentMediaView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *contentMediaViewHeight;

@end

@implementation XLTShareFeedMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    NSArray *images = nil;
    NSArray *videos = nil;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        if ([info[@"images"] isKindOfClass:[NSArray class]]) {
            images = info[@"images"];
        }
        if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
            videos = info[@"videos"];
        }
    }
    NSMutableArray *mediaArray = [NSMutableArray array];
    if (videos.count) {
        [mediaArray addObjectsFromArray:videos];
    }
    if (images.count) {
        [mediaArray addObjectsFromArray:images];
    }
    self.imagesArray = images;
    self.videosArray = videos;
    [self updateWithMediaArray:mediaArray videos:videos];
}

- (void)updateWithMediaArray:(NSArray *)info videos:(NSArray *)videos {
    for (UIView *itemView in self.contentMediaView.subviews) {
        [itemView removeFromSuperview];
    }
    if ([info isKindOfClass:[NSArray class]] && info.count > 0) {
        CGFloat superWidth = kScreenWidth -54 - 10;
        BOOL singleItem = (info.count == 1);
        [info enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = [self itemRectAtIndex:idx itemArray:info superWidth:superWidth];
            if (singleItem) {
                rect.size.width = 225;
                rect.size.height = 170;
            }
            XLTShareVideosButton *itemBotton = [[XLTShareVideosButton alloc] initWithFrame:rect];
            itemBotton.backgroundColor = [UIColor letaolightgreyBgSkinColor];
            if ([obj isKindOfClass:[NSString class]]) {
                [itemBotton sd_setImageWithURL:[NSURL URLWithString:[obj letaoConvertToHttpsUrl]] forState:UIControlStateNormal];
            }
            if (idx < videos.count) {
                itemBotton.videoUrl = videos[idx];
            }
            itemBotton.layer.masksToBounds = YES;
            itemBotton.layer.cornerRadius = 5.0;
            itemBotton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            itemBotton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            itemBotton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
            itemBotton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            itemBotton.tag = idx;
            [itemBotton addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentMediaView addSubview:itemBotton];
        }];
        if (!singleItem) {
            CGFloat contentHeight = [self pageHeightForItemArray:info superWidth:superWidth];
            self.contentMediaViewHeight.constant = contentHeight;
        } else {
            CGFloat contentHeight = 170;
            self.contentMediaViewHeight.constant = contentHeight;
        }
        
    } else {
        self.contentMediaViewHeight.constant = 0;
    }

    
}

- (void)itemBtnClicked:(XLTShareVideosButton *)itemButton {
    if (itemButton.videoUrl) {
        if ([self.delegate respondsToSelector:@selector(cell:playVideos:)]) {
            [self.delegate cell:self playVideos:itemButton.videoUrl];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(cell:sourceView:showImagesArray:atIndex:)]) {
            if (self.imagesArray.count > 0) {
                [self.delegate cell:self sourceView:itemButton showImagesArray:self.imagesArray atIndex:MAX(0, itemButton.tag - self.videosArray.count)];
            }
        }
    }
}


- (CGFloat)itemWidthForSuperWidth:(CGFloat)superWidth {
    CGFloat itemWidth = floorf((superWidth -10)/[self pictureColumns]);
    return itemWidth;
}

- (CGFloat)itemHeightForSuperWidth:(CGFloat)superWidth {
    return [self itemWidthForSuperWidth:superWidth];
}

- (NSUInteger)pictureColumns {
    NSUInteger pictureCount = self.imagesArray.count  + self.videosArray.count;
    if (pictureCount ==2 || pictureCount == 4) {
        return 2;
    } else {
        return (pictureCount != 1 ? 3 : 1);
    }
}

- (CGRect)itemRectAtIndex:(NSUInteger)index itemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth {
    NSUInteger row = [self rowIndexForItemArray:itemArray atItemIndex:index];
    NSUInteger section = [self sectionIndexForItemArray:itemArray atItemIndex:index];
    CGFloat width = [self itemWidthForSuperWidth:superWidth];
    CGFloat height = [self itemHeightForSuperWidth:superWidth];
    return CGRectMake(section *width +section*5, height*row+ row*5, width, height);
}

- (CGFloat)pageHeightForItemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth  {
    if ([itemArray isKindOfClass:[NSArray class]] && itemArray.count > 0) {
        CGFloat height = [self itemHeightForSuperWidth:superWidth];
        NSUInteger rows = (itemArray.count / [self pictureColumns]);
        if ((itemArray.count % [self pictureColumns]) > 0) {
            rows ++ ;
        }
        CGFloat pageHeight = rows * height;
        if (rows >1) {
            pageHeight += ((rows -1) * 5);
        }
        return pageHeight;
    }
    return 0;
}


- (NSUInteger)rowIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    return itemIndex / [self pictureColumns];
}

- (NSUInteger)sectionIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    return itemIndex % [self pictureColumns];
}

@end
