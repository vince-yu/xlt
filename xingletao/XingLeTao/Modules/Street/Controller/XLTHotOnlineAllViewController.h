//
//  XLTHotOnlineAllViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface XLTHotOnlineAllViewController : XLTBaseViewController
@property (nonatomic, copy) NSString *letaoChannelId;
@property (nonatomic, copy) NSString *letaoParentPlateId;

- (void)letaoEndRefreshState;
@end

NS_ASSUME_NONNULL_END
