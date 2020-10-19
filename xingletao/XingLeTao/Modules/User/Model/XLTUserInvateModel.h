//
//  XLTUserInvateModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserInvateModel : XLTBaseModel
@property (nonatomic ,copy) NSString *picId;
@property (nonatomic ,copy) NSString *image;
@property (nonatomic ,copy) NSString *gen_image;

@property (nonatomic ,assign) BOOL seleted;
@end

NS_ASSUME_NONNULL_END
