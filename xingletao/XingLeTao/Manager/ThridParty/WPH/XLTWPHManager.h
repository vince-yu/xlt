//
//  XLTPDDManager.h
//  PDDDemo
//
//  Created by chenhg on 2020/1/7.
//  Copyright © 2020 chenhg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XLTWPHManager : NSObject

+ (instancetype)shareManager;

// 打开唯品会 优先使用native打开，失败后会调用H5打开
- (void)openWPHPageWithNativeURLString:(NSString * _Nullable)nativeUrl
                               itemUrl:(NSString * _Nullable)itemUrl
                      sourceController:(UIViewController *)sourceController;
@end

NS_ASSUME_NONNULL_END
