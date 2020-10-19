//
//  XLTAddressPickerVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/12/3.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class XLTAddressPickerVC;
@protocol XLTAddressPickerVCDelegate <NSObject>

- (void)addressPickerVC:(XLTAddressPickerVC *)vc
          pickedProvince:(NSDictionary * _Nullable)province
                    city:(NSDictionary * _Nullable)city
                  county:(NSDictionary * _Nullable)county;

@end
@interface XLTAddressPickerVC : XLTBaseViewController
@property (nonatomic, weak) IBOutlet UIView *letaoBgView;
@property (nonatomic, weak) IBOutlet UIView *contentBgView;
@property (nonatomic,weak) id<XLTAddressPickerVCDelegate> delegate;
@property (nonatomic, strong ,nullable) NSDictionary *province;
@property (nonatomic, strong ,nullable) NSDictionary *city;
@property (nonatomic, strong ,nullable) NSDictionary *county;
@end

NS_ASSUME_NONNULL_END
