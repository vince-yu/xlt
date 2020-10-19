//
//  XLTMyWatermarkLogic.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTMyWatermarkLogic.h"
#import "NSAttributedString+YYText.h"
#import "YYTextLayout.h"
#import "UIImage+Resize.h"

@interface XLTMyWatermarkLogic ()
@end

@implementation XLTMyWatermarkLogic

+ (instancetype)shareInstance {
    static XLTMyWatermarkLogic *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// 获取我的水印
- (void)requestMyWatermarkInfoSuccess:(void(^)(NSDictionary * _Nonnull info))success
                              failure:(void(^)(NSString *errorMsg))failure {
    __weak __typeof(self)weakSelf = self;
    [XLTNetworkHelper GET:kMyWatermarkInfoUrl parameters:nil success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                [weakSelf updateLocalWatermark:model.data];
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}

// 更新我的水印
- (void)updateMyWatermark:(NSString *)watermark
                  enabled:(BOOL)enabled
                  success:(void(^)(NSDictionary * _Nonnull info))success
                  failure:(void(^)(NSString *errorMsg))failure {
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"watermark"] = watermark;
    parameters[@"enabled"] = [NSNumber numberWithBool:enabled];
    [XLTNetworkHelper POST:kUpdateMyWatermarkInfoUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                success(model.data);
                weakSelf.watermarkText = watermark;
                weakSelf.watermarkSwitchOn = enabled;
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        failure(Data_Error);
    }];
}


- (void)updateLocalWatermark:(NSDictionary * _Nullable)info {
    if ([info isKindOfClass:[NSDictionary class]] && info.count > 0) {
        NSString *watermark = info[@"watermark"];
        if ([watermark isKindOfClass:[NSString class]]) {
            self.watermarkText = watermark;
        }
        
        NSNumber *enabled = info[@"enabled"];
        if ([enabled isKindOfClass:[NSString class]] || [enabled isKindOfClass:[NSNumber class]]) {
            self.watermarkSwitchOn = [enabled boolValue];
        }
    }
}

- (void)addWatermarkIfNeedForImages:(NSArray *)images
                        completion:(void(^)(NSArray * _Nonnull watermarkImages))completion {
    __weak __typeof(self)weakSelf = self;
    [self requestMyWatermarkInfoSuccess:^(NSDictionary * _Nonnull info) {
        BOOL needAddWatermark = NO;
        NSString *watermark = info[@"watermark"];
        NSNumber *enabled = info[@"enabled"];
        if ([watermark isKindOfClass:[NSString class]] && watermark.length > 0) {
            if ([enabled isKindOfClass:[NSString class]] || [enabled isKindOfClass:[NSNumber class]]) {
                if ([enabled boolValue]) {
                    needAddWatermark = YES;
                }
            }
        }
        if (needAddWatermark) {
            NSArray *watermarkImages = [weakSelf addWatermarkForImages:images];
            completion(watermarkImages);
        } else {
            completion(images);
        }
    } failure:^(NSString * _Nonnull errorMsg) {
        completion(images);
    }];
}


- (NSArray *)addWatermarkForImages:(NSArray *)images {
    return  [self addWatermarkForImages:images watermarkText:self.watermarkText];
}


- (NSArray *)addWatermarkForImages:(NSArray *)images watermarkText:(NSString *)watermarkText {
    //        16
    //        33
    //        2
    if (![watermarkText isKindOfClass:[NSString class]]) {
        watermarkText = @"";
    }
    NSMutableArray *watermarkImages = [NSMutableArray array];
    UIImage *watermarkImage = [UIImage imageNamed:@"watermark_letao_icon"];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [images enumerateObjectsUsingBlock:^(UIImage *  _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([image isKindOfClass:[UIImage class]]) {
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
            [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
            CGFloat scale = image.size.width/345.0;
            CGFloat fontsize = ceilf(23.0 *scale);
            UIFont *font = [UIFont letaoMediumBoldFontWithSize:fontsize];
            NSDictionary *attributes = @{NSParagraphStyleAttributeName:style,
                                         NSFontAttributeName: font, NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.35],
                                         NSStrokeColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.2],
                                         NSStrokeWidthAttributeName: @-1,
            };
            CGFloat top = MAX(0, (image.size.height - (33 +16)*scale)/2);
            CGRect waterRect = CGRectMake(0,top,image.size.width,ceilf(33 *scale));
            [watermarkText drawInRect:waterRect withAttributes:attributes];
            
            CGFloat watermarkImage_w = watermarkImage.size.width *scale;
            CGFloat watermarkImage_h = watermarkImage.size.height *scale;
            [watermarkImage drawInRect:CGRectMake( ceilf((image.size.width - watermarkImage_w)/2),top+(33)*scale,watermarkImage_w ,watermarkImage_h)];

            UIImage *watermarkNewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [watermarkImages addObject:watermarkNewImage];
        } else {
            [watermarkImages addObject:image];
        }
    }];
    return watermarkImages;
}

@end
