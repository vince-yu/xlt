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

@interface XLTPDDManager : NSObject

+ (instancetype)shareManager;

// 打开平多多 优先使用native打开，失败后会调用H5打开
- (void)openPDDPageWithURLString:(NSString *)url
                sourceController:(UIViewController *)sourceController
                           close:(BOOL)thisVC;
@end

NS_ASSUME_NONNULL_END
