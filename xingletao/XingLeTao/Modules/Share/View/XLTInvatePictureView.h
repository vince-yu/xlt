//
//  XLTInvatePictureView.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/24.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserInvateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTInvatePictureView : UIView

- (void)generateWithImageUrl:(NSString *)imageUrl qrcodeImage:(UIImage *)qrcodeImage qrcodeCode:(NSString *)qrcodeCode complete:(void(^)(BOOL success, UIImage *  _Nullable image))complete;
@end

NS_ASSUME_NONNULL_END
