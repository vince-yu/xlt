//
//  XLTSchoolSearchReusableView.h
//  XingLeTao
//
//  Created by chenhg on 2020/2/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLTSchoolSearchReusableViewDelegate <NSObject>

- (void)letaoStartSearchWithText:(NSString *)letaoSearchText;

@end

@interface XLTSchoolSearchReusableView : UICollectionReusableView
@property (nonatomic, weak) id<XLTSchoolSearchReusableViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
