//
//  XLTQRCodeTipMessageVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTAlertViewController : XLTBaseViewController

@property (nonatomic, assign) BOOL displayNotShowButton;
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, copy, nullable) void(^letaoalertViewAction)(NSInteger clickIndex,BOOL noneShow);


- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
                                  title:(NSString * _Nullable)title
                                message:(NSString * _Nullable)message
                         sureButtonText:(NSString * _Nullable)sureButtonText
                       cancelButtonText:(NSString * _Nullable)cancelButtonText;

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
           title:(NSString * _Nullable)title
         message:(NSString * _Nullable)message
messageTextAlignment:(NSTextAlignment)messageTextAlignment
  sureButtonText:(NSString * _Nullable)sureButtonText
cancelButtonText:(NSString * _Nullable)cancelButtonText;
#pragma mark Font....
@property (nonatomic ,strong) UIFont *titleFont;
@property (nonatomic ,assign) CGFloat leftAndRightWith;
@end

NS_ASSUME_NONNULL_END
