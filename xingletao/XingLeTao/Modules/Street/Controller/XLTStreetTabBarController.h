//
//  XLTStreetTabBarController.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/23.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 红人街
#define kPlateRedCode @"500000"

@interface XLTStreetTabBarController : UITabBarController
@property (nonatomic, copy) NSString *letaoCurrentPlateId;
@end

NS_ASSUME_NONNULL_END
