//
//  XLTVipTaskModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface XLTVipTaskRulesModel : XLTBaseModel
@property (nonatomic ,copy) NSNumber *has_value;
@property (nonatomic ,copy) NSNumber *max_value;
@property (nonatomic ,copy) NSString *desc;

@end

@interface XLTVipTaskModel : XLTBaseModel
@property (nonatomic ,copy) NSString *taskId;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *task_id;
@property (nonatomic ,strong) NSArray <XLTVipTaskRulesModel*> *event_rules;
@property (nonatomic ,copy) NSString *explain;
@property (nonatomic ,copy) NSString *process_explain;

@end

NS_ASSUME_NONNULL_END
