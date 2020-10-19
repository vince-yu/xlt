//
//  XLTInvatePictureView.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/24.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTInvatePictureView.h"
#import "XLTUserManager.h"
#import "UIImageView+WebCache.h"

@interface XLTInvatePictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *letaobgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *invateImageView;
@property (weak, nonatomic) IBOutlet UILabel *invateLabel;
@property (weak, nonatomic) IBOutlet UIView *invateBgView;

@property (nonatomic, copy) void(^completeBlock)(BOOL success, UIImage *image);
@property (nonatomic, assign) NSUInteger downloadTaskCount;
@property (nonatomic, assign) NSUInteger totalTaskCount;
@end

@implementation XLTInvatePictureView

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.invateBgView.layer.cornerRadius = 16.5;
//    self.invateBgView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)generateWithImageUrl:(NSString *)imageUrl qrcodeImage:(UIImage *)qrcodeImage qrcodeCode:(NSString *)qrcodeCode complete:(void(^)(BOOL success, UIImage *  _Nullable image))complete {
    if (!([imageUrl isKindOfClass:[NSString class]])) {
        complete(NO,nil);
        return;
     }
//    BOOL isqQrcodeCodeValid = ([qrcodeCode isKindOfClass:[NSString class]]
//                               && qrcodeCode.length > 0);
//    if (isqQrcodeCodeValid) {
//        self.invateLabel.text = [NSString stringWithFormat:@"邀请码：%@",qrcodeCode];
//    }
//    self.invateLabel.hidden = !isqQrcodeCodeValid;

    self.completeBlock = complete;
    self.totalTaskCount = 1;
    self.downloadTaskCount = 0;
//    XLT_WeakSelf;
    [self.letaobgImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderLargeImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            XLT_StrongSelf;
            if (image) {
                self.completeBlock(YES, image);
            } else {
                self.completeBlock(NO, nil);
            }
        });
    }];
//    self.invateImageView.image = qrcodeImage;
//    [self.invateImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (image) {
//                [self increaseOneTask];
//
//            } else {
//                [self completeTask:NO image:nil];
//            }
//        });
//    }];
}

- (void)increaseOneTask {
    self.downloadTaskCount ++ ;
    if (self.downloadTaskCount >= self.totalTaskCount) {
        UIImage *image = [self letaoConvertViewToImage:self size:self.bounds.size];
        [self completeTask:YES image:image];
    }
}


- (void)completeTask:(BOOL)success image:(UIImage *)image {
    if (self.completeBlock) {
        self.completeBlock(success,image);
        self.completeBlock = nil;
    }
}

- (UIImage *)letaoConvertViewToImage:(UIView *)view size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
