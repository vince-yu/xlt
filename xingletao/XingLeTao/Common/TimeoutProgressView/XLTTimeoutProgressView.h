//
//  XLTTimeoutProgressView.h
//  XingLeTao
//
//  Created by chenhg on 2020/3/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTTimeoutProgressView : UIView
/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color.
 * Only applicable on iOS versions older than iOS 7.
 * Defaults to translucent white (alpha 0.1).
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;



/**
 * 设置超时进度条
 *
 * @param view 父视图
 * @param timeout 进度时间
 * @param progressText 进度完成之前的文本
 * @param timeoutText 进度完成之后的文本
 * @return A reference to the created XLTTimeoutProgressView.
 */
+ (instancetype)showProgressViewAddedTo:(UIView *)view
                                timeout:(CGFloat)timeout
                           progressText:(NSAttributedString *)progressText
                            timeoutText:(NSAttributedString *)timeoutText;


/// 任务信息数据
@property (nonatomic, strong, nullable) NSDictionary *taskInfo;

@end

NS_ASSUME_NONNULL_END
