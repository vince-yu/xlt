//
//  XLTSortView.h
//  XingLeTao
//
//  Created by SNQU on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTBaseModel.h"

typedef enum : NSUInteger {
    XLTSortItemTypeNone = 0,
    XLTSortItemTypeOne,     //只有一种选中状态
    XLTSortItemTypeTwo,     //有二种选中状态
} XLTSortItemType;

typedef enum : NSUInteger {
    XLTSortTypeNomal = 0,
    XLTSortTypeSelected = 1,
    XLTSortTypeSelectedUp = 2,
    XLTSortTypeSelectedDwon = 3,
} XLTSortType;

@interface XLTSortItemModel : XLTBaseModel
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *titleCloler;
@property (nonatomic ,strong) NSString *selectColer;
@property (nonatomic ,strong) NSString *type;
@property (nonatomic ,strong) NSString *code;
@property (nonatomic ,strong) NSString *upImage;
@property (nonatomic ,strong) NSString *downImage;
@property (nonatomic ,strong) NSString *normalImage;
@property (nonatomic ,strong) NSString *selectImage;
@property (nonatomic ,strong) UIFont *normalFont;
@property (nonatomic ,strong) UIFont *selectFont;
@property (nonatomic ,assign) BOOL selected;
@property (nonatomic ,assign) XLTSortType sortType;
@end

@protocol XLTSortViewDelegate <NSObject>

- (void)selectItem:(XLTSortItemModel *)item;

@end

@interface XLTSortView : UIView
@property (nonatomic ,weak) id<XLTSortViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame sorts:(NSArray *)sorts;
@end


