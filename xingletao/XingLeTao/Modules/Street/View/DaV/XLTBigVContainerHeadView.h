//
//  XLTBigVContainerHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/27.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTBigVContainerHeadView : UIView
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
- (void)updateDaVData:(id _Nullable )itemInfo;
@end

NS_ASSUME_NONNULL_END
