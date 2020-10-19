//
//  XLTQRCodeTipMessageVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTCommonAlertViewController : XLTBaseViewController
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, copy, nullable) void(^letaoalertViewAction)(NSInteger clickIndex);


- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
                                  title:(NSString * _Nullable)title
                                message:(id )message
                       cancelButtonText:(NSString * _Nullable)cancelButtonText
                  sureButtonText:(NSString * _Nullable)sureButtonText;

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
           title:(NSString * _Nullable)title
         message:(NSString * _Nullable)message
messageTextAlignment:(NSTextAlignment)messageTextAlignment
cancelButtonText:(NSString * _Nullable)cancelButtonText
  sureButtonText:(NSString * _Nullable)sureButtonText;
#pragma mark Font....
@property (nonatomic ,strong) UIFont *titleFont;
@property (nonatomic ,assign) CGFloat leftAndRightWith;
@end

NS_ASSUME_NONNULL_END
