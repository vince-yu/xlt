

#import <UIKit/UIKit.h>
#import "LetaoEmptyCoverView.h"
#import "XLTCircleAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XLTLoading)

@property (nonatomic, weak) LetaoEmptyCoverView *letaoletaoErrorView;
@property (nonatomic, weak) XLTCircleAnimationView *letaoloadingView;


- (void)letaoletaoShowLoading;
- (void)letaoletaoShowDotLoadingWithBgImage:(UIImage *)image;
- (void)letaoletaoShowBgImageLoadingWithBgImage:(UIImage *)image;
- (void)letaoletaoRemoveLoading;

- (void)letaoletaoShowErrorViewWithBlock:(XLTEmotyActionTapBlock)clickBlock;

- (void)letaoletaoRemoveErrorView;
@end

NS_ASSUME_NONNULL_END
