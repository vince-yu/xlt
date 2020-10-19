//
//  XLTRightCell.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTBaseModel.h"
#import "XLTVipRightsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    XLTRightTypeBuyBili = 0,
    XLTRightTypeShareBili,
    XLTRightTypeCommission,
    XLTRightTypeVipUp,
    XLTRightTypeGetBigCoupon,
    XLTRightTypeGetNew,
    XLTRightTypeFH,
    XLTRightTypeGZ,
} XLTRightType;

@interface XLTRightCellModel : XLTBaseModel
@property (nonatomic ,copy) NSString *bili;
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,assign) NSString *key;
@property (nonatomic ,copy) NSString *level;
@end

@interface XLTRightCell : UICollectionViewCell
@property (nonatomic ,strong) XLTVipRightItemDetail *model;
@end

NS_ASSUME_NONNULL_END
