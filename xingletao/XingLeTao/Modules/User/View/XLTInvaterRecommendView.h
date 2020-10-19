//
//  XLTInvaterRecommendView.h
//  XingLeTao
//
//  Created by SNQU on 2020/5/8.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLTInvaterRecommendDelegate <NSObject>

- (void)selectCode:(NSString *)str;

@end

@interface XLTInvaterRecommendView : UIView
@property (nonatomic ,weak) id<XLTInvaterRecommendDelegate>delegate;
- (instancetype)initWithNib;
@end

