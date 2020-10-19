//
//  XLTShareFeedMediaDownloadVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTShareFeedMediaDownloadVC : XLTBaseViewController
- (void)letaoPresentWithSourceVC:(UIViewController *)sourceViewController downloadMediaWithItemInfo:(id _Nullable )itemInfo complete:(void(^)(NSArray *videoArray, NSArray *imageArray))complete;
@end

NS_ASSUME_NONNULL_END
