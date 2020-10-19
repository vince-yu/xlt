

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XLTPickerPopViewTypeSex, // 性别
    XLTPickerPopViewTypeDate, // 出生日期
} XLTPickerPopViewType;

typedef void(^ConfirmBlock)(NSString *chooseValue);

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserPickerPopView : UIView

@property (nonatomic, assign) int selectedSex;
@property (nonatomic, strong) NSDate *selectedDate;
- (void)show;
+ (instancetype)showPopViewWithType:(XLTPickerPopViewType)type confirmBlock:(ConfirmBlock)block;

@end

NS_ASSUME_NONNULL_END
