//
//  XLTHomeCustomHeadView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCustomHeadView.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"
#import "UIImageView+WebCache.h"

@interface XLTHomeCustomHeadView ()
@property (nonatomic, strong) UIImageView *letaobgImageView;
@property (nonatomic, strong) UIImageView *bottomCircleImageView;
@property (nonatomic, assign) BOOL shouldShowTopAd;

@end
@implementation XLTHomeCustomHeadView

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _letaobgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFFAE01]] gradientType:0 imgSize:_letaobgImageView.bounds.size];
//        _letaobgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _letaobgImageView.image = bgImage;
        [self addSubview:_letaobgImageView];
        
        UIImage *bottomCircleImage = [UIImage imageNamed:@"home_header_bg"];
        CGFloat bottomCircleHeight = ceilf(self.bounds.size.width/375*35);
        _bottomCircleImageView = [[UIImageView alloc] initWithImage:bottomCircleImage];
        _bottomCircleImageView.frame = CGRectMake(0, self.bounds.size.height - bottomCircleHeight, self.bounds.size.width, bottomCircleHeight);
        [self addSubview:_bottomCircleImageView];
        
        _letaoQrcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_letaoQrcodeBtn setImage:[UIImage imageNamed:@"home_qrcode"] forState:UIControlStateNormal];
        [_letaoQrcodeBtn addTarget:self action:@selector(letaoQrcodeScanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _letaoQrcodeBtn.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
        [self addSubview:_letaoQrcodeBtn];
        
        
        UITextField *letaoSearchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_letaoQrcodeBtn.frame), _letaoQrcodeBtn.frame.origin.y +7, self.bounds.size.width -CGRectGetMaxX(_letaoQrcodeBtn.frame) - 15, 30)];
        self.letaoSearchTextFiled = letaoSearchTextFiled;
        letaoSearchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[XLTAppPlatformManager shareManager] platformText:@"搜索商品标题 领优惠券拿返现"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xFFC0C2C4],NSFontAttributeName:[UIFont letaoRegularFontWithSize:13]}];
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
        
        
        [self letaoSetupSegmentedControl];
        self.bottomCircleImageView.hidden = ([XLTAppPlatformManager shareManager].isLimitModel);

    }
    return self;
}




- (void)letaoSetupSegmentedControl {
    // 配置`菜单视图`
    CGFloat segmentedControlWidth = self.frame.size.width;
    _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY((self.letaoQrcodeBtn.frame)), segmentedControlWidth -20, kSegmentedControlHeight)];
    _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _letaoSegmentedControl.backgroundColor = [UIColor clearColor];
    _letaoSegmentedControl.useCustomIndicatorBox = YES;
    _letaoSegmentedControl.selectionIndicatorHeight = 0.0;
    _letaoSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15);
    _letaoSegmentedControl.type = HMSegmentedControlTypeText;
    _letaoSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _letaoSegmentedControl.selectionIndicatorBoxColor = [UIColor whiteColor];
    _letaoSegmentedControl.selectionIndicatorBoxOpacity = 1.0;
    _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:14.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    
    [self addSubview:_letaoSegmentedControl];
}

+ (CGFloat)letaoDefaultHeight {
    return kHomeHeadViewDefaultHeight;
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

@end


