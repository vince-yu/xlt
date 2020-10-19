//
//  XLTGoodsDetailVC+RecommendFeed.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTGoodsDetailVC+RecommendFeed.h"
#import "XLTUserManager.h"
#import "XLTStartRecommedViewController.h"

@implementation XLTGoodsDetailVC (RecommendFeed)

- (void)requestGoodsCanRecommend:(NSString *)goodsId
                      itemSource:(NSString *)itemSource
                      completion:(void(^)(XLTGoodsRecommendFeedStyle recommendFeedStyle,NSString * _Nullable tipText,NSString * _Nullable gId,BOOL showTomrrow))completion {
    BOOL needRequest = NO;
    if ([XLTUserManager shareManager].isLogined) {
        NSNumber *level = [XLTUserManager shareManager].curUserInfo.level;
        if ([level isKindOfClass:[NSNumber class]] || [level isKindOfClass:[NSString class]]) {
            // 是超级会员以上
            if ([level integerValue] >= 2 ) {
                needRequest = YES;
            }
        }
    }
    if (needRequest) {
        [XLTRecommedFeedLogic requestGoodsCanRecommend:goodsId itemSource:itemSource success:^(XLTBaseModel *model,NSURLSessionDataTask * task) {
            NSDictionary *recommendInfo = model.data;
            // "share_type"：1 可推荐2今日推荐上限 3已分享此商品 4没有权限 5没有找到商品 6 商品价格过低 7 自己已分享
            NSNumber *share_type = recommendInfo[@"share_type"];
            NSString *message = [model.message isKindOfClass:[NSString class]] && model.message.length > 0 ? model.message : nil;
            BOOL show = [recommendInfo[@"share_advance"] boolValue];
            if ([share_type isKindOfClass:[NSNumber class]]) {
                NSInteger shareType = [share_type integerValue];
                if (shareType == 1) {
                    completion(XLTGoodsRecommendFeedStyle_Enabled,nil,goodsId,show);
                } else if (shareType == 2) {
                    // 用户推荐的商品已达到15个，则点击“推荐”按钮后，toast提示：每天最多只能推荐15个商品哦~
                    completion(XLTGoodsRecommendFeedStyle_Disabled,@"每天最多只能推荐15个商品哦~",goodsId,show);
                } else if (shareType == 7) {
                    // 已推荐的，图标点亮，点击后做如下toast提示：商品已推荐 请到[发圈]-[我的推荐]中查看管理
                    completion(XLTGoodsRecommendFeedStyle_Recommend,@"商品已推荐 请到[发圈]-[我的推荐]中查看管理",goodsId,show);
                } else if (shareType == 3) {
                    //别人已推荐，自己无法推荐时，图标置灰处理，点击后做如下toast提示：商品已被其他人推荐/请08:00以后再推荐吧
                    completion(XLTGoodsRecommendFeedStyle_Disabled,@"商品已被其他人推荐,请08:00以后再推荐吧",goodsId,show);
                } else {
                    completion(XLTGoodsRecommendFeedStyle_Hidden,message,goodsId,show);
                }
            } else {
                completion(XLTGoodsRecommendFeedStyle_Hidden,message,goodsId,show);
            }
        } failure:^(NSString * _Nonnull errorMsg,NSURLSessionDataTask * task) {
            completion(XLTGoodsRecommendFeedStyle_Hidden,errorMsg,goodsId,NO);
        }];
    } else {
        completion(XLTGoodsRecommendFeedStyle_Hidden,nil,goodsId,NO);
    }
}


- (void)showClearBgLoading {
    self.loadingViewBgColor = [UIColor clearColor];
    [super letaoShowLoading];
}

- (void)startRecommendGoods:(NSDictionary *)goodsInfo
                      style:(XLTGoodsRecommendFeedStyle)recommendFeedStyle
                    goodsId:(NSString *)goodsId
                 itemSource:(NSString *)itemSource
                    tipText:(NSString *)tipText
               stateChanged:(void(^)(XLTGoodsRecommendFeedStyle chanedStyle,NSString * _Nullable tipText))stateChanged {
    if (recommendFeedStyle == XLTGoodsRecommendFeedStyle_Enabled) {
        __weak typeof(self)weakSelf = self;
        [self showClearBgLoading];
        [self requestGoodsCanRecommend:goodsId itemSource:itemSource completion:^(XLTGoodsRecommendFeedStyle style, NSString * _Nullable text,NSString * _Nullable gId,BOOL show) {
            if (style == XLTGoodsRecommendFeedStyle_Enabled) {
                [weakSelf pushRecommedViewController:goodsInfo showTomrrow:show];
            } else {
                [weakSelf showTipMessage:text];
                stateChanged(style,text);
            }
            [weakSelf letaoRemoveLoading];
        }];
    } else  {
        [self showTipMessage:tipText];
    }
}

- (void)pushRecommedViewController:(NSDictionary *)goodsInfo showTomrrow:(BOOL )show{
    if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
        XLTStartRecommedViewController *recommedViewController = [[XLTStartRecommedViewController alloc] init];
        NSMutableDictionary *itemInfo = goodsInfo.mutableCopy;
        itemInfo[@"item_id"] = self.letaoGoodsItemId;
        recommedViewController.goodsInfo = itemInfo;
        recommedViewController.showTomorrow = show;
        [self.navigationController pushViewController:recommedViewController animated:YES];
    }
}


@end
