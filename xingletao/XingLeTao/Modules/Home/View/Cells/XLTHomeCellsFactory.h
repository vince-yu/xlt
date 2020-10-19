//
//  XLTHomeCellsFactory.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/2.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSNumber+XLTTenThousandsHelp.h"
#import "XLTHomePageModel.h"




@protocol XLTHomePagesCellUpdateProtocol <NSObject>
@required
- (void)letaoUpdateCellDataWithInfo:(id _Nullable )info;
@end


NS_ASSUME_NONNULL_BEGIN

@interface XLTHomeCellsFactory : NSObject
/**
*  注册cells
*/
- (void)registerCellsForCollectionView:(UICollectionView *)collectionView;


/**
*  返回cells
*/
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                        pageModel:(XLTHomePageModel *)pageModel;


/**
*  返回cells 的Size
*/
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               pageModel:(XLTHomePageModel *)pageModel;
@end

NS_ASSUME_NONNULL_END

