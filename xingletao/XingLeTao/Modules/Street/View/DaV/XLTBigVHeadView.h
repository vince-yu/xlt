//
//  XLTBigVHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/26.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTBigVHeadView;
@protocol XLTBigVHeadViewDelegate <NSObject>

- (void)letaoBigVTopHeadViewClicked:(XLTBigVHeadView *)headView;

@end

@interface XLTBigVHeadView : UICollectionReusableView
@property (nonatomic, weak) id<XLTBigVHeadViewDelegate> delegate;

- (void)updateDaVData:(id _Nullable )itemInfo;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
