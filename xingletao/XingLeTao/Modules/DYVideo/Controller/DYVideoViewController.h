//
//  DYVideoViewController.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYVideoViewController : XLTBaseViewController
// 当前的频道id
@property (nonatomic, copy, nullable) NSString *letaoChannelId;

// 当前的频道已经获得的视频信息
@property (nonatomic, copy, nullable) NSArray *pageVideoArray;

// 当前的频道的Index
@property (nonatomic, assign) NSInteger currentPageIndex;


// 当前的频道的Index
@property (nonatomic, copy, nullable) NSDictionary *startVideoInfo;



// 预加载上几条
@property (nonatomic, assign) NSUInteger preLoadNum;
// 预加载下几条
@property (nonatomic, assign) NSUInteger nextLoadNum;
// 预加载的的百分比，默认100%
@property (nonatomic, assign) double preloadPrecent;
// 预加载的size，默认5M
@property (nonatomic, assign) NSUInteger preloadSize;


@end

NS_ASSUME_NONNULL_END
