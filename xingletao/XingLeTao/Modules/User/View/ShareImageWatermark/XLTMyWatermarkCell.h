//
//  XLTMyWatermarkCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/30.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTMyWatermarkCell;
@protocol XLTMyWatermarkCellDelegate <NSObject>

- (void)watermarkCell:(XLTMyWatermarkCell *)cell didChangeWatermarkText:(NSString *)watermarkText;

- (void)watermarkCell:(XLTMyWatermarkCell *)cell browserImage:(UIImage *)image;

@end


@interface XLTMyWatermarkCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UITextField *watermarkTextField;
@property (nonatomic, weak) IBOutlet UILabel *watermarkLabel;
@property (nonatomic, weak) id<XLTMyWatermarkCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
