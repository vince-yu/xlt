//
//  XLTUserIncomListModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/6.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserIncomListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *avatar;
@property (nonatomic ,copy) NSString *nick;
@property (nonatomic ,copy) NSString *income;
@property (nonatomic ,assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
