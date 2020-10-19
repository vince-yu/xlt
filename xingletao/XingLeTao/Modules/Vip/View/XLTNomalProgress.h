//
//  SDNomalProgress.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/27.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTNomalProgress : UIView

@property(assign ,nonatomic) CGFloat taskProgressValue;

@property(strong,nonatomic)UIView *aView;
@property(strong,nonatomic)UIView *UIProess;
@property(strong,nonatomic)UILabel *progressLabel;
@end

NS_ASSUME_NONNULL_END
