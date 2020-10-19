//
//  XLTTopFilterView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTTopFilterView.h"
#import "XLTUIConstant.h"
#import "SPButton.h"
#import "XLTAppPlatformManager.h"

@interface XLTTopFilterView ()

@end

@implementation XLTTopFilterView

- (void)setLetaoHiddenFilterBtn:(BOOL)hiddenFilterButton {
    _letaoHiddenFilterBtn = hiddenFilterButton;
    self.letaoShowFilterBtn.hidden = hiddenFilterButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.letaoShowFilterBtn.hidden = self.letaoHiddenFilterBtn;
    
    self.letaoEarnSortBtn.hidden = NO;
    [self letaoAdjustSortBtnStyle];
}

- (IBAction)letaoStartFilter:(id)sender {
    if ([self.delegate respondsToSelector:@selector(letaoFilterView:letaoStartFilter:)]) {
        [self.delegate letaoFilterView:sender letaoStartFilter:sender];
    }
    UIButton *btn = (UIButton *)sender;
    NSString *xlt_item_title = btn.titleLabel.text;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"xlt_item_title"] = [SDRepoManager repoResultValue: xlt_item_title];
    properties[@"classify_name"] = @"null";
    properties[@"filter_dimension"] = @"null";
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_FILTER properties:properties];
}

- (void)setSortPriceAscAndDesc:(BOOL)sortPriceAscAndDesc {
    if (_sortPriceAscAndDesc != sortPriceAscAndDesc) {
        _sortPriceAscAndDesc = sortPriceAscAndDesc;
        if (!sortPriceAscAndDesc) {
            if (self.letaoSortValueType == XLTSortTypePriceDesc) {
                [self.letaoPriceSortBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self letaoAdjustSortBtnStyle];
    }
}

- (void)setSortEarneAscAndDesc:(BOOL)sortEarneAscAndDesc {
    if (_sortEarneAscAndDesc != sortEarneAscAndDesc) {
        _sortEarneAscAndDesc = sortEarneAscAndDesc;
        if (!sortEarneAscAndDesc) {
            if (self.letaoSortValueType == XLTSortTypeEarnAsc) {
                [self.letaoPriceSortBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self letaoAdjustSortBtnStyle];
    }
}


- (IBAction)letaoSortBtnClickedAction:(id)sender {
    if (sender == self.letaoCompreSortButton) {
        self.letaoSortValueType = XLTSortTypeComprehensive;
    } else if (sender == self.letaoPriceSortBtn) {
        if (self.sortPriceAscAndDesc) {
            if (self.letaoSortValueType == XLTSortTypePriceAsc) {
                self.letaoSortValueType ++;
            } else if (self.letaoSortValueType == XLTSortTypePriceDesc) {
                self.letaoSortValueType --;
            } else {
                self.letaoSortValueType = XLTSortTypePriceAsc;
            }
        } else {
             self.letaoSortValueType = XLTSortTypePriceAsc;
        }
    } else if (sender == self.letaosalesSortBtn) {
//        if (self.letaoSortValueType == XLTSortTypeSalesAsc) {
//            self.letaoSortValueType ++;
//        } else if (self.letaoSortValueType == XLTSortTypeSalesDesc) {
//            self.letaoSortValueType --;
//        } else
        {
            self.letaoSortValueType = XLTSortTypeSalesDesc;
        }
    } else if (sender == self.letaoEarnSortBtn) {
        if (self.sortEarneAscAndDesc) {
            if (self.letaoSortValueType == XLTSortTypeEarnAsc) {
                self.letaoSortValueType ++;
            } else if (self.letaoSortValueType == XLTSortTypeEarnDesc) {
                self.letaoSortValueType --;
            } else {
                self.letaoSortValueType = XLTSortTypeEarnDesc;
            }
        } else {
            self.letaoSortValueType = XLTSortTypeEarnDesc;
        }
    }
    

    [self letaoAdjustSortBtnStyle];
    
    if ([self.delegate respondsToSelector:@selector(letaoFilterView:didSelectedSortType:)]) {
        [self.delegate letaoFilterView:sender didSelectedSortType:self.letaoSortValueType];
    }
    UIButton *btn = (UIButton *)sender;
    NSString *xlt_item_title = btn.titleLabel.text;
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"xlt_item_title"] = [SDRepoManager repoResultValue: xlt_item_title];
    properties[@"classify_name"] = @"null";
    properties[@"filter_dimension"] = @"null";

    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_FILTER properties:properties];
}

- (void)letaoAdjustSortBtnStyle {
    if (self.letaoSortValueType == XLTSortTypeComprehensive) {
        [self.letaoCompreSortButton setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
        [self.letaoPriceSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaosalesSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaoEarnSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (self.sortPriceAscAndDesc) {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_nomal"] forState:UIControlStateNormal];
        } else {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_up_gray"] forState:UIControlStateNormal];
        }

        [self.letaosalesSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down_gray"] forState:UIControlStateNormal];
        if (self.sortEarneAscAndDesc) {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_nomal"] forState:UIControlStateNormal];
        } else {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down_gray"] forState:UIControlStateNormal];
        }

    } else if (self.letaoSortValueType == XLTSortTypePriceAsc || self.letaoSortValueType == XLTSortTypePriceDesc) {
        [self.letaoCompreSortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaoPriceSortBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
        [self.letaosalesSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaoEarnSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (self.letaoSortValueType == XLTSortTypePriceAsc) {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_up"] forState:UIControlStateNormal];

        } else {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down"] forState:UIControlStateNormal];
        }
        [self.letaosalesSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down_gray"] forState:UIControlStateNormal];
        
        if (self.sortEarneAscAndDesc) {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_nomal"] forState:UIControlStateNormal];
        } else {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down_gray"] forState:UIControlStateNormal];
        }
        
    } else if (self.letaoSortValueType == XLTSortTypeSalesAsc || self.letaoSortValueType == XLTSortTypeSalesDesc) {
        [self.letaoCompreSortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaoPriceSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaosalesSortBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
        [self.letaoEarnSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (self.sortPriceAscAndDesc) {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_nomal"] forState:UIControlStateNormal];
        } else {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_up_gray"] forState:UIControlStateNormal];
        }
        if (self.letaoSortValueType == XLTSortTypeSalesAsc) {
            [self.letaosalesSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_up"] forState:UIControlStateNormal];
        } else {
            [self.letaosalesSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down"] forState:UIControlStateNormal];
        }
        if (self.sortEarneAscAndDesc) {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_nomal"] forState:UIControlStateNormal];
        } else {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down_gray"] forState:UIControlStateNormal];
        }

    } else if (self.letaoSortValueType == XLTSortTypeEarnAsc || self.letaoSortValueType == XLTSortTypeEarnDesc) {
        [self.letaoCompreSortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaoPriceSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaosalesSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.letaoEarnSortBtn setTitleColor:[UIColor letaomainColorSkinColor] forState:UIControlStateNormal];
        
        if (self.sortPriceAscAndDesc) {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_nomal"] forState:UIControlStateNormal];
        } else {
            [self.letaoPriceSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_up_gray"] forState:UIControlStateNormal];
        }
        [self.letaosalesSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down_gray"] forState:UIControlStateNormal];
        if (self.letaoSortValueType == XLTSortTypeEarnAsc) {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_up"] forState:UIControlStateNormal];
        } else {
            [self.letaoEarnSortBtn setImage:[UIImage imageNamed:@"xinletao_home_filter_down"] forState:UIControlStateNormal];
        }
    }
}


@end
