//
//  XLTMyMembersUpGradeTitleCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/25.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLTMyMembersUpGradeTitleCellDelegate <NSObject>

- (void)myMembersUpGradeCloseAction;

@end

@interface XLTMyMembersUpGradeTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *upGradeTitleLabel;
@property (weak, nonatomic) id<XLTMyMembersUpGradeTitleCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
