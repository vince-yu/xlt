//
//  XLTHomeTopPlateCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTHomeTopPlateCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *subjectImageView;
@property (nonatomic, weak) IBOutlet UILabel *subjectLabel;
- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
