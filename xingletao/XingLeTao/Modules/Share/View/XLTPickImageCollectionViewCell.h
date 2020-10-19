//
//  XLTPickImageCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTPickImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *pickImageView;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UIView *coverView;
@property (nonatomic, weak) IBOutlet UILabel *qrcodeLabel;

@end

NS_ASSUME_NONNULL_END
