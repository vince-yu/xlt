//
//  XLTQRCodeScanLogic.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTNetBaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTQRCodeScanLogic : XLTNetBaseLogic

- (NSURLSessionTask *)decodeResultForCodeText:(NSString*)codeText
                        success:(void(^)(XLTBaseModel *model))success
                        failure:(void(^)(NSString *errorMsg))failure;

- (NSURLSessionTask *)decodeResultForCodeText:(NSString*)codeText
                                     is_serch:(BOOL) is_serch
                                      success:(void(^)(XLTBaseModel *model))success
                                      failure:(void(^)(NSString *errorMsg))failure;

@end

NS_ASSUME_NONNULL_END
