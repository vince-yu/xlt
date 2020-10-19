//
//  XLTHotOnlineHeadView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHotOnlineHeadView.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"
#import "UIImage+UIColor.h"

@interface XLTHotOnlineHeadView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UIImageView *letaobgImageView;
@property (nonatomic, strong) UIImageView *bottomCircleImageView;
@end
@implementation XLTHotOnlineHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#define kSegmentedControlHeight 44
#define kSearchBarHeight 44
#define kBottomSpace (42+35)
#define kHomeHeadViewDefaultHeight (kStatusBarHeight+kSearchBarHeight+kSegmentedControlHeight +kBottomSpace)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
                
        _letaobgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFFAE01]] gradientType:0 imgSize:_letaobgImageView.bounds.size];
                _letaobgImageView.image = bgImage;
        [self addSubview:_letaobgImageView];
                
        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
                CGFloat bottomCircleHeight = ceilf(self.bounds.size.width/375*35);
        _bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
        _bottomCircleImageView.frame = CGRectMake(0, self.bounds.size.height - bottomCircleHeight, self.bounds.size.width, bottomCircleHeight);
        [self addSubview:_bottomCircleImageView];
        
        UILabel *letaoNavTitleLabel = [[UILabel alloc] init];
        letaoNavTitleLabel.text = @"红人街";
        letaoNavTitleLabel.font = [UIFont letaoMediumBoldFontWithSize:18.0];
        letaoNavTitleLabel.textAlignment = NSTextAlignmentCenter;
        letaoNavTitleLabel.textColor = [UIColor whiteColor];
        letaoNavTitleLabel.frame = CGRectMake(0, kStatusBarHeight, self.bounds.size.width, 44);
        [self addSubview:letaoNavTitleLabel];
                
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, kStatusBarHeight , 44, 44);
        [leftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_white"] forState:UIControlStateNormal];
        [self addSubview:leftButton];
        self.leftButton = leftButton;
              

        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(self.bounds.size.width - 44 -12, kStatusBarHeight , 44, 44);
        UIImage *search = [[UIImage imageNamed:@"xingletao_order_search_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        searchButton.tintColor = [UIColor whiteColor];
        [searchButton setImage:search forState:UIControlStateNormal];
        [self addSubview:searchButton];
          
          self.searchButton = searchButton;
    }
    return self;
}


- (void)letaoSetupSegmentedControl {
    // 配置`菜单视图`
    CGFloat segmentedControlWidth = self.frame.size.width;
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY((self.leftButton.frame)), segmentedControlWidth -20, kSegmentedControlHeight)];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.useCustomIndicatorBox = YES;
    _segmentedControl.selectionIndicatorHeight = 0.0;
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segmentedControl.selectionIndicatorBoxColor = [UIColor whiteColor];
    _segmentedControl.selectionIndicatorBoxOpacity = 1.0;
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    
    [self addSubview:_segmentedControl];
}

 /*
  gradientType
  0,//从上到小
  1,//从左到右
  2,//左上到右下
  3,//右上到左下
  */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(int )gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case 3:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

+ (CGFloat)headViewDefaultHeight {
    return kHomeHeadViewDefaultHeight;
}


@end
