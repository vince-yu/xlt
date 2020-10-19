//
//  XLTUserWithDrawView.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserWithDrawView : UIView
@property (nonatomic ,copy) void(^submitBlock)(void);
- (void)showWarningStr:(NSString *)str contentStr:(NSString *)contentStr;
- (instancetype)initWithNib;
- (void)resetView;
@end

NS_ASSUME_NONNULL_END
