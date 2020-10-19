//
//  XLTFeedBackMediaCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedBackMediaCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface XLTFeedBackMediaCell ()
@property (nonatomic, strong)CAShapeLayer *dashBorderLayer;
@property (nonatomic, weak) IBOutlet UIImageView *feedImageView;
@property (nonatomic, weak) IBOutlet UIImageView *feedVideoImageView;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) UIImage *itemPhoto;

@end

@implementation XLTFeedBackMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.feedImageView.layer.cornerRadius = 5.f;
    self.feedImageView.layer.masksToBounds = YES;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL showDashBorderLayer = ([self.itemPhoto isKindOfClass:[NSNull class]]);
        if (showDashBorderLayer) {
            if (self.dashBorderLayer == nil) {
                CAShapeLayer *border = [CAShapeLayer layer];
                //虚线的颜色
                border.strokeColor = [UIColor lightGrayColor].CGColor;
                //填充的颜色
                border.fillColor = [UIColor clearColor].CGColor;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.feedImageView.bounds cornerRadius:5];
                //设置路径
                border.path = path.CGPath;
                border.frame = self.feedImageView.bounds;
                //虚线的宽度
                border.lineWidth = 1.f;
                //设置线条的样式
                //    border.lineCap = @"square";
                //虚线的间隔
                border.lineDashPattern = @[@4, @2];
                [self.feedImageView.layer addSublayer:border];
                self.dashBorderLayer = border;
            }
        }
        self.dashBorderLayer.hidden = !showDashBorderLayer;
    });
}

- (void)updatePhoto:(UIImage *)photo isVideo:(BOOL)isVideo {
    self.itemPhoto = photo;
    if ([photo isKindOfClass:[UIImage class]]) {
        self.dashBorderLayer.hidden = YES;
        self.clearButton.hidden = NO;
        self.feedImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.feedImageView.image = photo;
    } else {
        self.dashBorderLayer.hidden = NO;
        self.clearButton.hidden = YES;
        self.feedImageView.image = [UIImage imageNamed:@"feedback_camera"];
        self.feedImageView.contentMode = UIViewContentModeCenter;
    }
    self.feedVideoImageView.hidden = !isVideo;
}

- (void)updatePhotoUrl:(NSString *)photoUrl isVideo:(BOOL)isVideo {
    self.feedImageView.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    self.dashBorderLayer.hidden = YES;
    self.clearButton.hidden = YES;
    self.feedImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([photoUrl isKindOfClass:[NSString class]]) {
        if (isVideo) {
            NSString *videoUrl = photoUrl;
            __weak typeof(self)weakSelf = self;
            [[SDWebImageManager sharedManager].imageCache queryImageForKey:videoUrl options:0 context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                if (image && [image isKindOfClass:[UIImage class]]) {
                    weakSelf.feedImageView.image = image;

                } else {
                    [self firstFrameWithVideoURL:[NSURL URLWithString:videoUrl] size:self.bounds.size completion:^(UIImage * _Nullable image) {
                        if (image && [image isKindOfClass:[UIImage class]]) {
                            [[SDWebImageManager sharedManager].imageCache storeImage:image imageData:nil forKey:videoUrl cacheType:SDImageCacheTypeDisk completion:nil];
                            weakSelf.feedImageView.image = image;;
                        }
                    }];
            
                }
            }];
        } else {
            [self.feedImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl]];
        }
    }

    self.feedVideoImageView.hidden = !isVideo;
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

- (IBAction)clearButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(feedBackMediaCell:clearPhoto:)]) {
        [self.delegate feedBackMediaCell:self clearPhoto:self.itemPhoto];
    }
}

@end
