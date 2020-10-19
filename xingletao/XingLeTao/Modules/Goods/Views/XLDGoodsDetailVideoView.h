//
//  XLDGoodsDetailVideoView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/9.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+WebVideoCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLDGoodsDetailVideoView : UIView
@property (nonatomic, strong) UIButton *letaoVideoPlayBtn;
@property (nonatomic, strong) UIButton *letaoVideoBtn;
@property (nonatomic, strong) UIButton *letaoPicBtn;
@property (nonatomic, assign) JPVideoPlayerStatus letaoCurrentVideoPlayerStatus;
@end

NS_ASSUME_NONNULL_END
