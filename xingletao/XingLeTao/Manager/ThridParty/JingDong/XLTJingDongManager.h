//
//  XLTJingDongManager.h
//  XingKouDai
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<JDKeplerSDK/JDKeplerSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTJingDongManager : NSObject
+ (instancetype)shareManager;

- (void)registerSdk;
- (BOOL)handleOpenURL:(NSURL *)url;


- (void)openKeplerPageWithURL:(NSString *)url sourceController:(UIViewController *)
sourceController;

@end

NS_ASSUME_NONNULL_END
