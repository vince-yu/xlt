//
//  XLTHomePageTopHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2020/7/1.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "XLTUIConstant.h"
#import "XLTHomePageModel.h"

NS_ASSUME_NONNULL_BEGIN


#define kHeadNavHeight (44 + kSafeAreaInsetsTop)


#define kTopBannerContentHeight [XLTHomeModuleModel homeScaleContentHeight:130.0 sectionCount:0]
#define kTopBannerBottom [XLTHomeModuleModel homeScaleContentHeight:15.0 sectionCount:0]
#define kTopBannerHeight (kTopBannerContentHeight+kTopBannerBottom)
#define kHeadBgHeight (kHeadNavHeight + kTopBannerHeight/2)


@class XLTHomePageTopHeadView;

@protocol XLTHomePageTopHeadViewDelegate <NSObject>
- (void)letaoTopHeadView:(XLTHomePageTopHeadView *)letaoTopHeadView letaoSearchText:(NSString * _Nullable )text;
- (void)letaoTopHeadView:(XLTHomePageTopHeadView *)letaoTopHeadView qrcodeScanAction:(id)sender;
- (void)letaoTopHeadView:(XLTHomePageTopHeadView *)letaoTopHeadView taskButtonAction:(id)sender;

@end

@interface XLTHomePageTopHeadView : UIView
@property (nonatomic, strong) UIButton *letaoQrcodeBtn;
@property (nonatomic, strong) UITextField *letaoSearchTextFiled;
@property (nonatomic, strong) UIButton *letaoTaskBtn;
@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;

@property (nonatomic, weak) id<XLTHomePageTopHeadViewDelegate> delegate;


- (void)scrollBanner:(NSDictionary *)startBanner toBanner:(NSDictionary * _Nullable)endBanner rate:(CGFloat)rate;

- (void)clearAdBg;
@end



@interface XLTHomePageTopHeadView (TransColor)

/**
 16进制颜色转换为UIColor
 
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor;

+ (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor;

+ (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe  andEndColor:(UIColor *)endColor;

@end

NS_ASSUME_NONNULL_END
