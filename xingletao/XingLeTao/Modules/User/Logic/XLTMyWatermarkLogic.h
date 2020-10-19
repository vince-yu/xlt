//
//  XLTMyWatermarkLogic.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyWatermarkLogic : XLTNetBaseLogic

@property (nonatomic, assign) BOOL watermarkSwitchOn;
@property (nonatomic, strong, nullable) NSString *watermarkText;
@property (nonatomic, assign) BOOL isAddWatermarkObserver;

+ (instancetype)shareInstance;

// 获取我的水印
- (void)requestMyWatermarkInfoSuccess:(void(^)(NSDictionary * _Nonnull info))success
                              failure:(void(^)(NSString *errorMsg))failure;

// 更新我的水印
- (void)updateMyWatermark:(NSString *)watermark
                  enabled:(BOOL)enabled
                  success:(void(^)(NSDictionary * _Nonnull info))success
                  failure:(void(^)(NSString *errorMsg))failure;

// 添加水印
- (void)addWatermarkIfNeedForImages:(NSArray *)images
                         completion:(void(^)(NSArray * _Nonnull watermarkImages))completion;

- (NSArray *)addWatermarkForImages:(NSArray *)images;
- (NSArray *)addWatermarkForImages:(NSArray *)images watermarkText:(NSString *)watermarkText;
@end

NS_ASSUME_NONNULL_END
