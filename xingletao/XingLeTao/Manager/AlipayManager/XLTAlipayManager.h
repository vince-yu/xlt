//
//  XLTAlipayManager.h
//  XingLeTao
//
//  Created by vince on 2020/8/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTAlipayManager : NSObject
+ (void)alipayPayWithOrderStr:(NSString *)orderStr;
@end

NS_ASSUME_NONNULL_END
