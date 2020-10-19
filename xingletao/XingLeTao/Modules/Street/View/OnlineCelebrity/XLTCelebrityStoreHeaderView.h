//
//  XLTCelebrityStoreHeaderView.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTCelebrityStoreHeaderView;
@protocol XLTCelebrityStoreHeaderDelegate <NSObject>

- (void)letaoPushToStoreAction:(XLTCelebrityStoreHeaderView *)storeHeaderView;

@end
@interface XLTCelebrityStoreHeaderView : UICollectionReusableView
@property (nonatomic, weak) id<XLTCelebrityStoreHeaderDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)updateCelebrityData:(NSDictionary * )letaoStoreDictionary;
+ (BOOL)letaoStoreisEvaluatesValidForInfo:(NSDictionary * )letaoStoreDictionary;
@end

NS_ASSUME_NONNULL_END
