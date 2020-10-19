//
//  XLTAddAddressVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTAddAddressVC;
@protocol XLTAddAddressVCDelegate <NSObject>

- (void)addAddressVC:(XLTAddAddressVC *)vc
                name:(NSString *)name
                         phone:(NSString *)phone
                 province_name:(NSString *)province_name
                   province_id:(NSString *)province_id
           city_name:(NSString *)city_name
                     city_code:(NSString *)city_code
                   county_name:(NSString *)county_name
                   county_code:(NSString *)county_code
              sketch:(NSString *)sketch;
@end



@interface XLTAddAddressVC : XLTBaseViewController
@property (nonatomic, weak) id<XLTAddAddressVCDelegate> delegate;
@property (nonatomic, strong) NSDictionary *province;
@property (nonatomic, strong) NSDictionary *city;
@property (nonatomic, strong) NSDictionary *county;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sketch;
@end

NS_ASSUME_NONNULL_END
