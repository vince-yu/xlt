//
//  XLTHomeDailyRecommendCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCycleDailyCell.h"
#import "SGAdvertScrollView.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"
#import "SDRepoManager.h"

@interface XLTHomeCycleDailyCell () <SGAdvertScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *letaoGoodsFlagLabel;
@property (nonatomic, weak) IBOutlet UIView *contentBgView;

@property (nonatomic, weak) IBOutlet SGAdvertScrollView *advertScrollView;
@property (nonatomic, strong) NSArray *advertArray;
@end


@implementation XLTHomeCycleDailyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
    
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    self.contentBgView.layer.masksToBounds = YES;
    self.contentBgView.layer.cornerRadius = 10.0;
    
    self.letaoGoodsFlagLabel.layer.masksToBounds = YES;
    self.letaoGoodsFlagLabel.layer.cornerRadius = ceilf(self.letaoGoodsFlagLabel.bounds.size.height/2);
//    self.letaoGoodsFlagLabel.layer.borderColor = self.letaoGoodsFlagLabel.textColor.CGColor;
//    self.letaoGoodsFlagLabel.layer.borderWidth = 1.0;
    
    self.advertScrollView.titleColor = [UIColor colorWithHex:0xFF25282D];
    self.advertScrollView.scrollTimeInterval = 3;
    self.advertScrollView.titles = @[];
    self.advertScrollView.titleFont = [UIFont letaoRegularFontWithSize:11];
    self.advertScrollView.delegate = self;
}

- (void)letaoUpdateCellDataWithInfo:(id _Nullable )info {
    if ([info isKindOfClass:[NSArray class]]) {
        if (self.advertArray != info) {
            self.advertArray = info;
            NSMutableArray *titles = [NSMutableArray array];
            [self.advertArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]] && [obj[@"item_title"] isKindOfClass:[NSString class]]) {
                    [titles addObject:obj[@"item_title"]];
                } else {
                    [titles addObject:@""];
                }
               
            }];
            self.advertScrollView.titles = titles;
        }
    }
}

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(letaoDailyCell:didSelectedItemAtIndex:)]) {
        [self.delegate letaoDailyCell:self didSelectedItemAtIndex:index];
    }
    
    if (index < self.advertArray.count) {
        NSDictionary *goodsInfo = self.advertArray[index];
        if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XLTHomeGoodsItemClickedNotification object:goodsInfo];
            //汇报
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"good_id"] = [SDRepoManager repoResultValue:goodsInfo[@"_id"]];
            dic[@"good_name"] = [SDRepoManager repoResultValue:goodsInfo[@"item_title"]];
            dic[@"xlt_item_source"] = [SDRepoManager repoResultValue:goodsInfo[@"item_source"]];
            dic[@"xlt_item_firstcate_title"] = @"null";
            dic[@"xlt_item_thirdcate_title"] = @"null";
            dic[@"xlt_item_secondcate_title"] = @"null";
            [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_RECOMMEND_DAY properties:dic];
        }
    }
}
@end
