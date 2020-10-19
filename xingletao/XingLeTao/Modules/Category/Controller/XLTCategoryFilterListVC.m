//
//  XLTCategoryFilterListVC.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/15.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTCategoryFilterListVC.h"
#import "LetaoEmptyCoverView.h"

@interface XLTCategoryFilterListVC ()

@end

@implementation XLTCategoryFilterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)letaoCurrentPlateIdParameter{
    return self.letaoCurrentPlateId;
}

- (NSString *)categoryIdParameter{
    return self.categoryId;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
         if (kind == UICollectionElementKindSectionHeader) {
             UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFilterHeaderViewIdentifier forIndexPath:indexPath];
            if (self.topFilterView == nil) {
                self.topFilterView = [[NSBundle mainBundle]loadNibNamed:@"XLTTopFilterView" owner:self options:nil].lastObject;
             }
             self.topFilterView.delegate = self;
             self.topFilterView.frame = CGRectMake(0, 0, headerView.bounds.size.width, 44.0);
             self.topFilterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
             [headerView addSubview:self.topFilterView];
             return headerView;
         }
     }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1 ) {
        return CGSizeMake(collectionView.bounds.size.width, 44);
    } else {
        return CGSizeZero;
    }
}


- (void)letaoShowEmptyView {
    [super letaoShowEmptyView];
    self.letaoEmptyCoverView.letaoEmptyCoverViewIsCompleteCoverSuperView = NO;
    self.letaoEmptyCoverView.frame = CGRectMake(0, 44, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height - 44);
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
