//
//  DYVideoManager.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYVideoManager : NSObject
+ (instancetype)shareManager;
/// 记录可以播放的视频后缀
@property (nonatomic, copy) NSArray *playableSuffixArray;
- (BOOL)isPlayableSuffix: (NSString *)suffix;
@end

NS_ASSUME_NONNULL_END
