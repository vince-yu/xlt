//
//  DYVideoViewController.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "DYPreLoaderModel.h"

@implementation DYPreLoaderModel

- (instancetype)initWithURL: (NSString *)url loader: (KTVHCDataLoader *)loader
{
    if (self = [super init])
    {
        _url = url;
        _loader = loader;
    }
    return self;
}


@end
