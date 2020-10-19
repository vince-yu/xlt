//
//  XLTMyRecommendVC.h
//  XingLeTao
//
//  Created by SNQU on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyRecommendVC : XLTBaseListViewController
@property (nonatomic, copy, nullable) NSString *letaoChannelId;
@property (nonatomic, copy, nullable) NSString *rootChannelId;
@property (nonatomic, copy, nullable) NSArray *tagArray;
@property (nonatomic, copy, nullable) NSString *currentTag;
@end

NS_ASSUME_NONNULL_END
