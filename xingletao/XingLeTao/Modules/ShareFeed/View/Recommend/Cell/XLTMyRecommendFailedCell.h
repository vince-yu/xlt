//
//  XLTMyRecommendFailedCell.h
//  XingLeTao
//
//  Created by SNQU on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTMyRecommendFailedCell : UITableViewCell
@property (nonatomic ,strong) NSString *contentStr;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic ,strong) NSString *status;
@end

NS_ASSUME_NONNULL_END
