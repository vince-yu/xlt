//
//  TZImageUploadOperation.h
//  TZImagePickerController
//
//  Created by 谭真 on 2019/1/14.
//  Copyright © 2019 谭真. All rights reserved.
//

#import "TZImageRequestOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface TZImageUploadOperation : TZImageRequestOperation
@property (nonatomic, assign) BOOL isUploadFailed;
@property (nonatomic, copy, nullable) void(^uploadBlock)(NSDictionary  * _Nullable adInfo,BOOL success);

@end

NS_ASSUME_NONNULL_END
