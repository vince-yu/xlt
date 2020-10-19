//
//  XLTVipHeaderView.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTVipTaskModel.h"
#import "XLTVipRightsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLTVipHeaderViewDelegate <NSObject>

- (void)scrollVipRight:(NSInteger )level headerHeight:(CGFloat )height;
- (void)upScrollAction;
@end

@interface XLTVipHeaderView : UIView
@property (nonatomic ,weak) id<XLTVipHeaderViewDelegate>delegate;
@property (nonatomic ,assign) CGFloat contentHeight;
@property (nonatomic ,strong) NSArray *taskArray;
@property (nonatomic ,strong) XLTVipTaskModel *model;
@property (nonatomic ,strong) XLTVipRightsModel *rightModel;
- (void)configWithLevel;
- (instancetype)initWithNib;

- (void)setSelectRight:(NSInteger )index;
@end

NS_ASSUME_NONNULL_END
