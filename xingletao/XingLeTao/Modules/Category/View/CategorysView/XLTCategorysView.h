//
//  XLTCategorysView.h

#import <UIKit/UIKit.h>
#import "XLTCategoryLogic.h"
#import "XLTCategoryLogic.h"
#import "XLTUIConstant.h"

#define kCategorysViewLeftTableWidth kScreen_iPhone375Scale(89)

@interface XLTCategorysView : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic,readonly) NSArray * letaoAllDataArray;


@property(copy,nonatomic,readonly) id letaoCategoryBlock;

/**
 *  是否 记录滑动位置
 */
@property(assign,nonatomic) BOOL letaoIsRecordLastScrollPosition;
/**
 *   记录滑动位置 是否需要 动画
 */
@property(assign,nonatomic) BOOL letaoIsRecordLastScrollAnimated;

@property(assign,nonatomic,readonly) NSInteger letaoSelectIndex;

/**
 *  为了 不修改原来的，因此增加了一个属性，选中指定 行数
 */
@property(assign,nonatomic) NSInteger letaoNeedToScorllerIndex;
/**
 *  颜色属性配置
 */

/**
 *  左边背景颜色
 */
@property(strong,nonatomic) UIColor * letaoLeftBgColor;
/**
 *  左边点中文字颜色
 */
@property(strong,nonatomic) UIColor * letaoLeftSelectColor;
/**
 *  左边点中背景颜色
 */
@property(strong,nonatomic) UIColor * letaoLeftSelectBgColor;

/**
 *  左边未点中文字颜色
 */

@property(strong,nonatomic) UIColor * letaoLeftUnSelectColor;
/**
 *  左边未点中背景颜色
 */
@property(strong,nonatomic) UIColor * letaoLeftUnSelectBgColor;
/**
 *  tablew 的分割线
 */
@property(strong,nonatomic) UIColor * letaoLeftSeparatorColor;

-(instancetype)initWithFrame:(CGRect)frame withCategorysArray:(NSArray*)data withSelectIndex:(void(^)(NSInteger left,NSInteger right,id info))selectIndex;


/**
*  滚动到制定分类
*/
- (void)needPickCategory:(NSString *)categoryId categoryLevel:(NSNumber *)categoryLevel;

@end



