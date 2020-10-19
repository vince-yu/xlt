//
//  XLTRecommedFeedUploadOperation.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTRecommedFeedUploadOperation.h"
#import "TZImageManager.h"
#import "XLTRecommedFeedLogic.h"
#import "UIImage+XLTCompress.h"

@implementation XLTRecommedFeedUploadOperation

- (void)start {
    NSLog(@"XLTRecommedFeedUploadOperation start");
    self.executing = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#pragma mark - 获取&上传大图
        if(self.asset.mediaType == PHAssetMediaTypeVideo) {
            [[TZImageManager manager] getVideoOutputPathWithAsset:self.asset success:^(NSString *outputPath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XLTRecommedFeedLogic uploadFeedFileType:@"video" filePath:outputPath success:^(NSDictionary * _Nonnull info) {
                        [self uploadDone:info];
                    } failure:^(NSString * _Nonnull errorMsg) {
                        [self uploaddoneError];
                    }];
                });
            } failure:^(NSString *errorMessage, NSError *error) {
                [self uploaddoneError];
            }];
        } else if (self.asset.mediaType == PHAssetMediaTypeImage) {
            [[TZImageManager manager] getPhotoWithAsset:self.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!isDegraded) {
                        if (self.completedBlock) {
                            self.completedBlock(photo, info, isDegraded);
                        }
                        NSData *imageData = [photo letaocompressWithMaxLength:1024*1024];
                        [XLTRecommedFeedLogic uploadFeedImageData:imageData success:^(NSDictionary * _Nonnull info) {
                            [self uploadDone:info];
                        } failure:^(NSString * _Nonnull errorMsg) {
                            [self uploaddoneError];
                        }];
                    }
                });
            } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.progressBlock) {
                        self.progressBlock(progress, error, stop, info);
                    }
                });
            } networkAccessAllowed:YES];
        } else {
            [self uploaddoneError];
        }

         
        
//#pragma mark - 获取&上传原图
//        [[TZImageManager manager] getOriginalPhotoWithAsset:self.asset progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (self.progressBlock) {
//                    self.progressBlock(progress, error, stop, info);
//                }
//            });
//        } newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (!isDegraded) {
//                    if (self.completedBlock) {
//                        self.completedBlock(photo, info, isDegraded);
//                    }
//                    // 在这里上传图片(代码略)，图片上传完毕后调用[self done]
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self done];
//                    });
//
//                }
//            });
//        }];
    });
}

- (void)done {
    [super done];
    // NSLog(@"TZImageUploadOperation done");
}

- (void)uploadDone:(NSDictionary *)info {
    [super done];
    if (self.uploadBlock) {
         self.uploadBlock(info,YES);
    }
}

- (void)uploaddoneError {
    self.isUploadFailed = YES;
    [super done];
    if (self.uploadBlock) {
         self.uploadBlock(nil,NO);
    }
}

@end
