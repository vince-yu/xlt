//
//  XLDSchoolVC.h
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLDSchoolVC : XLTBaseCollectionViewController
@property (nonatomic, copy) NSString *letaoChannelId;
@property (nonatomic, copy) NSString *letaoChannelCode;
@property (nonatomic,strong) NSArray *channelInfoArray;

@end



NS_ASSUME_NONNULL_END
