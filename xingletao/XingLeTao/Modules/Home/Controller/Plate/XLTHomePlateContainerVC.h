//
//  XLTHomePlateContainerVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLTPlateType) {
    XLTPlateCommonType = 0,
    XLTPlate_99Type,
    XLTPlateHotType,
    XLTPlateCouponType,
};

@interface XLTHomePlateContainerVC : XLTBaseViewController
@property (nonatomic, copy) NSString *letaoCurrentPlateId;
@property (nonatomic, copy) NSString *plateName;
@property (nonatomic, assign) XLTPlateType plateType;
@end

NS_ASSUME_NONNULL_END
