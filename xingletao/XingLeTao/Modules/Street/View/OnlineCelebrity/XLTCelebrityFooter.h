//
//  XLTCelebrityFooter.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTCelebrityFooter : UICollectionReusableView
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)itemInfo;
@end

NS_ASSUME_NONNULL_END
