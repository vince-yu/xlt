//
//  XLTUserContibuteModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/6.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserContibuteModel : XLTBaseModel
@property  (nonatomic ,copy) NSString *date;
@property  (nonatomic ,copy) NSString *listId;
@property  (nonatomic ,copy) NSString *total_amount;
@property  (nonatomic ,copy) NSString *username;
@property  (nonatomic ,copy) NSString *avatar;
@property  (nonatomic ,copy) NSString *level;
@property  (nonatomic ,copy) NSString *level_text;
@property  (nonatomic ,copy) NSString *member_id;
@property  (nonatomic ,copy) NSString *fans_all;


@end

NS_ASSUME_NONNULL_END
