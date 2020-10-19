//
//  DYVideoViewController.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KTVHTTPCache.h>
NS_ASSUME_NONNULL_BEGIN

/// 预加载模型
@interface DYPreLoaderModel : NSObject

/// 加载的URL
@property (nonatomic, copy, readonly) NSString *url;
/// 请求URL的Loader
@property (nonatomic, strong, readonly) KTVHCDataLoader *loader;

- (instancetype)initWithURL: (NSString *)url loader: (KTVHCDataLoader *)loader;

@end

NS_ASSUME_NONNULL_END
