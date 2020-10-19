//
//  XLTTeacherShareListCell.h
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTTeacherShareListModel.h"

@protocol XLTTeacherShareListCellDelegate <NSObject>

@optional
- (void)setShowWithModel:(XLTTeacherShareListModel *_Nullable)listModel;
- (void)setTopWithModel:(XLTTeacherShareListModel * _Nullable)listModel;
- (void)moveWithModel:(XLTTeacherShareListModel * _Nullable)listModel isUp:(BOOL )up;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XLTTeacherShareListCell : UITableViewCell
@property (nonatomic ,strong) XLTTeacherShareListModel *model;
@property (nonatomic ,weak) id<XLTTeacherShareListCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
