//
//  XLTSortView.m
//  XingLeTao
//
//  Created by SNQU on 2020/6/17.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTSortView.h"
#import "XLTBaseModel.h"
#import "SPButton.h"





@implementation XLTSortItemModel



@end

@interface XLTSortView ()
@property (nonatomic ,strong) NSArray *sortsArray;
@property (nonatomic ,strong) NSMutableArray *sortsBtnArray;
@property (nonatomic ,strong) XLTSortItemModel *selectItem;
@end

@implementation XLTSortView
- (instancetype)initWithFrame:(CGRect)frame sorts:(NSArray *)sorts
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sortsArray = [NSArray modelArrayWithClass:[XLTSortItemModel class] json:sorts];
        [self initSubViewsWithSorts];
    }
    return self;
}
- (NSMutableArray *)sortsBtnArray{
    if (!_sortsBtnArray) {
        _sortsBtnArray = [[NSMutableArray alloc] init];
    }
    return _sortsBtnArray;
}
- (void)initSubViewsWithSorts{
    if (!self.sortsArray.count) {
        return;
    }
    for (UIButton *btn in self.sortsBtnArray) {
        [btn removeFromSuperview];
    }
    self.sortsBtnArray = nil;
    CGFloat itemWith = self.width / self.sortsArray.count;
    CGFloat itemHeight = self.height;
    for (NSInteger i = 0 ; i < self.sortsArray.count ; i ++) {
        XLTSortItemModel *item = [self.sortsArray objectAtIndex:i];
        SPButton *button = [SPButton buttonWithType:UIButtonTypeCustom];
        button.imagePosition = 1;
        button.imageTitleSpace = 5.0;
        [button setTitle:item.title forState:UIControlStateNormal];
        button.titleLabel.font = item.normalFont;
        [button setImage:[UIImage imageNamed:item.normalImage] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:item.titleCloler] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [self.sortsBtnArray addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * itemWith);
            make.width.mas_equalTo(itemWith);
            make.height.mas_equalTo(itemHeight);
            make.top.mas_equalTo(0);
        }];
        
    }
}
- (void)clickAction:(SPButton *)btn{
    NSInteger index = [self.sortsBtnArray indexOfObject:btn];
    XLTSortItemModel *item = [self.sortsArray objectAtIndex:index];
    
    
    if (item.type.intValue == XLTSortItemTypeNone) {
        if ([item isEqual:self.selectItem]) {
            return;
        }
    }else if (item.type.intValue == XLTSortItemTypeOne){
        if ([item isEqual:self.selectItem]) {
            return;
        }
        [btn setTitleColor:[UIColor colorWithHexString:item.selectColer] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:item.selectImage] forState:UIControlStateNormal];
        btn.titleLabel.font = item.selectFont;
        if (self.selectItem) {
            NSInteger selectIndex = [self.sortsArray indexOfObject:self.selectItem];
            SPButton *selectBtn = [self.sortsBtnArray objectAtIndex:selectIndex];

            [selectBtn setTitleColor:[UIColor colorWithHexString:self.selectItem.titleCloler] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:self.selectItem.normalImage] forState:UIControlStateNormal];
            selectBtn.titleLabel.font = self.selectItem.normalFont;
        }
        self.selectItem = item;
    }else if (item.type.intValue == XLTSortItemTypeTwo){
        if (item.sortType == XLTSortTypeNomal) {
            [btn setTitleColor:[UIColor colorWithHexString:item.selectColer] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:item.downImage] forState:UIControlStateNormal];
            btn.titleLabel.font = item.selectFont;
            item.sortType = XLTSortTypeSelectedDwon;
        }else if (item.sortType == XLTSortTypeSelectedUp){
            [btn setTitleColor:[UIColor colorWithHexString:item.selectColer] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:item.downImage] forState:UIControlStateNormal];
            btn.titleLabel.font = item.selectFont;
            item.sortType = XLTSortTypeSelectedDwon;
        }else if (item.sortType == XLTSortTypeSelectedDwon){
            [btn setTitleColor:[UIColor colorWithHexString:item.selectColer] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:item.upImage] forState:UIControlStateNormal];
            btn.titleLabel.font = item.selectFont;
            item.sortType = XLTSortTypeSelectedUp;
        }
        if (self.selectItem && ![self.selectItem isEqual:item]) {
            NSInteger selectIndex = [self.sortsArray indexOfObject:self.selectItem];
            SPButton *selectBtn = [self.sortsBtnArray objectAtIndex:selectIndex];
            
            [selectBtn setTitleColor:[UIColor colorWithHexString:self.selectItem.titleCloler] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:self.selectItem.normalImage] forState:UIControlStateNormal];
            selectBtn.titleLabel.font = self.selectItem.normalFont;
        }
        self.selectItem = item;
    }
    item.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItem:)]) {
        [self.delegate selectItem:item];
    }
}

@end
