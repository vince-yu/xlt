//
//  XLTInviterModel.h
//  XingLeTao
//
//  Created by SNQU on 2020/2/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTInviterModel : XLTBaseModel
@property (nonatomic ,copy) NSString *invite_link_code;
@property (nonatomic ,copy) NSString *can_set;
@property (nonatomic ,copy) NSString *show_content;
@property (nonatomic ,copy) NSString *level;
@end

NS_ASSUME_NONNULL_END
