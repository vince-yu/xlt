//
//  XLTRightFilterViewController.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface XLTRightFilterItem : NSObject
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemCode;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy, nullable) NSString *minPrice;
@property (nonatomic, copy, nullable) NSString *maxPrice;
@property (nonatomic ,copy) NSString *minPriceHolder;
@property (nonatomic ,copy) NSString *maxPriceHolder;

@end

typedef NS_OPTIONS(NSUInteger, XLTRightFilterType) {
    XLTRightFilterTypeNone                       = 0,
    XLTRightFilterTypeGoodsSource                = 1 << 0,
    XLTRightFilterTypePrice                      = 1 << 1,
    XLTRightFilterTypeFreePost                   = 1 << 2,
};

@class XLTRightFilterViewController;
@protocol XLTRightFilterViewControllerDelegate <NSObject>

- (void)letaoFilterVC:(XLTRightFilterViewController *)filterViewController didChangeFilterData:(NSArray *)letaoFilterArray;

@end



@interface XLTRightFilterViewController : XLTBaseViewController
@property (nonatomic, weak) id<XLTRightFilterViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIView *contentBgView;
@property (nonatomic, strong) NSArray *letaoPageDataArray;
+ (NSArray *)buildFilterDataArrayWithType:(XLTRightFilterType )type;
@end

NS_ASSUME_NONNULL_END
