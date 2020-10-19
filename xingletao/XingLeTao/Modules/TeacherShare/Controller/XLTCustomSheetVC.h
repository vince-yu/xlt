//
//  XLTCustomSheetVC.h
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTCustomSheetVC : XLTBaseViewController
@property (nonatomic ,assign) BOOL canEdit;
@property (nonatomic ,strong ,nullable) NSString *titleStr;
@property (nonatomic ,strong ,nullable) NSString *eidtStr;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic ,strong) NSString *sureBtnTitle;
@property (nonatomic ,copy) void(^sureBlock)(void);
@property (nonatomic ,copy) void(^titleBlock)(void);
@property (nonatomic ,copy) void(^editBlock)(void);

@end

NS_ASSUME_NONNULL_END
