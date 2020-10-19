//
//  XLTMemberSortView.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBasePickView.h"

NS_ASSUME_NONNULL_BEGIN
@class XLTBasePickView;
@protocol  XLTMemberSortViewDelegate<NSObject>
- (void)pickerDateView:(XLTBasePickView *)pickerDateView selectIndex:(NSInteger )index;

@end
@interface XLTMemberSortView : XLTBasePickView
@property (nonatomic ,strong) NSArray *letaoPageDataArray;
@property(nonatomic, weak)id <XLTMemberSortViewDelegate>delegate ;

- (instancetype)initWithSortArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
