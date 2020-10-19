//
//  XLTVipGoodsModel.h
//  XingLeTao
//
//  Created by SNQU on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTVipGoodsModel : XLTBaseModel
@property (nonatomic ,copy) NSString *vipGoodId;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *spec;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSArray *banner;

@end

NS_ASSUME_NONNULL_END
