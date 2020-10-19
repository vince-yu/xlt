//
//  XLTHomeKingKongCell.m
//  XingLeTao
//
//  Created by chenhg on 2020/5/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTHomeKingKongCell.h"
#import "XLTHomeKingKongItemCell.h"

@interface XLTHomeKingKongCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *kingKongArray;

@property (nonatomic, weak) IBOutlet UIView *customScrollIndicatorBgView;

@property (nonatomic, strong) UIView *customScrollIndicatorView;

@end

@implementation XLTHomeKingKongCell


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadContentTableView];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
    UIView *customScrollIndicatorView = [[UIView alloc] initWithFrame:self.customScrollIndicatorBgView.bounds];
    customScrollIndicatorView.backgroundColor = [UIColor colorWithHex:0xFFFF8000];
    customScrollIndicatorView.layer.masksToBounds = YES;
    customScrollIndicatorView.layer.cornerRadius = 1.0;
    [self.customScrollIndicatorBgView addSubview:customScrollIndicatorView];
    self.customScrollIndicatorView = customScrollIndicatorView;
}


- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return flowLayout;
}

- (void)loadContentTableView {
    UICollectionViewFlowLayout *flowLayout = [self collectionViewLayout];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithHex:0xFFFAFAFA];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self letaoListRegisterCells];
    [self.contentView addSubview:_collectionView];
}

- (void)letaoListRegisterCells {
   [_collectionView registerNib:[UINib nibWithNibName:@"XLTHomeKingKongItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTHomeKingKongItemCell"];

}


#pragma mark -  UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.kingKongArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLTHomeKingKongItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTHomeKingKongItemCell" forIndexPath:indexPath];
    [cell letaoUpdateCellDataWithInfo:self.kingKongArray[indexPath.item]];
    return cell;
}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat space = 12.0;

    NSInteger rowCount = 0;
    if (self.kingKongArray.count <  15) {
        // 2行显示规则
        rowCount = MIN(2, self.kingKongArray.count);
    } else {
        // 三行显示
        rowCount = MIN(3, self.kingKongArray.count);
    }
    CGFloat height = floorf((collectionView.bounds.size.height - (rowCount -1) *space)/rowCount);
    CGFloat width = 60.0;
    return CGSizeMake(width, height);;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
    return  floorf((collectionView.bounds.size.width - 60.0*5)/4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
   return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if ([self.delegate respondsToSelector:@selector(homeKingKongCell:didSelectItem:index:)]) {
        if (indexPath.item < self.kingKongArray.count) {
            NSDictionary *itemInfo = self.kingKongArray[indexPath.item];
            [self.delegate  homeKingKongCell:self didSelectItem:itemInfo index:indexPath.row];
        }
    }
}


- (void)letaoUpdateCellDataWithInfo:(NSArray *)info moduleHeight:(CGFloat)moduleHeight {

    CGFloat bottomIndicatorHeight = 0;
     // 大于15，3行显示，有底部指示器
     // 小于15 2行显示，大于10有底部指示器
    BOOL hasBottomIndicator = (info.count > 15 || (info.count >10 && info.count < 15));
    if (hasBottomIndicator) {
        bottomIndicatorHeight = 26;
        
    } else {
        bottomIndicatorHeight = 15;
    }
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, bottomIndicatorHeight, 10));
    }];
    
    self.kingKongArray = info;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.collectionView.contentSize.width > 0) {
            CGFloat percent = MIN(1, self.collectionView.bounds.size.width /self.collectionView.contentSize.width);
            CGFloat width = percent*self.customScrollIndicatorBgView.bounds.size.width;
            self.customScrollIndicatorView.frame = CGRectMake(self.customScrollIndicatorView.frame.origin.x, self.customScrollIndicatorView.frame.origin.y, width, self.customScrollIndicatorView.frame.size.height);
        }
         self.customScrollIndicatorBgView.hidden = !hasBottomIndicator;
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentSize.width - scrollView.frame.size.width) > 0) {
        CGRect rect =  self.customScrollIndicatorView.frame;
        CGFloat pourcent = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
        if ((self.customScrollIndicatorBgView.frame.size.width - self.customScrollIndicatorView.frame.size.width) > 0)
            rect.origin.x =  (pourcent * (self.customScrollIndicatorBgView.frame.size.width - self.customScrollIndicatorView.frame.size.width));
            self.customScrollIndicatorView.frame = rect;
    }
}
@end
