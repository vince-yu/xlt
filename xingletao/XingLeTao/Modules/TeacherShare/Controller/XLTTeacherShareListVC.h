//
//  XLTTeacherShareListVC.h
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseListViewController.h"
#import "XLTTeacherShareListModel.h"
#import "XLTTeacherShareContainerVC.h"

@protocol XLTTeacherShareListVCDelegate <NSObject>

- (void)loadDataCompelete:(NSNumber *_Nullable)status empty:(BOOL )nodata;

@end
NS_ASSUME_NONNULL_BEGIN

@interface XLTTeacherShareListVC : XLTBaseListViewController
@property (nonatomic ,weak) UINavigationController *letaoNav;
@property (nonatomic ,strong ,nullable) NSNumber *status;
@property (nonatomic ,weak) id<XLTTeacherShareListVCDelegate>deletgate;
@property (nonatomic ,assign) XLTTeacherShareCellType type;
@property (nonatomic ,weak) XLTTeacherShareContainerVC *containVC;
@end

NS_ASSUME_NONNULL_END
