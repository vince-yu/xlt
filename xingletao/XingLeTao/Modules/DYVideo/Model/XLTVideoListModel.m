//
//  XLTVideoListModel.m
//  XingLeTao
//
//  Created by SNQU on 2020/4/27.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTVideoListModel.h"

@implementation XLTVideoCategaryModel



@end

@implementation XLTVideoListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"videoId":@"_id",
             };
}
@end
