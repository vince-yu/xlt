//
//  XLTHomeTopCollectionViewCell.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeTopCollectionViewCell.h"
#import "XLTHomeTopPlateCollectionViewCell.h"
#import "SPButton.h"
#import "UIImageView+WebCache.h"

@interface XLTPlateItemButton: UIButton

@property (nonatomic, strong) NSDictionary *itemInfo;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemLabel;

@end
@implementation XLTPlateItemButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 33)];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_itemImageView];
        _itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_itemImageView.frame), frame.size.width, 33)];
        _itemLabel.font = [UIFont letaoRegularFontWithSize:13];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.textColor = [UIColor colorWithHex:0xFF3B3B3B];
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
@end

@interface XLTHomeTopCollectionViewCell ()
@property (nonatomic, strong) NSArray *plateArray;
@property (nonatomic, strong) UIScrollView *contentScrollView;


@end
@implementation XLTHomeTopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.contentScrollView.pagingEnabled = YES;
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
        CGFloat superWidth = kScreenWidth - 20;
        [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = [self itemRectAtIndex:idx itemArray:info superWidth:superWidth];
            XLTPlateItemButton *itemBotton = [[XLTPlateItemButton alloc] initWithFrame:rect];;
            itemBotton.titleLabel.font = [UIFont letaoRegularFontWithSize:13];
            [itemBotton setTitleColor:[UIColor colorWithHex:0xFF3B3B3B] forState:UIControlStateNormal];
            [itemBotton addTarget:self action:@selector(plateItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [itemBotton letaoUpdateCellDataWithInfo:obj];
            [self.contentScrollView addSubview:itemBotton];
        }];
        CGSize contentSize = CGSizeMake([self pageWidthForItemArray:info superWidth:superWidth], [self pageHeightForItemArray:info superWidth:superWidth]);
        self.contentScrollView.contentSize = contentSize;
    }

    
}

- (void)plateItemBtnClicked:(XLTPlateItemButton *)plateItemButton {
    if ([self.delegate respondsToSelector:@selector(letaoCell:didSelectItemAtIndexPath:)]) {
        NSInteger index = [self.plateArray indexOfObject:plateItemButton.itemInfo];
        if (index != NSNotFound) {
            [self.delegate letaoCell:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        }
    }
}


- (CGFloat)itemWidthForSuperWidth:(CGFloat)superWidth {
    CGFloat itemWidth = floorf((superWidth -20 -30)/4);
    return itemWidth;
}

- (CGFloat)itemHeightForSuperWidth:(CGFloat)superWidth {
    return [self itemWidthForSuperWidth:superWidth] + 33;
}

- (CGRect)itemRectAtIndex:(NSUInteger)index itemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth {
    NSUInteger pageIndex = [self pageIndexForItemArray:itemArray atItemIndex:index];
    NSUInteger row = [self rowIndexForItemArray:itemArray atItemIndex:index];
    NSUInteger section = [self sectionIndexForItemArray:itemArray atItemIndex:index];
    CGFloat width = [self itemWidthForSuperWidth:superWidth];
    CGFloat height = [self itemHeightForSuperWidth:superWidth];
    return CGRectMake(section *width +(section+1)*10 + pageIndex*superWidth, height*row+10, width, height);
}

- (CGFloat)pageHeightForItemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth  {
    if ([itemArray isKindOfClass:[NSArray class]]) {
        if (itemArray.count >4) {
            return [self itemHeightForSuperWidth:superWidth] * 2 + 15;
        } else {
            return [self itemHeightForSuperWidth:superWidth] +15;
        }
    }
    return 0;
}

- (CGFloat)pageWidthForItemArray:(NSArray *)itemArray superWidth:(CGFloat)superWidth  {
    return [self pageNumberForItemArray:itemArray] *superWidth;
}

- (NSUInteger)pageNumberForItemArray:(NSArray *)itemArray {
    if ([itemArray isKindOfClass:[NSArray class]]) {
        NSInteger pageNumber = itemArray.count /8;
        if (itemArray.count %8 != 0) {
            pageNumber +=1;
        }
        return pageNumber;
    }
    return 0;
}

- (NSUInteger)pageIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    return itemIndex /8;
}

- (NSUInteger)rowIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    if (itemIndex %8 >= 4) {
        return 1;
    } else {
        return 0;
    }
}

- (NSUInteger)sectionIndexForItemArray:(NSArray *)itemArray atItemIndex:(NSUInteger)itemIndex  {
    return itemIndex %4;
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
