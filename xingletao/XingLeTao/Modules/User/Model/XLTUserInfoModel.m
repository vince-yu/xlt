//
//  XLTUserInfoModel.m
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019 . All rights reserved.
//

#import "XLTUserInfoModel.h"

@implementation XLTUserInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"is_new_user":@"new_user",
             @"userNameInfo":@"username",
             @"xlt_new_code":@"new_code",
             };
}

- (void)setHas_bind_tb:(NSNumber *)has_bind_tb {
    _has_bind_tb = has_bind_tb;
}
//- (NSNumber *)level{
////    return [NSNumber numberWithInt:arc4random() % 4 + 1];
//    return @4;
//}
@end


@implementation XLTLoginVerificationCodeModel

@end

@implementation XLTUserInfoConfigModel



@end
