//
//  XLTTeacherShareListVC.h
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseListViewController.h"
#import "XLTTeacherShareListModel.h"

@protocol XLTTeacherShareListForMeVCVCDelegate <NSObject>

- (void)loadDataCompelete:(NSNumber *_Nullable)status empty:(BOOL )nodata;

@end
NS_ASSUME_NONNULL_BEGIN

@interface XLTTeacherShareListForMeVC : XLTBaseListViewController
@property (nonatomic ,weak) UINavigationController *letaoNav;
@property (nonatomic ,strong ,nullable) NSNumber *status;
@property (nonatomic ,weak) id<XLTTeacherShareListForMeVCVCDelegate>deletgate;
@property (nonatomic ,assign) XLTTeacherShareCellType type;
@end

NS_ASSUME_NONNULL_END
