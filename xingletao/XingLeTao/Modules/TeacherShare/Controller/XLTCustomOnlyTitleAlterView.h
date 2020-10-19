//
//  XLTNomalAlterView.h
//  XingLeTao
//
//  Created by SNQU on 2020/5/13.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XLTCustomOnlyTitleAlterView : UIView
@property (nonatomic ,assign) NSTimeInterval showTime;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *contentStr;
@property (nonatomic ,copy) void(^leftBlock)(void);
@property (nonatomic ,copy) void(^rightBlock)(void);
- (instancetype)initWithNib;
- (void)dissMiss;
- (void)show;
+ (void)showNamalAlterWithTitle:(NSString *)title content:(NSString *)content leftBlock:(void(^)(void))leftblock rightBlock:(void(^)(void))rightBlock;

@end

