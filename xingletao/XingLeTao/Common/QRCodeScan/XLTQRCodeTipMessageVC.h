//
//  XLTQRCodeTipMessageVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTQRCodeTipMessageVC;
@protocol XLTQRCodeTipMessageVCDelegaet <NSObject>

- (void)qrCodeTipViewController:(XLTQRCodeTipMessageVC *)viewController dismissWithIndex:(NSInteger)index;

@end

@interface XLTQRCodeTipMessageVC : XLTBaseViewController
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageTextLabel;
@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIView *buttonSeparatorLine;

@property (nonatomic, weak) id<XLTQRCodeTipMessageVCDelegaet> delegate;
@property (nonatomic, copy) NSString *flage;
@property (nonatomic, strong) id parameters;

- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController
                                  title:(NSString * _Nullable)title
                                message:(NSString * _Nullable)message
                         sureButtonText:(NSString * _Nullable)sureButtonText
                       cancelButtonText:(NSString * _Nullable)cancelButtonText;
@end

NS_ASSUME_NONNULL_END
