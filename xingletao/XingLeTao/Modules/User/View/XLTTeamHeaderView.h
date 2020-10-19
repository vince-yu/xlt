//
//  XLTTeamHeaderView.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTUserTeamInfoModel.h"
#import "SPButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLTTeamHeaderDelegate <NSObject>

- (void)reloadHeader:(CGFloat )height;

@end

@interface XLTTeamHeaderView : UIView
@property (nonatomic ,weak) id<XLTTeamHeaderDelegate>delegate;
@property (nonatomic ,copy) void(^sortBlock)(NSInteger index,NSInteger status);
@property (nonatomic ,copy) void(^searchBlock)(NSString *str);
@property (nonatomic ,strong) XLTUserTeamInfoModel *model;
@property (weak, nonatomic) IBOutlet SPButton *sortBtn;

- (instancetype)initWithNib;
@end

NS_ASSUME_NONNULL_END
