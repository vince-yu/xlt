//
//  XLTUserHeaderView.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserCentreVC.h"
#import "XLTUserInfoModel.h"
#import "XLTBalanceInfoModel.h"
#import "XLTUserTeamInfoModel.h"


@protocol XLTUserHeaderViewDelegate <NSObject>

- (void)reloadUserHeadView:(CGFloat )height;

@end


@interface XLTUserHeaderView : UIView
@property (nonatomic ,copy) void(^pushSettingBlock)(void);
@property (nonatomic ,copy) void(^pushWithDrawBlock)(void);
@property (nonatomic ,copy) void(^pushWithBalanceBlock)(void);
@property (nonatomic ,copy) void(^adClickBlock)(NSDictionary *dic);
@property (nonatomic ,copy) void(^orderButtonClickBlock)(NSInteger index);
@property (nonatomic ,copy) void(^merberClickBlock)(NSInteger index);
@property (nonatomic ,copy) void(^pushCollectionBlock)(void);
@property (nonatomic ,copy) void(^pushVipOderVCBlock)(void);

@property (nonatomic ,strong) XLTUserInfoModel *userInfo;
@property (nonatomic ,strong) XLTBalanceInfoModel *balanceInfo;
@property (nonatomic ,strong) XLTUserIncomeModel *income;
@property (nonatomic ,strong) id adModel;
@property (nonatomic ,strong) NSArray *configHelpArray;
@property (nonatomic ,assign) CGFloat headerHeight;
@property (nonatomic ,weak) id<XLTUserHeaderViewDelegate>delegate;
- (instancetype)initWithNib;
- (void)reloadView:(BOOL )islogin;
@end

