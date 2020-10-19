//
//  XLTStartRecommedViewController.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTStartRecommedViewController : XLTBaseViewController
@property (nonatomic, copy) NSDictionary *goodsInfo;
@property (nonatomic, strong) NSString *isTomorrow;
@property (nonatomic ,assign) BOOL showTomorrow;
@end


@interface XLTReRecommedViewController : XLTStartRecommedViewController
@property (nonatomic, copy) NSString *recommedText;
@property (nonatomic, copy) NSArray *imageUrlArray;
@property (nonatomic, strong) NSDictionary *passUploadiImageInfo;

@end


NS_ASSUME_NONNULL_END
