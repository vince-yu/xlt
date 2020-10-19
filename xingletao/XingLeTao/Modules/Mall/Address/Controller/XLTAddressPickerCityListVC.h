//
//  XLTAddressPickerCityListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, AddressPickerType) {
    XLTAddressPickerProvinceType = 0,
    XLTAddressPickerCityType,
    XLTAddressPickerCountyType,
};

@class XLTAddressPickerCityListVC;
@protocol XLTAddressPickerCityListVCDelegate <NSObject>

- (void)pickerCityListVC:(XLTAddressPickerCityListVC *)vc
          pickedProvince:(NSDictionary * _Nullable)province
                    city:(NSDictionary * _Nullable)city
                  county:(NSDictionary * _Nullable)county;

@end

@interface XLTAddressPickerCityListVC : XLTBaseViewController
@property (nonatomic,copy) NSString *provinceCode;
@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,copy) NSString *countyCode;
@property (nonatomic,assign) AddressPickerType pickerType;

@property (nonatomic,weak) id<XLTAddressPickerCityListVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
