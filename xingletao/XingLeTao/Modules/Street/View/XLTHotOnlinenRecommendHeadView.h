//
//  XLTHotOnlinenRecommendHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLTHotOnlinenRecommendHeadViewDelegate <NSObject>

- (void)letaoStartFilter;

@end
@interface XLTHotOnlinenRecommendHeadView : UICollectionReusableView
@property (nonatomic, weak) id <XLTHotOnlinenRecommendHeadViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
