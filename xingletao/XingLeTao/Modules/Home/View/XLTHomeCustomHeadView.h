//
//  XLTHomeCustomHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTHomeCustomHeadView;
@protocol XLTHomeCustomHeadViewDelegate <NSObject>
- (void)letaoTopHeadView:(XLTHomeCustomHeadView *)letaoTopHeadView letaoSearchText:(NSString * _Nullable )text;
- (void)letaoTopHeadView:(XLTHomeCustomHeadView *)letaoTopHeadView qrcodeScanAction:(id)sender;
- (void)letaoTopHeadView:(XLTHomeCustomHeadView *)letaoTopHeadView taskButtonAction:(id)sender;


- (void)letaoTopHeadView:(XLTHomeCustomHeadView *)letaoTopHeadView addClicked:(NSDictionary *)adInfo;

@end

@interface XLTHomeCustomHeadView : UIView
@property (nonatomic, strong) UIButton *letaoQrcodeBtn;
@property (nonatomic, strong) UITextField *letaoSearchTextFiled;
@property (nonatomic, strong) UIButton *letaoTaskBtn;

@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, weak) id<XLTHomeCustomHeadViewDelegate> delegate;

+ (CGFloat)letaoDefaultHeight;
@end



NS_ASSUME_NONNULL_END
