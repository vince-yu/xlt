//
//  XLTCategoryListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTCategoryListVC : XLTBaseViewController
- (void)needPickCategory:(NSString *)categoryId categoryLevel:(NSNumber *)categoryLevel;


@end


@interface XLTCategoryPushListVC : XLTCategoryListVC

@end

NS_ASSUME_NONNULL_END
