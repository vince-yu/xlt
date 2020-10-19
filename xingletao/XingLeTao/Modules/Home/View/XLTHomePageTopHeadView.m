//
//  XLTHomePageTopHeadView.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/1.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomePageTopHeadView.h"

@interface XLTHomePageTopHeadView ()

@property (nonatomic, assign) BOOL isUsingBgStyle;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *bottomCircleView;
@property (nonatomic, strong) UIView *noneAdMaskView; // 没有广告的时候显示
@property (nonatomic, strong) NSDictionary *bannerInfo;

@end

@implementation XLTHomePageTopHeadView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBgHeight)];
    if (self) {

        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.layer.masksToBounds = YES;
        [self addSubview:_bgImageView];
        
        [self setupDefaultBgStyle];
        
        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_circle"];
        CGFloat bottomCircleHeight = ceilf(self.bounds.size.width/375*35);
        
        _bottomCircleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bgImageView.bounds.size.height - bottomCircleHeight +1, _bgImageView.bounds.size.width, bottomCircleHeight)];
        _bottomCircleView.image = bottomCircleImage;
        [_bgImageView addSubview:_bottomCircleView];
        

//        _navBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeadNavHeight)];
//        _navBgImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _navBgImageView.hidden = YES;
//        [self addSubview:_bgImageView];
        
        _letaoQrcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_letaoQrcodeBtn setImage:[UIImage imageNamed:@"home_qrcode"] forState:UIControlStateNormal];
        [_letaoQrcodeBtn addTarget:self action:@selector(letaoQrcodeScanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _letaoQrcodeBtn.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
        [self addSubview:_letaoQrcodeBtn];
        
        
        UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_letaoQrcodeBtn.frame), _letaoQrcodeBtn.frame.origin.y +7, self.bounds.size.width -CGRectGetMaxX(_letaoQrcodeBtn.frame) - 15, 30)];
        self.letaoSearchTextFiled = letaoSearchTextFiled;
        letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[XLTAppPlatformManager shareManager] platformText:@"粘贴商品标题、口令、链接搜索"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
        letaoSearchTextFiled.backgroundColor = [UIColor whiteColor];
        letaoSearchTextFiled.layer.masksToBounds = YES;
        letaoSearchTextFiled.layer.cornerRadius = 15;
        [self addSubview:letaoSearchTextFiled];
                   
        UIImageView *searchIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 3, 13, 13)];
        searchIconImageView.image = [UIImage imageNamed:@"xinletao_home_search_image"];
                   UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+13+5, 20)];
        [leftPaddingView addSubview:searchIconImageView];
        leftPaddingView.backgroundColor = [UIColor clearColor];
        letaoSearchTextFiled.leftView = leftPaddingView;
        letaoSearchTextFiled.leftViewMode = UITextFieldViewModeAlways;
                   
                   //
        UIButton *searchBarOverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBarOverButton.backgroundColor = [UIColor clearColor];
        searchBarOverButton.frame = letaoSearchTextFiled.bounds;
        searchBarOverButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [searchBarOverButton addTarget:self action:@selector(letaoSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [letaoSearchTextFiled addSubview:searchBarOverButton];
        
        // 分类
        CGFloat segmentedControlWidth = self.frame.size.width;
        _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY((self.letaoQrcodeBtn.frame)), segmentedControlWidth -20, 44)];
        _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _letaoSegmentedControl.backgroundColor = [UIColor clearColor];
        _letaoSegmentedControl.selectionIndicatorHeight = 4;
        _letaoSegmentedControl.selectionIndicatorColor = [UIColor whiteColor];
        _letaoSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _letaoSegmentedControl.type = HMSegmentedControlTypeText;
        _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _letaoSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 10, -6, 20);
        _letaoSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:16.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
        _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:16.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        [self addSubview:_letaoSegmentedControl];
        
        
        self.letaoTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage animatedImageNamed:@"xinletao_home_task"duration:1.2];
        [self.letaoTaskBtn setImage:image forState:UIControlStateNormal];
        [self.letaoTaskBtn addTarget:self action:@selector(letaoTaskBtnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.letaoTaskBtn.frame = CGRectMake(self.bounds.size.width - 44-5, kStatusBarHeight, 44, 44);
        [self addSubview:self.letaoTaskBtn];
        
        [self showLetaoTaskBtnIfNeed];
        
        
        _noneAdMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_letaoSegmentedControl.frame), _bgImageView.bounds.size.width, _bgImageView.bounds.size.height - CGRectGetMaxY(_letaoSegmentedControl.frame))];
        _noneAdMaskView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
        [_bgImageView addSubview:_noneAdMaskView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoCheckEnableChangedNotification) name:kLetaoCheckEnableChangedNotification object:nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageVCIndexChangedNotification:) name:@"XLTHomePageVCIndexChangedNotification" object:nil];
    }
    return self;
}

- (void)clearAdBg {
    self.bannerInfo = nil;
    self.noneAdMaskView.hidden = NO;
    [self setupDefaultBgStyle];
}

- (void)showLetaoTaskBtnIfNeed {
    BOOL showTaskBtn = [XLTAppPlatformManager shareManager].checkEnable;
    if (showTaskBtn) {
        self.letaoTaskBtn.hidden = NO;
        self.letaoSearchTextFiled.frame = CGRectMake(CGRectGetMaxX(self.letaoQrcodeBtn.frame), self.letaoQrcodeBtn.frame.origin.y +7, self.letaoTaskBtn.frame.origin.x -CGRectGetMaxX(self.letaoQrcodeBtn.frame), 30);

    } else {
        self.letaoTaskBtn.hidden = YES;
        self.letaoSearchTextFiled.frame = CGRectMake(CGRectGetMaxX(self.letaoQrcodeBtn.frame), self.letaoQrcodeBtn.frame.origin.y +7, self.bounds.size.width -CGRectGetMaxX(self.letaoQrcodeBtn.frame) - 15, 30);
    }
}

- (void)letaoCheckEnableChangedNotification {
    [self showLetaoTaskBtnIfNeed];
}


- (void)letaoSearchButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoTopHeadView:letaoSearchText:)]) {
        [self.delegate letaoTopHeadView:self letaoSearchText:nil];
    }
}

- (void)letaoQrcodeScanBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoTopHeadView:qrcodeScanAction:)]) {
        [self.delegate letaoTopHeadView:self qrcodeScanAction:sender];
    }
}
- (void)letaoTaskBtnBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoTopHeadView:taskButtonAction:)]) {
        [self.delegate letaoTopHeadView:self taskButtonAction:sender];
    }
}

- (void)scrollBanner:(NSDictionary *)startBanner toBanner:(NSDictionary *)endBanner rate:(CGFloat)rate {
    self.noneAdMaskView.hidden = YES;
    
    NSString *startImageUrl = nil;
    UIColor *startColor = nil;
    if ([startBanner isKindOfClass:[NSDictionary class]]) {
        startImageUrl = startBanner[@"bgImage"];
        NSString *startBgColorText = startBanner[@"bgColor"];
        if ([startBgColorText isKindOfClass:[NSString class]] && startBgColorText.length > 0){
            startColor = [UIColor colorWithHexString:[startBgColorText stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        }
    }
    
    NSString *endImageUrl = nil;
    UIColor *endColor = nil;
    if ([endBanner isKindOfClass:[NSDictionary class]]) {
        endImageUrl = endBanner[@"bgImage"];
        NSString *endBgColorText = endBanner[@"bgColor"];
        if ([endBgColorText isKindOfClass:[NSString class]] && endBgColorText.length > 0) {
            endColor = [UIColor colorWithHexString:[endBgColorText stringByReplacingOccurrencesOfString:@"#" withString:@""]];
        }
    }
    BOOL hasImage =  ([startImageUrl isKindOfClass:[NSString class]] && startImageUrl.length > 0) || ([endImageUrl isKindOfClass:[NSString class]] && endImageUrl.length > 0);
    BOOL isTransitionColor = ([startColor isKindOfClass:[UIColor class]] && [endColor isKindOfClass:[UIColor class]]
                              && !hasImage);
    if (isTransitionColor) {
        UIColor *currentToLastColor = [XLTHomePageTopHeadView getColorWithColor:startColor andCoe:rate andEndColor:endColor];
        [self changeBgColor:currentToLastColor];
    } else {
        if (rate > 0.5) {
            if (![self.bannerInfo isEqualToDictionary:endBanner]) {
                self.bannerInfo = endBanner;
                if ([endImageUrl isKindOfClass:[NSString class]] && endImageUrl.length > 0) {
                    [self changeBgImageWithUrl:endImageUrl];
                } else if ([endColor isKindOfClass:[UIColor class]]){
                    [self changeBgColor:endColor];
                } else {
                    [self setupDefaultBgStyle];
                }
            }

        } else {
            if (![self.bannerInfo isEqualToDictionary:startBanner]) {
                self.bannerInfo = startBanner;
                if ([startImageUrl isKindOfClass:[NSString class]] && startImageUrl.length > 0) {
                    [self changeBgImageWithUrl:startImageUrl];
                } else if ([startColor isKindOfClass:[UIColor class]]){
                    [self changeBgColor:startColor];
                } else {
                    [self setupDefaultBgStyle];
                }
            }
        }
    }
}


- (void)changeBgImageWithUrl:(NSString *)imageUrl {
    if ([imageUrl isKindOfClass:[NSString class]] && imageUrl.length > 0) {
        NSDictionary *bannerInfo = [self.bannerInfo copy];
        // 查看缓存
        NSString *picUrl = [imageUrl letaoConvertToHttpsUrl];
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:picUrl]];
        UIImage *bgImage  = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageKey];
        if ([bgImage isKindOfClass:[UIImage class]]) {
            [self changeBgImage:bgImage];
        } else {
            [self changeDefaultBgStyleIfNeed];
            __weak typeof(self)weakSelf = self;
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:picUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if ([weakSelf.bannerInfo isEqualToDictionary:bannerInfo]) {
                    if(image) {
                        [weakSelf changeBgImage:image];
                    } else {
                        // 图片下载失败了，设置默认背景
                        [weakSelf setupDefaultBgStyle];
                    }
                }
            }];
        }
    }
}

- (void)changeBgImage:(UIImage *)image {
    // 设置背景图片
    if (image.size.width >0 && image.size.height > 0) {
        //  设置背景图片和动画
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.bgImageView.layer addAnimation:transition forKey:@"bgTransition"];
        self.bgImageView.image = image;
    }
}


- (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect {
    CGRect clipFrame = rect;
    CGImageRef refImage = CGImageCreateWithImageInRect(image.CGImage, clipFrame);
    UIImage *newImage = [UIImage imageWithCGImage:refImage];
    CGImageRelease(refImage);
    return newImage;
}

- (void)changeBgColor:(UIColor *)color {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.bgImageView.layer addAnimation:transition forKey:@"bgTransition"];
    self.bgImageView.image = [UIImage gradientColorImageFromColors:@[color,color] gradientType:1 imgSize:CGSizeMake(kScreenWidth, kHeadBgHeight)];
}

// 不存在北京图片和颜色的时候使用
- (void)changeDefaultBgStyleIfNeed {
    if (self.bgImageView.image == nil) {
        [self setupDefaultBgStyle];
    }
}


- (void)setupDefaultBgStyle {
    UIImage *bgImage = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFFAE01],[UIColor colorWithHex:0xFFFF6E02]] gradientType:1 imgSize:CGSizeMake(kScreenWidth, kHeadBgHeight)];
    [self changeBgImage:bgImage];
}

- (void)homePageVCIndexChangedNotification:(NSNotification *)notification {
    NSNumber *pageIndex = notification.object;
    if ([pageIndex isKindOfClass:[NSNumber class]]) {
        NSInteger homePageVCIndex = [pageIndex integerValue];
        if (homePageVCIndex == 0) {
            // 恢复
            
            NSString *startImageUrl = nil;
            UIColor *startColor = nil;
            if ([self.bannerInfo isKindOfClass:[NSDictionary class]]) {
                startImageUrl = self.bannerInfo[@"bgImage"];
                NSString *startBgColorText = self.bannerInfo[@"bgColor"];
                if ([startBgColorText isKindOfClass:[NSString class]] && startBgColorText.length > 0){
                    startColor = [UIColor colorWithHexString:[startBgColorText stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                }
            }
            if ([startImageUrl isKindOfClass:[NSString class]] && startImageUrl.length > 0) {
                [self changeBgImageWithUrl:startImageUrl];
            } else if ([startColor isKindOfClass:[UIColor class]]){
                [self changeBgColor:startColor];
            } else {
                [self setupDefaultBgStyle];
            }
            
        } else {
            // 设置默认样式
            [self setupDefaultBgStyle];
        }
    }
}

@end



@implementation XLTHomePageTopHeadView (TransColor)

/**
 16进制颜色转换为UIColor
 
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity {
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}


+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor {
    CGFloat r = 0,g = 0,b = 0,a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[@(r),@(g),@(b)];
}

+ (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor {
    NSArray<NSNumber *> *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray<NSNumber *> *endColorArr = [self getRGBDictionaryByColor:endColor];
    return @[@([endColorArr[0] doubleValue] - [beginColorArr[0] doubleValue]),@([endColorArr[1] doubleValue] - [beginColorArr[1] doubleValue]),@([endColorArr[2] doubleValue] - [beginColorArr[2] doubleValue])];
}

+ (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe  andEndColor:(UIColor *)endColor {
    NSArray *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray *marginArray = [self transColorBeginColor:beginColor andEndColor:endColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


- (void)cycleMainScrollViewDidScroll:(UIScrollView *)scrollView toIndex:(NSInteger)index {
    
}

@end
