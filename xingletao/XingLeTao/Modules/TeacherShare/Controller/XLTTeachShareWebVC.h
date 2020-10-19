//
//  XLTTeachShareWebVC.h
//  XingLeTao
//
//  Created by vince on 2020/9/29.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTWKWebViewController.h"
#import "XLTTeacherShareContainerVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTTeachShareWebVC : XLTWKWebViewController
@property (nonatomic ,weak) XLTTeacherShareContainerVC *containerVC;
@end

NS_ASSUME_NONNULL_END
