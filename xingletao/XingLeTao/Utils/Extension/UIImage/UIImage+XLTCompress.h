//
//  UIImage+XLTCompress.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/21.
//  Copyright © 2019 snqu. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XLTCompress)
- (NSData *)letaocompressWithMaxLength:(NSUInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
