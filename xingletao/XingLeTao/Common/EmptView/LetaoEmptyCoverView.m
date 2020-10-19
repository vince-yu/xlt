//
//  QQWEmptyView.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/24.
//  Copyright © 2019  . All rights reserved.
//

#import "LetaoEmptyCoverView.h"


//每个子控件之间的间距
#define kSubViewMargin 20.f

//描述字体
#define kTitleLabFont [UIFont systemFontOfSize:16.f]

//详细描述字体
#define kDetailLabFont [UIFont systemFontOfSize:14.f]

//按钮字体大小
#define kActionBtnFont  [UIFont systemFontOfSize:14.f]
//按钮高度
#define kActionBtnHeight 40.f
//水平方向内边距
#define kActionBtnHorizontalMargin 30.f

//背景色
#define kBackgroundColor [UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1.f]
//黑色
#define kBlackColor [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f]
//灰色
#define kGrayColor [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.f]

@interface LetaoEmptyCoverView () {
    CGFloat contentMaxWidth; //最大宽度
    CGFloat contentWidth;    //内容物宽度
    CGFloat contentHeight;   //内容物高度
    CGFloat subViweMargin;   //间距
}

@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UIButton    *actionButton;
@property (nonatomic, strong) UIView      *customV;

@end

@implementation LetaoEmptyCoverView

#pragma mark - ------------------ Life Cycle ------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
    self.contentViewY = 1000;     //默认值,用来判断是否设置过content的Y值

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *view = self.superview;
    //不是UIView，不做操作
    if (view && [view isKindOfClass:[UIView class]]){
        CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view.frame.size.width, view.frame.size.height);
        self.frame = frame;
    }
    
    [self setupSubviews];
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    //不是UIView，不做操作
    if (newSuperview && ![newSuperview isKindOfClass:[UIView class]]) return;
    
    if (newSuperview) {
        CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSuperview.frame.size.width, newSuperview.frame.size.height);
        self.frame = frame;
    }
}

#pragma mark - ------------------ 实例化 ------------------
+ (instancetype)emptyActionViewWithImage:(UIImage *)image
                                titleStr:(NSString *)titleStr
                               detailStr:(NSString *)detailStr
                             btnTitleStr:(NSString *)btnTitleStr
                                  target:(id)target
                                  action:(SEL)action{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithImage:image imageStr:nil titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:target action:action btnClickBlock:nil];
    
    return letaoEmptyCoverView;
}

+ (instancetype)emptyActionViewWithImage:(UIImage *)image
                                titleStr:(NSString *)titleStr
                               detailStr:(NSString *)detailStr
                             btnTitleStr:(NSString *)btnTitleStr
                           btnClickBlock:(XLTEmotyActionTapBlock)btnClickBlock{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithImage:image imageStr:nil titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:nil action:nil btnClickBlock:btnClickBlock];
    
    return letaoEmptyCoverView;
}

+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr
                                   titleStr:(NSString *)titleStr
                                  detailStr:(NSString *)detailStr
                                btnTitleStr:(NSString *)btnTitleStr
                                     target:(id)target
                                     action:(SEL)action{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithImage:nil imageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:target action:action btnClickBlock:nil];
    
    return letaoEmptyCoverView;
}

+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr
                                   titleStr:(NSString *)titleStr
                                  detailStr:(NSString *)detailStr
                                btnTitleStr:(NSString *)btnTitleStr
                              btnClickBlock:(XLTEmotyActionTapBlock)btnClickBlock{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithImage:nil imageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:nil action:nil btnClickBlock:btnClickBlock];
    
    return letaoEmptyCoverView;
}

+ (instancetype)letaoEmptyCoverViewWithImage:(UIImage *)image
                          titleStr:(NSString *)titleStr
                         detailStr:(NSString *)detailStr{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithImage:image imageStr:nil titleStr:titleStr detailStr:detailStr btnTitleStr:nil target:nil action:nil btnClickBlock:nil];
    
    return letaoEmptyCoverView;
}

+ (instancetype)letaoEmptyCoverViewWithImageStr:(NSString *)imageStr
                             titleStr:(NSString *)titleStr
                            detailStr:(NSString *)detailStr{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithImage:nil imageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:nil target:nil action:nil btnClickBlock:nil];
    
    return letaoEmptyCoverView;
}

+ (instancetype)letaoEmptyCoverViewWithCustomView:(UIView *)customView{
    
    LetaoEmptyCoverView *letaoEmptyCoverView = [[self alloc] init];
    [letaoEmptyCoverView creatEmptyViewWithCustomView:customView];
    
    return letaoEmptyCoverView;
}

- (void)creatEmptyViewWithImage:(UIImage *)image imageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr target:(id)target action:(SEL)action btnClickBlock:(XLTEmotyActionTapBlock)btnClickBlock{
    
    _image = image;
    _imageStr = imageStr;
    _titleStr = titleStr;
    _detailStr = detailStr;
    _btnTitleStr = btnTitleStr;
    _actionBtnTarget = target;
    _actionBtnAction = action;
    _btnClickBlock = btnClickBlock;
    
    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
        [_contentView addGestureRecognizer:tap];
    }
}

- (void)creatEmptyViewWithCustomView:(UIView *)customView{
    
    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }
    
    if (!_customView) {
        [_contentView addSubview:customView];
    }
    _customView = customView;
}

#pragma mark - ------------------ Event Method ------------------
- (void)tapContentView:(UITapGestureRecognizer *)tap{
    if (_tapContentViewBlock) {
        _tapContentViewBlock();
    }
}

#pragma mark - ------------------ Setter ------------------

- (void)setImage:(UIImage *)image{
    _image = image;
    [self setNeedsLayout];
}
- (void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self setNeedsLayout];
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self setNeedsLayout];
}
- (void)setDetailStr:(NSString *)detailStr{
    _detailStr = detailStr;
    [self setNeedsLayout];
}
- (void)setBtnTitleStr:(NSString *)btnTitleStr{
    _btnTitleStr = btnTitleStr;
    [self setNeedsLayout];
}


- (void)setupSubviews{
    contentMaxWidth = self.letaoEmptyCoverViewIsCompleteCoverSuperView ? self.frame.size.width : self.frame.size.width - 30.f;
    contentWidth = 0;//内容物宽度
    contentHeight = 0;//内容物高度
    subViweMargin = self.subViewMargin ? self.subViewMargin : kSubViewMargin;
    
    //占位图片
    UIImage *image = [UIImage imageNamed:self.imageStr];
    if(self.image){
        [self setupPromptImageView:self.image];
    }else if (image) {
        [self setupPromptImageView:image];
    } else{
        if (_promptImageView) {
            [self.promptImageView removeFromSuperview];
            self.promptImageView = nil;
        }
    }
    
    //标题
    if (self.titleStr.length) {
        [self setupTitleLabel:self.titleStr];
    }else{
        if (_titleLabel) {
            [self.titleLabel removeFromSuperview];
            self.titleLabel = nil;
        }
    }
    
    //详细描述
    if (self.detailStr.length) {
        [self setupDetailLabel:self.detailStr];
    }else{
        if (_detailLabel) {
            [self.detailLabel removeFromSuperview];
            self.detailLabel = nil;
        }
    }
    
    //按钮
    if (self.btnTitleStr.length) {
        if (self.actionBtnTarget && self.actionBtnAction) {
            [self setupActionBtn:self.btnTitleStr target:self.actionBtnTarget action:self.actionBtnAction btnClickBlock:nil];
        }else if (self.btnClickBlock) {
            [self setupActionBtn:self.btnTitleStr target:nil action:nil btnClickBlock:self.btnClickBlock];
        }else{
            if (_actionButton) {
                [self.actionButton removeFromSuperview];
                self.actionButton = nil;
            }
        }
    }else{
        if (_actionButton) {
            [self.actionButton removeFromSuperview];
            self.actionButton = nil;
        }
    }
    
    //自定义view
    if (self.customView) {
        contentWidth = self.customView.frame.size.width;
        contentHeight = self.customView.frame.origin.y + self.customView.frame.size.height;
    }
    
    ///设置frame
    [self setSubViewFrame];
}

- (void)setSubViewFrame{
    
    //letaoEmptyCoverView初始宽高
    CGFloat originEmptyWidth = self.frame.size.width;
    CGFloat originEmptyHeight = self.frame.size.height;
    
    CGFloat letaoEmptyCoverViewCenterX = originEmptyWidth * 0.5f;
    CGFloat letaoEmptyCoverViewCenterY = originEmptyHeight * 0.5f;
    
    //不是完全覆盖父视图时，重新设置self的frame（大小为content的大小）
    if (!self.letaoEmptyCoverViewIsCompleteCoverSuperView) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(contentWidth, contentHeight);
        self.frame = frame;
    }
    self.center = CGPointMake(letaoEmptyCoverViewCenterX, letaoEmptyCoverViewCenterY);
    
    //设置contentView
    CGRect frame = self.contentView.frame;
    frame.size = CGSizeMake(contentWidth, contentHeight);
    self.contentView.frame = frame;
    if (self.letaoEmptyCoverViewIsCompleteCoverSuperView) {
        self.contentView.center = CGPointMake(letaoEmptyCoverViewCenterX, letaoEmptyCoverViewCenterY);
    }
    
    //子控件的centerX设置
    CGFloat centerX = self.contentView.frame.size.width * 0.5f;
    if (self.customView) {
        CGPoint center = self.customView.center;
        center.x = centerX;
        self.customView.center = center;
        
    } else {
        CGPoint center = _promptImageView.center;
        center.x = centerX;
        _promptImageView.center = center;
        
        center.y = _titleLabel.center.y;
        _titleLabel.center  = center;
        
        center.y = _detailLabel.center.y;
        _detailLabel.center = center;
        
         center.y = _actionButton.center.y;
        _actionButton.center    = center;
    }
    
    if (self.contentViewOffset) { //有无设置偏移
        CGPoint center = self.center;
        center.y += self.contentViewOffset;
        self.center = center;
        
    } else if (self.contentViewY < 1000) { //有无设置Y坐标值
        CGRect frame = self.frame;
        frame.origin.y = self.contentViewY;
        self.frame = frame;
        
    }
    
    //是否忽略scrollView的contentInset
    if (self.ignoreContentInset && [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        CGPoint center = self.center;
        center.y -= scrollView.contentInset.top;
        center.x -= scrollView.contentInset.left;
        self.center = center;
    }
}

#pragma mark - ------------------ Setup View ------------------
- (void)setupPromptImageView:(UIImage *)img{
    
    self.promptImageView.image = img;
    
    CGFloat imgViewWidth = img.size.width;
    CGFloat imgViewHeight = img.size.height;
    
    if (self.imageSize.width && self.imageSize.height) {//设置了宽高大小
        if (imgViewWidth > imgViewHeight) {//以宽为基准，按比例缩放高度
            imgViewHeight = (imgViewHeight / imgViewWidth) * self.imageSize.width;
            imgViewWidth = self.imageSize.width;
            
        }else{//以高为基准，按比例缩放宽度
            imgViewWidth = (imgViewWidth / imgViewHeight) * self.imageSize.height;
            imgViewHeight = self.imageSize.height;
        }
    }
    self.promptImageView.frame = CGRectMake(0, 0, imgViewWidth, imgViewHeight);
    
    contentWidth = self.promptImageView.frame.size.width;
    contentHeight = self.promptImageView.frame.origin.y + self.promptImageView.frame.size.height;
}

- (void)setupTitleLabel:(NSString *)titleStr{
    
    UIFont *font = self.titleLabFont.pointSize ? self.titleLabFont : kTitleLabFont;
    CGFloat fontSize = font.pointSize;
    UIColor *textColor = self.titleLabTextColor ? self.titleLabTextColor : kBlackColor;
    CGFloat width = [self returnTextWidth:titleStr size:CGSizeMake(contentMaxWidth, fontSize) font:font].width;
    
    self.titleLabel.frame = CGRectMake(0, contentHeight + subViweMargin, width, fontSize);
    self.titleLabel.font = font;
    self.titleLabel.text = titleStr;
    self.titleLabel.textColor = textColor;
    
    contentWidth = width > contentWidth ? width : contentWidth;
    
    contentHeight = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
}

- (void)setupDetailLabel:(NSString *)detailStr{
    
    UIColor *textColor = self.detailLabTextColor ? self.detailLabTextColor : kGrayColor;
    UIFont *font = self.detailLabFont.pointSize ? self.detailLabFont : kDetailLabFont;
    CGFloat fontSize = font.pointSize;
    
    CGFloat maxHeight = self.detailLabMaxLines ? self.detailLabMaxLines * (fontSize + 5) : 2 * (fontSize + 5);//如果没有设置最大行数，默认设置为2行的高度
    
    CGSize size = [self returnTextWidth:detailStr size:CGSizeMake(contentMaxWidth, maxHeight) font:font];//计算得出label大小
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    self.detailLabel.font = font;
    self.detailLabel.frame = CGRectMake(0, contentHeight + subViweMargin, width, height);
    self.detailLabel.text = detailStr;
    self.detailLabel.textColor = textColor;
    
    contentWidth = width > contentWidth ? width : contentWidth;
    
    contentHeight = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height;
}

- (void)setupActionBtn:(NSString *)btnTitle target:(id)target action:(SEL)action btnClickBlock:(XLTEmotyActionTapBlock)btnClickBlock{
    
    UIFont *font = self.actionBtnFont.pointSize ? self.actionBtnFont : kActionBtnFont;
    CGFloat fontSize = font.pointSize;
    UIColor *titleColor = self.actionBtnTitleColor ? self.actionBtnTitleColor : kBlackColor;
    UIColor *backGColor = self.actionBtnBackGroundColor ? self.actionBtnBackGroundColor : [UIColor whiteColor];
    UIColor *borderColor = self.actionBtnBorderColor ? self.actionBtnBorderColor : [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1];
    CGFloat borderWidth = self.actionBtnBorderWidth ? self.actionBtnBorderWidth : 0.0f;
    CGFloat cornerRadius = self.actionBtnCornerRadius ? self.actionBtnCornerRadius : 5.f;
    CGFloat horiMargin = self.actionBtnHorizontalMargin ? self.actionBtnHorizontalMargin : kActionBtnHorizontalMargin;
    CGFloat height = self.actionBtnHeight ? self.actionBtnHeight : kActionBtnHeight;
    CGSize textSize = [self returnTextWidth:btnTitle size:CGSizeMake(contentMaxWidth, fontSize) font:font];//计算得出title文字内容大小
    if (height < textSize.height) {
        height = textSize.height + 4;
    }
    
    //按钮的宽高
    CGFloat btnWidth = textSize.width + horiMargin * 2;
    CGFloat btnHeight = height;
    btnWidth = btnWidth > contentMaxWidth ? contentMaxWidth : btnWidth;
    
    self.actionButton.frame = CGRectMake(0, contentHeight + subViweMargin, btnWidth, btnHeight);
    [self.actionButton setTitle:btnTitle forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = font;
    self.actionButton.backgroundColor = backGColor;
    [self.actionButton setTitleColor:titleColor forState:UIControlStateNormal];
    self.actionButton.layer.borderColor = borderColor.CGColor;
    self.actionButton.layer.borderWidth = borderWidth;
    self.actionButton.layer.cornerRadius = cornerRadius;
    
    //添加事件
    if (target && action) {
        [self.actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.actionButton addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if (btnClickBlock) {
        [self.actionButton addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    contentWidth = btnWidth > contentWidth ? btnWidth : contentWidth;
    
    contentHeight = self.actionButton.frame.origin.y + self.actionButton.frame.size.height;
}
#pragma mark - ------------------ Properties Set ------------------

- (void)setEmptyViewIsCompleteCoverSuperView:(BOOL)letaoEmptyCoverViewIsCompleteCoverSuperView{
    _letaoEmptyCoverViewIsCompleteCoverSuperView = letaoEmptyCoverViewIsCompleteCoverSuperView;
    if (letaoEmptyCoverViewIsCompleteCoverSuperView) {
        if (!self.backgroundColor) {
            self.backgroundColor = kBackgroundColor;
        }
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark 内容物背景视图 相关
- (void)setSubViewMargin:(CGFloat)subViewMargin{
    if (_subViewMargin != subViewMargin) {
        _subViewMargin = subViewMargin;
        
        if (_promptImageView || _titleLabel || _detailLabel || _actionButton || self.customView) {//此判断的意思只是确定self是否已加载完毕
            [self setupSubviews];
        }
    }
}
- (void)setContentViewOffset:(CGFloat)contentViewOffset{
    if (_contentViewOffset != contentViewOffset) {
        _contentViewOffset = contentViewOffset;
        
        if (_promptImageView || _titleLabel || _detailLabel || _actionButton || self.customView) {
            CGPoint center = self.center;
            center.y += self.contentViewOffset;
            self.center = center;
        }
    }
}
- (void)setContentViewY:(CGFloat)contentViewY{
    if (_contentViewY != contentViewY) {
        _contentViewY = contentViewY;
        
        if (_promptImageView || _titleLabel || _detailLabel || _actionButton || self.customView) {
            CGRect frame = self.frame;
            frame.origin.y = self.contentViewY;
            self.frame = frame;
        }
    }
}

#pragma mark 提示图Image 相关
- (void)setImageSize:(CGSize)imageSize{
    if (_imageSize.width != imageSize.width || _imageSize.height != imageSize.height) {
        _imageSize = imageSize;
        
        if (_promptImageView) {
            [self setupSubviews];
        }
    }
}

#pragma mark 描述Label 相关
-(void)setTitleLabFont:(UIFont *)titleLabFont{
    if (_titleLabFont != titleLabFont) {
        _titleLabFont = titleLabFont;
        
        if (_titleLabel) {
            [self setupSubviews];
        }
    }
    
}
- (void)setTitleLabTextColor:(UIColor *)titleLabTextColor{
    if (_titleLabTextColor != titleLabTextColor) {
        _titleLabTextColor = titleLabTextColor;
        
        if (_titleLabel) {
            _titleLabel.textColor = titleLabTextColor;
        }
    }
}

#pragma mark 详细描述Label 相关
- (void)setDetailLabFont:(UIFont *)detailLabFont{
    if (_detailLabFont != detailLabFont) {
        _detailLabFont = detailLabFont;
        
        if (_detailLabel) {
            [self setupSubviews];
        }
    }
}
- (void)setDetailLabMaxLines:(NSInteger)detailLabMaxLines{
    if (_detailLabMaxLines != detailLabMaxLines) {
        _detailLabMaxLines = detailLabMaxLines;
        
        if (_detailLabel) {
            [self setupSubviews];
        }
    }
}
-(void)setDetailLabTextColor:(UIColor *)detailLabTextColor{
    if (_detailLabTextColor != detailLabTextColor) {
        _detailLabTextColor = detailLabTextColor;
        
        if (_detailLabel) {
            _detailLabel.textColor = detailLabTextColor;
        }
    }
}

#pragma mark Button 相关
//////////大小位置相关-需要重新布局
- (void)setActionBtnFont:(UIFont *)actionBtnFont{
    if (_actionBtnFont != actionBtnFont) {
        _actionBtnFont = actionBtnFont;
        
        if (_actionButton) {
            [self setupSubviews];
        }
    }
}
- (void)setActionBtnHeight:(CGFloat)actionBtnHeight{
    if (_actionBtnHeight != actionBtnHeight) {
        _actionBtnHeight = actionBtnHeight;
        
        if (_actionButton) {
            [self setupSubviews];
        }
    }
}
- (void)setActionBtnHorizontalMargin:(CGFloat)actionBtnHorizontalMargin{
    if (_actionBtnHorizontalMargin != actionBtnHorizontalMargin) {
        _actionBtnHorizontalMargin = actionBtnHorizontalMargin;
        
        if (_actionButton) {
            [self setupSubviews];
        }
    }
}
//////////其他相关-直接赋值
- (void)setActionBtnCornerRadius:(CGFloat)actionBtnCornerRadius{
    if (_actionBtnCornerRadius != actionBtnCornerRadius) {
        _actionBtnCornerRadius = actionBtnCornerRadius;
        
        if (_actionButton) {
            _actionButton.layer.cornerRadius = actionBtnCornerRadius;
        }
    }
}
- (void)setActionBtnBorderWidth:(CGFloat)actionBtnBorderWidth{
    if (actionBtnBorderWidth != _actionBtnBorderWidth) {
        _actionBtnBorderWidth = actionBtnBorderWidth;
        
        if (_actionButton) {
            _actionButton.layer.borderWidth = actionBtnBorderWidth;
        }
    }
}
- (void)setActionBtnBorderColor:(UIColor *)actionBtnBorderColor{
    if (_actionBtnBorderColor != actionBtnBorderColor) {
        _actionBtnBorderColor = actionBtnBorderColor;
        
        if (_actionButton) {
            _actionButton.layer.borderColor = actionBtnBorderColor.CGColor;
        }
    }
}
- (void)setActionBtnTitleColor:(UIColor *)actionBtnTitleColor{
    if (_actionBtnTitleColor != actionBtnTitleColor) {
        _actionBtnTitleColor = actionBtnTitleColor;
        
        if (_actionButton) {
            [_actionButton setTitleColor:actionBtnTitleColor forState:UIControlStateNormal];
        }
    }
}
- (void)setActionBtnBackGroundColor:(UIColor *)actionBtnBackGroundColor{
    if (actionBtnBackGroundColor != _actionBtnBackGroundColor) {
        _actionBtnBackGroundColor = actionBtnBackGroundColor;
        
        if (_actionButton) {
            [_actionButton setBackgroundColor:actionBtnBackGroundColor];
        }
    }
}

#pragma mark - ------------------ Event Method ------------------
- (void)actionBtnClick:(UIButton *)sender{
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

#pragma mark - ------------------ Help Method ------------------
- (CGSize)returnTextWidth:(NSString *)text size:(CGSize)size font:(UIFont *)font{
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    return textSize;
}

#pragma mark - ------------------ 懒加载 ------------------
- (UIImageView *)promptImageView{
    if (!_promptImageView) {
        _promptImageView = [[UIImageView alloc] init];
        _promptImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_promptImageView];
    }
    return _promptImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}
- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_actionButton];
    }
    return _actionButton;
}
@end
