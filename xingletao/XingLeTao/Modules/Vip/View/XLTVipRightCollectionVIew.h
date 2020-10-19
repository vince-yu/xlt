//
//  XLTVipRightCollectionVIew.h
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTVipRightCollectionVIew : UICollectionView
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,assign) NSInteger index;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout index:(NSInteger )index;
@end

NS_ASSUME_NONNULL_END
