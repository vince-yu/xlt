//
//  XLTTopFilterView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,XLTTopFilterSortType) {
    XLTSortTypeComprehensive = 0,     //综合
    XLTSortTypePriceAsc = 1,        //价格升序
    XLTSortTypePriceDesc = 2,        //价格降序
    XLTSortTypeSalesAsc = 3,         //销量升序
    XLTSortTypeSalesDesc = 4,       //销量降序
    XLTSortTypeEarnAsc = 5,         //返利升序
    XLTSortTypeEarnDesc = 6,       //返利降序
};

@class XLTTopFilterView,SPButton;
@protocol XLTTopFilterViewDelegate <NSObject>

- (void)letaoFilterView:(XLTTopFilterView *)topFilterView didSelectedSortType:(XLTTopFilterSortType)type;

- (void)letaoFilterView:(XLTTopFilterView *)topFilterView letaoStartFilter:(UIButton *)letaoShowFilterBtn;

@end

@interface XLTTopFilterView : UIView
@property (nonatomic, weak) id<XLTTopFilterViewDelegate> delegate;
@property (nonatomic, assign) BOOL letaoHiddenFilterBtn;
// 默认是NO,sort Price Asc ONLY
@property (nonatomic, assign) BOOL sortPriceAscAndDesc;

// 默认是NO,sort Price Desc ONLY
@property (nonatomic, assign) BOOL sortEarneAscAndDesc;

@property (nonatomic, weak) IBOutlet SPButton *letaoCompreSortButton;
@property (nonatomic, weak) IBOutlet SPButton *letaoPriceSortBtn;
@property (nonatomic, weak) IBOutlet SPButton *letaosalesSortBtn;
@property (nonatomic, weak) IBOutlet SPButton *letaoEarnSortBtn;
@property (nonatomic, weak) IBOutlet SPButton *letaoShowFilterBtn;
@property (nonatomic, assign) XLTTopFilterSortType letaoSortValueType;
- (void)letaoAdjustSortBtnStyle;
@end

NS_ASSUME_NONNULL_END
