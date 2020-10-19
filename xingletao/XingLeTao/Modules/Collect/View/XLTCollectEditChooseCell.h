//
//  XLTCollectEditChooseCell.h
//  XingLeTao
//
//  Created by vince on 2020/10/12.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLTCollectEditChooseDelegate <NSObject>

- (void)chooseType:(NSInteger )status;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XLTCollectEditChooseCell : UICollectionViewCell
@property (nonatomic ,strong) NSArray *countArray;
@property (nonatomic ,weak) id <XLTCollectEditChooseDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
