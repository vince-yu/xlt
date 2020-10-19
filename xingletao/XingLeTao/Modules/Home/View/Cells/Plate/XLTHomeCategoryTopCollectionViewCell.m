//
//  XLTHomeTopCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCategoryTopCollectionViewCell.h"
#import "XLTHomeTopPlateCollectionViewCell.h"
#import "SPButton.h"
#import "UIImageView+WebCache.h"

@interface XLTCategoryTopItemButton: UIButton

@property (nonatomic, strong) NSDictionary *itemInfo;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemLabel;

@end
@implementation XLTCategoryTopItemButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageViewWidth = frame.size.height - 28;
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ceilf((frame.size.width -  imageViewWidth)/2.0), 5, imageViewWidth, imageViewWidth)];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_itemImageView];
        _itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_itemImageView.frame), frame.size.width, 28)];
        _itemLabel.font = [UIFont letaoRegularFontWithSize:11.0];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.textColor = [UIColor colorWithHex:0xFF25282D];
        [self addSubview:_itemLabel];
    }
    return self;
}

- (void)letaoUpdateCellDataWithInfo:(NSDictionary *)info {
    NSString *subjectText = nil;
    NSString *subjectPicUrlString = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        subjectText = [info[@"name"]isKindOfClass:[NSString class]] ? info[@"name"] : nil;
        if (subjectText == nil) {
            subjectText = [info[@"title"]isKindOfClass:[NSString class]] ? info[@"title"] : nil;
        }
        subjectPicUrlString = [info[@"icon"]isKindOfClass:[NSString class]] ? info[@"icon"] : nil;
    }
    [_itemImageView sd_setImageWithURL:[NSURL URLWithString:[subjectPicUrlString letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    _itemLabel.text = subjectText;
    self.itemInfo = info;
}

- (void)letaoUpdateMoreItemWithInfo:(NSDictionary *)info {
    CGFloat imageViewWidth = 35.0;
    CGFloat y = ceilf((self.bounds.size.height - 28 - imageViewWidth)/2.0) +5.0;
    _itemImageView.frame = CGRectMake(ceilf((self.bounds.size.width -  imageViewWidth)/2.0), y, imageViewWidth, imageViewWidth);
    [_itemImageView setImage:[UIImage imageNamed:@"xingletaomore_bt_icon"]];
    _itemLabel.text = @"查看更多";
    self.itemInfo = info;
}
@end

@interface XLTHomeCategoryTopCollectionViewCell ()
@property (nonatomic, strong) NSArray *plateArray;
@property (nonatomic, strong) UIScrollView *contentScrollView;


@end
@implementation XLTHomeCategoryTopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.contentScrollView.pagingEnabled = NO;
    [self.contentView addSubview:self.contentScrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentScrollView.frame = self.bounds;
}

- (void)letaoUpdateCellDataWithInfo:(NSArray *)info {
    for (UIView *itemView in self.contentScrollView.subviews) {
        [itemView removeFromSuperview];
    }
    if ([info isKindOfClass:[NSArray class]]) {
        self.plateArray = info;
        CGFloat superWidth = kScreenWidth;
        [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = [self itemRectAtIndex:idx itemArray:info superWidth:superWidth];
            XLTCategoryTopItemButton *itemBotton = [[XLTCategoryTopItemButton alloc] initWithFrame:rect];
            itemBotton.titleLabel.font = [UIFont letaoRegularFontWithSize:11];
            [itemBotton setTitleColor:[UIColor colorWithHex:0xFF25282D] forState:UIControlStateNormal];
            [itemBotton addTarget:self action:@selector(plateItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (idx == info.count - 1 && [obj isKindOfClass:[NSNull class]]) {
                [itemBotton letaoUpdateMoreItemWithInfo:obj];
            } else {
                [itemBotton letaoUpdateCellDataWithInfo:obj];
            }
            [self.contentScrollView addSubview:itemBotton];
        }];
        CGSize contentSize = CGSizeMake([self pageWidthForItemArray:info superWidth:superWidth], [self pageHeightForItemArray:info superWidth:superWidth]);
        self.contentScrollView.contentSize = contentSize;
    }

    
}

- (void)plateItemBtnClicked:(XLTCategoryTopItemButton *)plateItemButton {
    if (self.delegate && plateItemButton && [self.delegate respondsToSelector:@selector(letaoTopCell:didSelectItemAtIndexPath:)]) {
        NSInteger index = [self.plateArray indexOfObject:plateItemButton.itemInfo];
        if (index != NSNotFound) {
            [self.delegate letaoTopCell:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            // 汇报事件
            NSDictionary *dic = plateItemButton.itemInfo;
            NSMutableDictionary *properties = @{}.mutableCopy;
            properties[@"classify_name"] = [SDRepoManager repoResultValue:dic[@"name"]];
            properties[@"xlt_item_level"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:dic[@"level"]]];
            [SDRepoManager xltrepo_trackEvent:XLT_EVENT_CATEGORY properties:properties];
        }
        
    }
}


- (CGFloat)itemWidthForSuperWidth:(CGFloat)superWidth {
    CGFloat itemWidth = floorf((superWidth)/5);
    return itemWidth;
}

- (CGFloat)itemHeightForSuperWidth:(CGFloat)superWidth {
    return [self itemWidthForSuperWidth:superWidth];
}

- (CGRect)itemRectAtIndex:(NSUInteger)index itemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth {
    NSUInteger pageIndex = [self pageIndexForItemArray:itemArray atItemIndex:index];
    NSUInteger row = [self rowIndexForItemArray:itemArray atItemIndex:index];
    NSUInteger section = [self sectionIndexForItemArray:itemArray atItemIndex:index];
    CGFloat width = [self itemWidthForSuperWidth:superWidth];
    CGFloat height = [self itemHeightForSuperWidth:superWidth];
    return CGRectMake(section *width +(section+1)*
                      0 + pageIndex*superWidth, height*row, width, height);
}

- (CGFloat)pageHeightForItemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth  {
    if ([itemArray isKindOfClass:[NSArray class]]) {
        if (itemArray.count >5) {
            return [self itemHeightForSuperWidth:superWidth]*2;
        } else {
            return [self itemHeightForSuperWidth:superWidth];
        }
    }
    return 0;
}

- (CGFloat)pageWidthForItemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth  {
    return [self pageNumberForItemArray:itemArray] *superWidth;
}

- (NSUInteger)pageNumberForItemArray:(NSArray *)itemArray {
    return 1;
}

- (NSUInteger)pageIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    return 0;
}

- (NSUInteger)rowIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    if (itemIndex  > 4) {
        return 1;
    } else {
        return 0;
    }
}

- (NSUInteger)sectionIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    return itemIndex %5;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
