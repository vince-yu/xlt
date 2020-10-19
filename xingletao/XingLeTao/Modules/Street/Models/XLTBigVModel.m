//
//  XLTBigVHomeModel.m
//  XingLeTao
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBigVModel.h"

@implementation XLTBigVModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"vid":@"_id",
             @"sourceText":@"source_text",
             };
}
@end
