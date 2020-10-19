//
//  XLTCompleteTaskView.h
//  XingLeTao
//
//  Created by SNQU on 2020/3/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTCompleteTaskView : UIView
@property (nonatomic ,assign) NSTimeInterval showTime;
+ (void)showTaskCompleteTitle:(NSString *)title gold:(NSUInteger )number;
@end

NS_ASSUME_NONNULL_END
