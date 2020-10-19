//
//  XLTUpdateInvaterVC.h
//  XingLeTao
//
//  Created by SNQU on 2020/2/25.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol XLTUpdateInvaterDelegate <NSObject>

- (void)reloadSettingVC;

@end

@interface XLTUpdateInvaterVC : XLTBaseViewController
@property (nonatomic ,weak) id<XLTUpdateInvaterDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
