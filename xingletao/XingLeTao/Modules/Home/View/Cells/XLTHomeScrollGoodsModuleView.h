//
//  XLTHomeScrollGoodsModuleView.h
//  XingLeTao
//
//  Created by chenhg on 2020/7/10.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTHomePageModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTHomeScrollGoodsModuleView;
@protocol XLTHomeScrollGoodsModuleViewDelegate <NSObject>

- (void)moduleViewDidScrollToModuleEvent:(XLTHomeScrollGoodsModuleView *)moduleView;

@end

@interface XLTHomeScrollGoodsModuleView : UIView

@property (nonatomic, weak) id <XLTHomeScrollGoodsModuleViewDelegate> delegate;

- (void)letaoUpdateInfo:(NSDictionary *)info contentHeight:(CGFloat)contentHeight;

@end

NS_ASSUME_NONNULL_END
