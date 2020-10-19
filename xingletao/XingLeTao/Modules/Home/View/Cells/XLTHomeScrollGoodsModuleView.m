//
//  XLTHomeScrollGoodsModuleView.m
//  XingLeTao
//
//  Created by chenhg on 2020/7/10.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeScrollGoodsModuleView.h"
#import "XLTHomeScrollGoodsItemCell.h"

@interface XLTHomeScrollGoodsModuleView ()  <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UILabel *moduleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *moduleTagLabel;
@property (nonatomic, assign) CGFloat moduleContentHeight;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *goodsArray;

@end



@implementation XLTHomeScrollGoodsModuleView



- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadContentTableView];
    }
    return self;
}


- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return flowLayout;
}

- (void)loadContentTableView {
    UICollectionViewFlowLayout *flowLayout = [self collectionViewLayout];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoListRegisterCells];
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(45, 10, 15, 10));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
    [_collectionView addGestureRecognizer:tap];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)letaoUpdateInfo:(NSDictionary *)info contentHeight:(CGFloat)contentHeight {
    self.moduleContentHeight = contentHeight;
    [self letaoUpdateInfo:info];
}

- (void)letaoUpdateInfo:(NSDictionary *)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *titleInfo = info[@"attribute"];
        [self letaoUpdateTitleInfo:titleInfo];
        
        NSArray *goodsList = info[@"goodsList"];
        [self letaoUpdateGoodsList:goodsList];
    }
}

- (void)letaoUpdateTitleInfo:(NSDictionary *)info {
    self.moduleTitleLabel.text = nil;
    self.moduleTagLabel.hidden = YES;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *title = info[@"title"];
        if ([title isKindOfClass:[NSString class]]) {
            self.moduleTitleLabel.text = title;
            NSString *title_font_color = info[@"title_font_color"];
            if ([title_font_color isKindOfClass:[NSString class]]) {
                UIColor *titleColor =  [UIColor colorWithHexString:[title_font_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                if ([titleColor isKindOfClass:[UIColor class]]) {
                    self.moduleTitleLabel.textColor = titleColor;
                }
            }
        }

        NSString *label = info[@"label"];
        if ([label isKindOfClass:[NSString class]]) {
            self.moduleTagLabel.text = label;
            if ([label isKindOfClass:[NSString class]] && label.length > 0) {
                self.moduleTagLabel.hidden = NO;
                self.moduleTagLabel.text = [NSString stringWithFormat:@"  %@  ",label];
            }
            NSString *label_font_color = info[@"label_font_color"];
            if ([label_font_color isKindOfClass:[NSString class]]) {
                UIColor *tagColor =  [UIColor colorWithHexString:[label_font_color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                if ([tagColor isKindOfClass:[UIColor class]]) {
                    self.moduleTagLabel.textColor = tagColor;
                    [self.moduleTagLabel setNeedsLayout];
                    [self.moduleTagLabel layoutIfNeeded];
                                        
                    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.moduleTagLabel.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight|UIRectCornerTopRight cornerRadii:CGSizeMake(9.5, 9.5)];
                    CAShapeLayer *border = [CAShapeLayer layer];
                    border.strokeColor = tagColor.CGColor;
                    border.fillColor = [UIColor clearColor].CGColor;
                    border.path = path.CGPath;
                    border.frame = self.moduleTagLabel.bounds;
                    border.lineWidth = 0.5;
                    [self.moduleTagLabel.layer addSublayer:border];
                }
            }
        }

    }
}



- (void)letaoListRegisterCells {
   [_collectionView registerNib:[UINib nibWithNibName:@"XLTHomeScrollGoodsItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTHomeScrollGoodsItemCell"];

}


#pragma mark -  UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLTHomeScrollGoodsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTHomeScrollGoodsItemCell" forIndexPath:indexPath];
    [cell letaoUpdateInfo:self.goodsArray[indexPath.item]];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.moduleContentHeight - 60;
    CGFloat width = ceilf(height*(177.0/260.0));
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
//    if ([self.delegate respondsToSelector:@selector(homeKingKongCell:didSelectItem:)]) {
//        if (indexPath.item < self.kingKongArray.count) {
//            NSDictionary *itemInfo = self.kingKongArray[indexPath.item];
//            [self.delegate  homeKingKongCell:self didSelectItem:itemInfo];
//        }
//    }
}


- (void)letaoUpdateGoodsList:(NSArray *)goodsArray {
    if ([goodsArray isKindOfClass:[NSArray class]]) {
        self.goodsArray = goodsArray;
        [self.collectionView reloadData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.goodsArray.count > 3) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat contentSizeW = scrollView.contentSize.width;
        if (offsetX +scrollView.size.width > contentSizeW + 30) {
            if ([self.delegate respondsToSelector:@selector(moduleViewDidScrollToModuleEvent:)]) {
                [self.delegate moduleViewDidScrollToModuleEvent:self];
            }
        }
    }
}



- (void)itemClicked:(UIGestureRecognizer *)tap {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[tap locationInView:self.collectionView]];
    if (indexPath && indexPath.item < self.goodsArray.count) {
        NSDictionary *goodsInfo = self.goodsArray[indexPath.item];
        if ([goodsInfo isKindOfClass:[NSDictionary class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XLTHomeGoodsItemClickedNotification object:goodsInfo];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(moduleViewDidScrollToModuleEvent:)]) {
            [self.delegate moduleViewDidScrollToModuleEvent:self];
        }
    }
}
@end
