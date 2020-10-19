
#import "XLTBasePickView.h"
@class XLTBasePickView;
@protocol  PickerDateViewDelegate<NSObject>
- (void)pickerDateView:(XLTBasePickView *)pickerDateView selectYear:(NSInteger)year selectMonth:(NSInteger)month selectDay:(NSInteger)day;

@end
@interface XLTCustomPickDateView : XLTBasePickView
 
@property(nonatomic, weak)id <PickerDateViewDelegate>delegate ;

@property(nonatomic, assign)BOOL isAddYetSelect;//是否增加至今的选项
@property(nonatomic, assign)BOOL isShowDay;//是否显示日

-(void)setDefaultTSelectYear:(NSInteger)defaultSelectYear defaultSelectMonth:(NSInteger)defaultSelectMonth defaultSelectDay:(NSInteger)defaultSelectDay;

@end
