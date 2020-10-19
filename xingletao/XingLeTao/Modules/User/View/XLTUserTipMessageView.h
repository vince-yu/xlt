//
//  XLTUserTipMessageView.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef enum : NSUInteger {
    XLTUserTipTypeWithDraw,
    XLTUserTipTypeBindWeiXin,
    XLTUserTipTypeGetWeiXin,
} XLTUserTipType;

@protocol XLTUserTipMessageViewDelegate <NSObject>

- (void)userTipMessageViewDiDDissMiss;

@end

@interface XLTUserTipMessageView : UIView
@property (nonatomic ,assign) XLTUserTipType type;
@property (nonatomic ,strong) UIImage *tipImage;
@property (nonatomic ,strong) NSString *sureBtnTile;
@property (nonatomic ,strong) NSString *titleStr;
@property (nonatomic ,strong) NSString *describeStr;
@property (nonatomic ,strong) NSString *waringStr;
@property (nonatomic ,weak) id <XLTUserTipMessageViewDelegate>delegate;
@property (nonatomic ,copy) void(^sureBlock)(void);

- (void)show;

- (void)dissMiss;

- (instancetype)initWithNib;

@end

NS_ASSUME_NONNULL_END
