//
//  XLTTeacherShareListModel.h
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseModel.h"

typedef enum : NSUInteger {
    XLTTeacherShareCellTypeNomal = 0,
    XLTTeacherShareCellTypeMeAll,
    XLTTeacherShareCellTypeMeShow,
} XLTTeacherShareCellType;

typedef enum : NSUInteger {
    XLTTeacherShareIndexTypeNone = 0,
    XLTTeacherShareIndexTypeNomal,
    XLTTeacherShareIndexTypeFirst,
    XLTTeacherShareIndexTypeLast,
} XLTTeacherShareIndexType;

NS_ASSUME_NONNULL_BEGIN

@interface XLTTeacherShareListModel : XLTBaseModel
@property (nonatomic ,copy) NSString *idField;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *logo;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *is_top;
@property (nonatomic ,copy) NSString *view_user_count;
@property (nonatomic ,copy) NSString *view_count;
@property (nonatomic ,copy) NSString *from_share;
@property (nonatomic ,copy) NSString *sort;
@property (nonatomic ,copy) NSString *itime;
@property (nonatomic ,copy) NSString *utime;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic ,assign) XLTTeacherShareCellType type;
@property (nonatomic ,assign) XLTTeacherShareIndexType indexType;
@end

NS_ASSUME_NONNULL_END
