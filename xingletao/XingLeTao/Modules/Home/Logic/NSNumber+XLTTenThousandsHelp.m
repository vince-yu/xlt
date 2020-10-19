//
//  NSNumber+XLTTenThousandsHelp.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "NSNumber+XLTTenThousandsHelp.h"

@implementation NSNumber (XLTTenThousandsHelp)

- (NSString *)letaoTenThousandNumberFormat {
    NSUInteger number = [self unsignedIntegerValue];
    if (number > 10000) {
        return [NSString stringWithFormat:@"%0.1f万",number / 10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",(long)number];
    }
}
@end
