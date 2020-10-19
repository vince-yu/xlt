//
//  QQWEmptyView.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/24.
//  Copyright © 2019  . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//事件回调
typedef void (^XLTEmotyActionTapBlock)(void);

@interface LetaoEmptyCoverView : UIView

/////////属性传递(可修改)
/* image 的优先级大于 imageStr，只有一个有效*/
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *detailStr;
@property (nonatomic, copy) NSString *btnTitleStr;

/////////属性传递 (只读)
@property (nonatomic,strong,readonly) UIView *contentView;
@property (nonatomic, weak, readonly) id actionBtnTarget;
@property (nonatomic,assign,readonly) SEL actionBtnAction;
@property (nonatomic, copy, readonly) XLTEmotyActionTapBlock btnClickBlock;
@property (nonatomic,strong,readonly) UIView *customView;

/**
 letaoEmptyCoverView内容区域点击事件
 */
@property (nonatomic, copy) XLTEmotyActionTapBlock tapContentViewBlock;


///初始化配置
- (void)prepare;

///重置Subviews
- (void)setupSubviews;


/**
 构造方法 - 创建letaoEmptyCoverView
 
 @param image       占位图片
 @param titleStr    标题
 @param detailStr   详细描述
 @param btnTitleStr 按钮的名称
 @param target      响应的对象
 @param action      按钮点击事件
 @return 返回一个letaoEmptyCoverView
 */
+ (instancetype)emptyActionViewWithImage:(UIImage *)image
                                titleStr:(NSString *)titleStr
                               detailStr:(NSString *)detailStr
                             btnTitleStr:(NSString *)btnTitleStr
                                  target:(id)target
                                  action:(SEL)action;

/**
 构造方法 - 创建letaoEmptyCoverView
 
 @param image          占位图片
 @param titleStr       占位描述
 @param detailStr      详细描述
 @param btnTitleStr    按钮的名称
 @param btnClickBlock  按钮点击事件回调
 @return 返回一个letaoEmptyCoverView
 */
+ (instancetype)emptyActionViewWithImage:(UIImage *)image
                                titleStr:(NSString *)titleStr
                               detailStr:(NSString *)detailStr
                             btnTitleStr:(NSString *)btnTitleStr
                           btnClickBlock:(XLTEmotyActionTapBlock)btnClickBlock;

/**
 构造方法 - 创建letaoEmptyCoverView
 
 @param imageStr    占位图片名称
 @param titleStr    标题
 @param detailStr   详细描述
 @param btnTitleStr 按钮的名称
 @param target      响应的对象
 @param action      按钮点击事件
 @return 返回一个letaoEmptyCoverView
 */
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr
                                   titleStr:(NSString *)titleStr
                                  detailStr:(NSString *)detailStr
                                btnTitleStr:(NSString *)btnTitleStr
                                     target:(id)target
                                     action:(SEL)action;

/**
 构造方法 - 创建letaoEmptyCoverView
 
 @param imageStr       占位图片名称
 @param titleStr       占位描述
 @param detailStr      详细描述
 @param btnTitleStr    按钮的名称
 @param btnClickBlock  按钮点击事件回调
 @return 返回一个letaoEmptyCoverView
 */
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr
                                   titleStr:(NSString *)titleStr
                                  detailStr:(NSString *)detailStr
                                btnTitleStr:(NSString *)btnTitleStr
                              btnClickBlock:(XLTEmotyActionTapBlock)btnClickBlock;

/**
 构造方法 - 创建letaoEmptyCoverView
 
 @param image         占位图片
 @param titleStr      占位描述
 @param detailStr     详细描述
 @return 返回一个没有点击事件的letaoEmptyCoverView
 */
+ (instancetype)letaoEmptyCoverViewWithImage:(UIImage *)image
                          titleStr:(NSString *)titleStr
                         detailStr:(NSString *)detailStr;

/**
 构造方法 - 创建letaoEmptyCoverView
 
 @param imageStr      占位图片名称
 @param titleStr      占位描述
 @param detailStr     详细描述
 @return 返回一个没有点击事件的letaoEmptyCoverView
 */
+ (instancetype)letaoEmptyCoverViewWithImageStr:(NSString *)imageStr
                             titleStr:(NSString *)titleStr
                            detailStr:(NSString *)detailStr;

/**
 构造方法 - 创建一个自定义的letaoEmptyCoverView
 
 @param customView 自定义view
 @return 返回一个自定义内容的letaoEmptyCoverView
 */
+ (instancetype)letaoEmptyCoverViewWithCustomView:(UIView *)customView;



/**
 占位图是否完全覆盖父视图， default=NO
 当设置为YES后，占位图的backgroundColor默认为浅白色，可自行设置
 */
@property (nonatomic, assign) BOOL letaoEmptyCoverViewIsCompleteCoverSuperView;

/**
 内容物上每个子控件之间的间距 default is 20.f
 */
@property (nonatomic, assign) CGFloat  subViewMargin;

/**
 内容物-垂直方向偏移 (此属性与contentViewY 互斥，只有一个会有效)
 */
@property (nonatomic, assign) CGFloat  contentViewOffset;

/**
 内容物-Y坐标 (此属性与contentViewOffset 互斥，只有一个会有效)
 */
@property (nonatomic, assign) CGFloat  contentViewY;

/**
 是否忽略scrollView的contentInset
 */
@property (nonatomic, assign) BOOL ignoreContentInset;


//-------------------------- image --------------------------//
/**
 图片可设置固定大小 (default=图片实际大小)
 */
@property (nonatomic, assign) CGSize   imageSize;


//-------------------------- titleLab 相关 --------------------------//
/**
 标题字体, 大小default is 16.f
 */
@property (nonatomic, strong) UIFont   *titleLabFont;
/**
 标题文字颜色
 */
@property (nonatomic, strong) UIColor  *titleLabTextColor;


//-------------------------- detailLab 相关 --------------------------//
/**
 详细描述字体，大小default is 14.f
 */
@property (nonatomic, strong) UIFont   *detailLabFont;
/**
 详细描述最大行数， default is 2
 */
@property (nonatomic, assign) NSInteger detailLabMaxLines;
/**
 详细描述文字颜色
 */
@property (nonatomic, strong) UIColor  *detailLabTextColor;


//-------------------------- Button 相关 --------------------------//
/**
 按钮字体, 大小default is 14.f
 */
@property (nonatomic, strong) UIFont  *actionBtnFont;
/**
 按钮的高度, default is 40.f
 */
@property (nonatomic, assign) CGFloat  actionBtnHeight;
/**
 水平方向内边距, default is 30.f
 */
@property (nonatomic, assign) CGFloat  actionBtnHorizontalMargin;
/**
 按钮的圆角大小, default is 5.f
 */
@property (nonatomic, assign) CGFloat  actionBtnCornerRadius;
/**
 按钮边框border的宽度, default is 0
 */
@property (nonatomic, assign) CGFloat  actionBtnBorderWidth;
/**
 按钮边框颜色
 */
@property (nonatomic, strong) UIColor  *actionBtnBorderColor;
/**
 按钮文字颜色
 */
@property (nonatomic, strong) UIColor  *actionBtnTitleColor;
/**
 按钮背景颜色
 */
@property (nonatomic, strong) UIColor  *actionBtnBackGroundColor;


@end

NS_ASSUME_NONNULL_END
