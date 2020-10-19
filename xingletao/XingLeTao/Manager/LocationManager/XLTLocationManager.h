//
//  XLTLocationManager.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPSessionManager;
@interface XLTLocationManager : NSObject

+ (instancetype) sharedInstance;

- (void)startUpdatingLocation;

- (void)updateAMapCoordinateHeaderForManager:(AFHTTPSessionManager *)sessionManager;
@end

NS_ASSUME_NONNULL_END
