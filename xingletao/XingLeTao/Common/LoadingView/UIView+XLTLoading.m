
#import "UIView+XLTLoading.h"
#import <objc/runtime.h>
#import "UIColor+Helper.h"
#import "XLTTipConstant.h"

@implementation UIView (XLTLoading)
- (void)letaoletaoShowLoading {
    if (self.letaoloadingView == nil) {
        XLTCircleAnimationView *animationView = [[XLTCircleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        animationView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        animationView.foregroundColor = UIColorMakeRGBA(255, 130, 2, .5);
        animationView.defaultBackGroundColor = [UIColor clearColor];
        [self addSubview:animationView];
        self.letaoloadingView = animationView;
    }
    [self addSubview:self.letaoloadingView];
    [self.letaoloadingView showAnimationWithType:XLTCircleAnimationTypeCircleJoin];
    [self letaoletaoRemoveErrorView];
}


- (void)letaoletaoShowDotLoadingWithBgImage:(UIImage *)image {
    if (self.letaoloadingView == nil) {
        XLTCircleAnimationView *animationView = [[XLTCircleAnimationView alloc] initWithFrame:self.bounds];
        animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        animationView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        animationView.foregroundColor = [UIColor lightGrayColor];
        animationView.defaultBackGroundColor = [UIColor clearColor];
        [self addSubview:animationView];
        self.letaoloadingView = animationView;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.letaoloadingView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.image = image;
        [self.letaoloadingView addSubview:imageView];
    }
    [self addSubview:self.letaoloadingView];
    [self.letaoloadingView showAnimationWithType:XLTCircleAnimationTypeDot];
    [self letaoletaoRemoveErrorView];
}

- (void)letaoletaoShowBgImageLoadingWithBgImage:(UIImage *)image {
    if (self.letaoloadingView == nil) {
        XLTCircleAnimationView *animationView = [[XLTCircleAnimationView alloc] initWithFrame:self.bounds];
        animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        animationView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        animationView.foregroundColor = [UIColor lightGrayColor];
        animationView.defaultBackGroundColor = [UIColor clearColor];
        [self addSubview:animationView];
        self.letaoloadingView = animationView;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.letaoloadingView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.image = image;
        [self.letaoloadingView addSubview:imageView];
    }
    [self addSubview:self.letaoloadingView];
    [self letaoletaoRemoveErrorView];
}

- (void)letaoletaoRemoveLoading {
    [self.letaoloadingView removeSubLayer];
    [self.letaoloadingView removeFromSuperview];
    self.letaoloadingView = nil;
}

- (void)letaoletaoShowErrorViewWithBlock:(XLTEmotyActionTapBlock)clickBlock;{
    if (self.letaoletaoErrorView == nil) {
        
        LetaoEmptyCoverView *letaoEmptyCoverView = [LetaoEmptyCoverView emptyActionViewWithImageStr:@"noimage"
                                                                   titleStr:Data_Error_Retry
                                                                  detailStr:@""
                                                                btnTitleStr:@"重新加载"
                                                              btnClickBlock:^(){
                                                                  if (clickBlock) {
                                                                      clickBlock();
                                                                  }
                                                              }];
        letaoEmptyCoverView.subViewMargin = 28.f;
        letaoEmptyCoverView.contentViewOffset = - 10;
        
        letaoEmptyCoverView.titleLabFont = [UIFont systemFontOfSize:14.f];
        letaoEmptyCoverView.titleLabTextColor = UIColorMakeRGB(199, 199, 199);
        
        letaoEmptyCoverView.actionBtnFont = [UIFont boldSystemFontOfSize:16.f];
        letaoEmptyCoverView.actionBtnTitleColor = UIColorMakeRGB(70, 70, 70);
        letaoEmptyCoverView.actionBtnHeight = 40.f;
        letaoEmptyCoverView.actionBtnHorizontalMargin = 62.f;
        letaoEmptyCoverView.actionBtnCornerRadius = 20.f;
        //        letaoEmptyCoverView.actionBtnBorderColor = UIColorMakeRGB(204, 204, 204);
        letaoEmptyCoverView.actionBtnBorderColor = [UIColor letaomainColorSkinColor];
        letaoEmptyCoverView.actionBtnBorderWidth = 0.5;
        letaoEmptyCoverView.actionBtnBackGroundColor = self.backgroundColor;
        self.letaoletaoErrorView = letaoEmptyCoverView;
    }
    [self addSubview:self.letaoletaoErrorView];

    [self letaoletaoRemoveLoading];

}

- (void)letaoletaoRemoveErrorView {
    [self.letaoletaoErrorView removeFromSuperview];
    self.letaoletaoErrorView = nil;
}


#pragma mark - letaoloadingView & letaoletaoErrorView

- (XLTCircleAnimationView *)letaoloadingView {
    XLTCircleAnimationView *animationView = objc_getAssociatedObject(self, @selector(letaoloadingView));
    return animationView;
}

- (void)setLetaoloadingView:(XLTCircleAnimationView *)letaoloadingView {
    objc_setAssociatedObject(self, @selector(letaoloadingView), letaoloadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (LetaoEmptyCoverView *)letaoletaoErrorView {
    LetaoEmptyCoverView *letaoEmptyCoverView = objc_getAssociatedObject(self, @selector(letaoletaoErrorView));
    return letaoEmptyCoverView;
}

- (void)setLetaoletaoErrorView:(LetaoEmptyCoverView *)letaoletaoErrorView {
    objc_setAssociatedObject(self, @selector(letaoletaoErrorView), letaoletaoErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

@end
