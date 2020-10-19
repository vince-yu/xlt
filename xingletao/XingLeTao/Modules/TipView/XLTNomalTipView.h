//
//  XLTUserTipMessageView.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol XLTNomalTipViewDelegate <NSObject>

- (void)userTipMessageViewDiDDissMiss;

@end

@interface XLTNomalTipView : UIView
@property (nonatomic ,strong) UIImage *tipImage;
@property (nonatomic ,strong) NSString *sureBtnTile;
@property (nonatomic ,strong) NSString *titleStr;
@property (nonatomic ,strong) NSString *describeStr;
@property (nonatomic ,strong) NSString *waringStr;
@property (nonatomic ,weak) id <XLTNomalTipViewDelegate>delegate;
@property (nonatomic ,copy) void(^sureBlock)(void);

- (void)show;

- (void)dissMiss;

- (instancetype)initWithNib;
+ (void)showTipWithTitle:(NSString *)title describe:(NSString *)des sureTitle:(NSString *)sure sureBlock:(void(^)(void))sureBlock;
@end

