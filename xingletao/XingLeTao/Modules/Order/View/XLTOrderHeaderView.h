//
//  XLTOrderHeaderView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/19.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderHeaderView : UICollectionReusableView
@property (nonatomic, weak) IBOutlet UILabel *letaoDateLabel;
@property (nonatomic ,copy) void(^otherBlock)(void);
@end

NS_ASSUME_NONNULL_END
