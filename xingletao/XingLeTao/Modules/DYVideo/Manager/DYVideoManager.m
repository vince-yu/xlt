//
//  DYVideoManager.m
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYVideoManager.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "SJVideoPlayer.h"

@implementation DYVideoManager
+ (void)initialize {
    [KTVHTTPCache logSetConsoleLogEnable:NO];
    NSError *error = nil;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    }
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
//        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
        return NO;
    }];
    // 设置缓存最大容量 300M
    [KTVHTTPCache cacheSetMaxCacheLength:300 * 1024 * 1024];
}


+ (instancetype)shareManager {
    static DYVideoManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

/// 初始化
- (void)setup {
    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
        commonSettings.bottomIndicator_traceColor = [UIColor letaomainColorSkinColor];
    });
}


- (BOOL)isPlayableSuffix: (NSString *)suffix
{
    if (!suffix || suffix.length == 0)
        return NO;
    suffix = [suffix uppercaseString];
    return [self.playableSuffixArray containsObject:suffix];
}

- (NSArray *)playableSuffixArray
{
    if (!_playableSuffixArray) {
        _playableSuffixArray = @[@"WMV",@"AVI",@"MKV",@"RMVB",@"RM",@"XVID",@"MP4",@"3GP",@"MPG"];
    }
    return _playableSuffixArray;
}
@end
