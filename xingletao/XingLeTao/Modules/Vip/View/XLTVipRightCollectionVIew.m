//
//  XLTVipRightCollectionVIew.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTVipRightCollectionVIew.h"
#import "XLTRightCell.h"

@interface XLTVipRightCollectionVIew ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation XLTVipRightCollectionVIew

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout index:(NSInteger )index{
    self.index = index;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self configSelf];
    }
    return self;
}
- (void)configSelf{
    self.delegate = self;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.scrollEnabled = NO;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    [self registerNib:[UINib nibWithNibName:@"XLTRightCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XLTRightCell"];
}
#pragma mark Collection Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;

}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLTRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTRightCell" forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;

}


//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 60 - 30)/2.0, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
@end
