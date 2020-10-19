//
//  XLTCollectInvalidHeaderView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/14.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLTCollectInvalidHeaderViewDelegate <NSObject>
- (void)letaoInvalidGoodsClearBtnClicked;
@end
@interface XLTCollectInvalidHeaderView : UICollectionReusableView
@property (nonatomic, weak) IBOutlet UILabel *invalidLabel;
@property (nonatomic, weak) id<XLTCollectInvalidHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
