//
//  XLTTimeoutProgressView.m
//  XingLeTao
//
//  Created by chenhg on 2020/3/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTimeoutProgressView.h"
#import "XLTUserTaskManager.h"
#import "MBProgressHUD+TipView.h"

@interface XLTTimeoutProgressView  ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) float timeout;
@property (nonatomic, copy) NSAttributedString *progressText;
@property (nonatomic, copy) NSAttributedString *timeoutText;
@end

@implementation XLTTimeoutProgressView

#pragma mark - Lifecycle

- (void)dealloc {
    
}

- (id)init {
    return [self initWithFrame:CGRectMake(0.f, 0.f, 64.f, 64.f)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        _progress = 0.f;
        _annular = NO;
        _progressTintColor = [UIColor colorWithHex:0xFFFFA902];
        _backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.5f];
    }
    return self;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    return CGSizeMake(64.f, 64.f);
}

#pragma mark - Properties

- (void)setProgress:(float)progress {
    if (progress != _progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    NSAssert(progressTintColor, @"The color should not be nil.");
    if (progressTintColor != _progressTintColor && ![progressTintColor isEqual:_progressTintColor]) {
        _progressTintColor = progressTintColor;
        [self setNeedsDisplay];
    }
}

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor {
    NSAssert(backgroundTintColor, @"The color should not be nil.");
    if (backgroundTintColor != _backgroundTintColor && ![backgroundTintColor isEqual:_backgroundTintColor]) {
        _backgroundTintColor = backgroundTintColor;
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_annular) {
        // Draw background
        CGFloat lineWidth = 4.f;
        UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
        processBackgroundPath.lineWidth = lineWidth;
        processBackgroundPath.lineCapStyle = kCGLineCapButt;
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGFloat radius = (self.bounds.size.width - lineWidth)/2;
        CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
        CGFloat endAngle = (2 * (float)M_PI) + startAngle;
        [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [_backgroundTintColor set];
        [processBackgroundPath stroke];
        // Draw progress
        UIBezierPath *processPath = [UIBezierPath bezierPath];
        processPath.lineCapStyle = kCGLineCapSquare;
        processPath.lineWidth = lineWidth;
        endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
        [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [_progressTintColor set];
        [processPath stroke];
    } else {
        // Draw background
        CGFloat lineWidth = 2.f;
        CGRect allRect = self.bounds;
        CGRect circleRect = CGRectInset(allRect, lineWidth/2.f, lineWidth/2.f);
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [_progressTintColor setStroke];
        [_backgroundTintColor setFill];
        CGContextSetLineWidth(context, lineWidth);

        CGContextStrokeEllipseInRect(context, circleRect);
        // 90 degrees
        CGFloat startAngle = - ((float)M_PI / 2.f);
        // Draw progress{
        UIBezierPath *processPath = [UIBezierPath bezierPath];
        processPath.lineCapStyle = kCGLineCapButt;
        processPath.lineWidth = lineWidth * 2.f;
        CGFloat radius = (CGRectGetWidth(self.bounds) / 2.f) - (processPath.lineWidth / 2.f);
        CGFloat endAngle = (self.progress * 2.f * (float)M_PI) + startAngle;
        [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        // Ensure that we don't get color overlapping when _progressTintColor alpha < 1.f.
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        [_progressTintColor set];
        [processPath stroke];
    }
}


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
                            timeoutText:(NSAttributedString *)timeoutText {
    CGFloat x = MAX(0, CGRectGetWidth(view.frame) - 64.0- 15.0);
    CGFloat bottomOffSet = 0;
    if (@available(iOS 11.0, *)) {
        bottomOffSet = view.safeAreaInsets.bottom;
    }
    XLTTimeoutProgressView *progressView = [[XLTTimeoutProgressView alloc] initWithFrame:CGRectMake(x, view.bounds.size.height - bottomOffSet - 64 - 20 -60, 64.0, 64.0)];
    progressView.userInteractionEnabled = NO;
    progressView.annular = YES;
    [view addSubview:progressView];
    progressView.progressText = progressText;
    progressView.timeoutText = timeoutText;
    progressView.timeout = timeout;
    return progressView;
}

- (void)setTimeout:(float)timeout {
    _timeout = timeout;
    if (timeout > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self showProgressText];
        [self performSelector:@selector(updateProgressWithDuration:) withObject:@1.0 afterDelay:1.0 inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)updateProgressWithDuration:(NSNumber *)duration {
    if (self.superview != nil) {
        if (self.timeout > 1.0) {
            CGFloat durationTime = [duration floatValue];
            CGFloat progress = durationTime/self.timeout;
            
            if (durationTime + 1.0 > self.timeout) {
                [self needCompleteProgressWithDuration:durationTime];
            } else {
                self.progress = progress;
                [self showProgressText];
                [self performSelector:@selector(updateProgressWithDuration:) withObject:@(1.0 + durationTime) afterDelay:1.0 inModes:@[NSRunLoopCommonModes]];
            }

        } else {
            [self completedProgress];
        }
        [self.superview bringSubviewToFront:self];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }

}

- (void)needCompleteProgressWithDuration:(CGFloat)durationTime {
    if (self.taskInfo) {
        __weak typeof(self)weakSelf = self;
        // 汇报结果
        [[XLTUserTaskManager shareManager] letaoRepoBrowseTaskInfo:self.taskInfo success:^(BOOL result,NSString * _Nullable errorMsg) {
            if (result) {
                [weakSelf completedProgress];
            } else {
                // 重试
                if ([errorMsg isKindOfClass:[NSString class]] && errorMsg.length > 0) {
                    [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
                } else {
                    // 重试
                    [weakSelf performSelector:@selector(updateProgressWithDuration:) withObject:@(1.0 + durationTime) afterDelay:1.0 inModes:@[NSRunLoopCommonModes]];
                }
            }
        }];
    } else {
        [self completedProgress];
    }
}

- (void)completedProgress {
    self.progress = 1.0;
    [self showTimeoutText];
}

- (void)showProgressText {
    [self showTipText:self.progressText];
}

- (void)showTimeoutText{
    [self showTipText:self.timeoutText];
}

- (void)showTipText:(NSAttributedString *)text {
    if (self.textLabel == nil) {
        CGRect rect = CGRectInset(self.bounds, 4.0, 4.0);
        self.textLabel = [[UILabel alloc] initWithFrame:rect];
        self.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.numberOfLines = 0;
        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.layer.cornerRadius = ceilf((rect.size.height)/2.0);
        [self addSubview:self.textLabel];
    }
    self.textLabel.attributedText = text;
}

@end
