//
//  XLTUserTeamInfoModel.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/22.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTUserTeamInfoModel.h"

@implementation XLTUserTeamInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"fansOnetwo":@"fans_all",
            @"fansOne":@"fans_one",
            @"fansTwo":@"fans_other"
    };
}
@end
@implementation XLTUserTeamItemListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"itemId":@"_id",
            @"inviterUsername":@"inviter_username",
            @"fansOnetwo":@"fans_onetwo",
            @"tip":@"copy_helptext"
    };
}

@end
@implementation XLTUserIncomeModel


@end
