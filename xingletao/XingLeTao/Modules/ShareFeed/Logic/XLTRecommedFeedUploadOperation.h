//
//  XLTRecommedFeedUploadOperation.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "TZImageRequestOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTRecommedFeedUploadOperation : TZImageRequestOperation
@property (nonatomic, assign) BOOL isUploadFailed;
@property (nonatomic, copy, nullable) void(^uploadBlock)(NSDictionary  * _Nullable adInfo,BOOL success);
@end

NS_ASSUME_NONNULL_END
