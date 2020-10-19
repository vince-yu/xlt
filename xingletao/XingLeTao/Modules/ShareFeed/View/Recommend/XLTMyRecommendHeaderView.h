//
//  XLTMyRecommendHeaderView.h
//  XingLeTao
//
//  Created by SNQU on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTMyRewardListModel.h"
#import "XLTSortView.h"

@protocol XLTMyRecHeaderDelegate <NSObject>

- (void)sortSelect:(XLTSortItemModel *)model;
- (void)ruleClick;
@end


@interface XLTMyRecommendHeaderView : UIView
@property (nonatomic ,strong) XLTMyRewardInfoModel *model;
@property (nonatomic ,weak) id<XLTMyRecHeaderDelegate>delegate;
- (instancetype)initWithNib;
@end


