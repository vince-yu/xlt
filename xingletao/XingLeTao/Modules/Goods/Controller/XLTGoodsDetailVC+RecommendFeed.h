//
//  XLTGoodsDetailVC+RecommendFeed.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTGoodsDetailVC.h"
#import "XLTRecommedFeedLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsDetailVC (RecommendFeed)

- (void)requestGoodsCanRecommend:(NSString *)goodsId
                      itemSource:(NSString *)itemSource
                      completion:(void(^)(XLTGoodsRecommendFeedStyle recommendFeedStyle,NSString * _Nullable tipText,NSString * _Nullable gId,BOOL showTomrrow))completion;

- (void)startRecommendGoods:(NSDictionary *)goodsInfo
                      style:(XLTGoodsRecommendFeedStyle)recommendFeedStyle
                    goodsId:(NSString *)goodsId
                 itemSource:(NSString *)itemSource
                    tipText:(NSString *)tipText
               stateChanged:(void(^)(XLTGoodsRecommendFeedStyle chanedStyle,NSString * _Nullable tipText))stateChanged; 
@end

NS_ASSUME_NONNULL_END
