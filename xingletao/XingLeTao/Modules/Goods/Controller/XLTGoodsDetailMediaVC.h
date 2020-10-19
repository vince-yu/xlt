//
//  XLTGoodsDetailMediaVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/21.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"
#import "UIView+WebVideoCache.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTGoodsDetailMediaVC;
@protocol XLTGoodsDetailMediaVCDelegate <NSObject>

- (void)letaoVideoVCWillBack:(XLTGoodsDetailMediaVC *)videoViewController playerStatus:(JPVideoPlayerStatus)playerStatus;
@end


@interface XLTGoodsDetailMediaVC : XLTBaseViewController
@property (nonatomic, copy) NSString *letaoVideoUrl;

@property (nonatomic, strong) NSArray *letaoVideoArray;
@property (nonatomic, strong) NSArray *letaoImageArray;

@property (nonatomic, weak) id<XLTGoodsDetailMediaVCDelegate> delegate;

@property (nonatomic, assign) NSUInteger letaoFristIndex;
@end

NS_ASSUME_NONNULL_END
