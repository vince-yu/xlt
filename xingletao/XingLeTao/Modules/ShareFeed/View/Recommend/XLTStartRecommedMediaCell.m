//
//  XLTFeedBackMediaCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTStartRecommedMediaCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface XLTStartRecommedMediaCell ()
@property (nonatomic, weak) IBOutlet UIImageView *feedImageView;
@property (nonatomic, weak) IBOutlet UIImageView *feedVideoImageView;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) id itemPhoto;

@end

@implementation XLTStartRecommedMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHex:0xFFC3C4C7].CGColor;
}

- (void)updatePhoto:(UIImage *)photo isVideo:(BOOL)isVideo {
    self.itemPhoto = photo;
    if ([photo isKindOfClass:[UIImage class]]) {
        self.clearButton.hidden = NO;
        self.feedImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.feedImageView.image = photo;
    } else {
        self.clearButton.hidden = YES;
        self.feedImageView.image = [UIImage imageNamed:@"feed_add_photo_min"];
        self.feedImageView.contentMode = UIViewContentModeCenter;
    }
    self.feedVideoImageView.hidden = !isVideo;
}

- (void)updatePhotoUrl:(NSString *)photoUrl isVideo:(BOOL)isVideo {
    self.itemPhoto = photoUrl;
    if ([photoUrl isKindOfClass:[NSString class]]) {
        self.clearButton.hidden = NO;
        self.feedImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (isVideo) {
            NSString *videoUrl = photoUrl;
            __weak typeof(self)weakSelf = self;
            [[SDWebImageManager sharedManager].imageCache queryImageForKey:videoUrl options:0 context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                if (image && [image isKindOfClass:[UIImage class]]) {
                    weakSelf.feedImageView.image = image;

                } else {
                    [self firstFrameWithVideoURL:[NSURL URLWithString:[videoUrl letaoConvertToHttpsUrl]] size:self.bounds.size completion:^(UIImage * _Nullable image) {
                        if (image && [image isKindOfClass:[UIImage class]]) {
                            [[SDWebImageManager sharedManager].imageCache storeImage:image imageData:nil forKey:videoUrl cacheType:SDImageCacheTypeDisk completion:nil];
                            weakSelf.feedImageView.image = image;;
                        }
                    }];
            
                }
            }];
        } else {
            [self.feedImageView sd_setImageWithURL:[NSURL URLWithString:[photoUrl letaoConvertToHttpsUrl]]];
        }
    } else {
        self.clearButton.hidden = YES;
        self.feedImageView.image = [UIImage imageNamed:@"feed_add_photo"];
        self.feedImageView.contentMode = UIViewContentModeCenter;
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
    if ([self.delegate respondsToSelector:@selector(recommedMediaCell:clearPhoto:)]) {
        [self.delegate recommedMediaCell:self clearPhoto:self.itemPhoto];
    }
}

@end
