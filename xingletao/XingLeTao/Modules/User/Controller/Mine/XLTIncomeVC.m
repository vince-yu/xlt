//
//  XLTMyTeamVC.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTIncomeVC.h"
#import "XLTUserManager.h"
#import "XLTNetCommonParametersModel.h"
#import "NSString+XLTMD5.h"

@implementation XLTIncomeVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.jump_URL = [NSString stringWithFormat:@"%@%@",[XLTAppPlatformManager shareManager].baseACH5SeverUrl,@"h5s/ac202010earnings"];
        self.title = @"我的收益";
        self.fullScreen = YES;
        self.isLightBarStyle = YES;
    }
    return self;
}
@end
