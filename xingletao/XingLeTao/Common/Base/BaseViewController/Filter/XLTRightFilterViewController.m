//
//  XLTRightFilterViewController.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/4.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTRightFilterViewController.h"
#import "XLTRightFilterReusableViewHeader.h"
#import "XLTRightFilterCell.h"
#import "XLTHomePageLogic.h"
#import "XLTRightFilterPriceCell.h"



@implementation XLTRightFilterItem

@end

/* 暂时不用
@interface XLTRightFilterModel : NSObject
@property (nonatomic, strong) NSArray<XLTRightFilterItem *> *groupArray;
@property (nonatomic, copy) NSString *groupName;

@end

@implementation XLTRightFilterModel

@end
*/
@interface XLTRightFilterViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet UIButton *sureButton;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) XLTRightFilterType filterType;

@end

@implementation XLTRightFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 20;
    
    self.resetButton.layer.masksToBounds = YES;
    self.resetButton.layer.cornerRadius = 20;
    self.resetButton.layer.borderColor = [UIColor colorWithHex:0xFFE5E5E5].CGColor;
    self.resetButton.layer.borderWidth = 1.0;
    [self setupDataArray];
    
    [self collectionViewRegisterNibs];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:panRecognizer];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

+ (NSArray *)buildFilterDataArrayWithType:(XLTRightFilterType )type {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *sectionArray0 = [[NSMutableArray alloc] init];
    NSMutableArray *sectionArray1 = [[NSMutableArray alloc] init];
    NSMutableArray *sectionArray2 = [[NSMutableArray alloc] init];
    
    if ((type & XLTRightFilterTypeGoodsSource) == XLTRightFilterTypeGoodsSource) {
        NSArray *supportGoodsPlatformArray = [[XLTAppPlatformManager shareManager] supportGoodsPlatformArrayForSearch];
        if ([supportGoodsPlatformArray isKindOfClass:[NSArray class]]) {
            [supportGoodsPlatformArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XLTRightFilterItem *item  = [self configItemWithPlatformInfo:obj];
                [sectionArray0 addObject:item];
            }];
        }
       }
    if ((type & XLTRightFilterTypePrice) == XLTRightFilterTypePrice) {
        XLTRightFilterItem *item2 =  [self configItemWithType:XLTRightFilterTypePrice];
        [sectionArray1 addObject:item2];
    }
    if ((type & XLTRightFilterTypeFreePost) == XLTRightFilterTypeFreePost) {
        XLTRightFilterItem *item2 =  [self configItemWithType:XLTRightFilterTypeFreePost];
        [sectionArray2 addObject:item2];
    }
    if (sectionArray0) {
        [array addObject:sectionArray0];
    }
    if (sectionArray1) {
        [array addObject:sectionArray1];
    }
    if (sectionArray2) {
        [array addObject:sectionArray2];
    }
    return array;
}

- (void)configDataArrayWithType:(XLTRightFilterType )filterType {
    self.letaoPageDataArray = [XLTRightFilterViewController buildFilterDataArrayWithType:filterType];
}

+ (XLTRightFilterItem *)configItemWithType:(XLTRightFilterType )type{
    XLTRightFilterItem *item = nil;
    switch (type) {
        case XLTRightFilterTypeFreePost:
        {
            XLTRightFilterItem *item4 =  [[XLTRightFilterItem alloc] init];
            item4.itemName = @"包邮";
            item4.itemCode = @"1";
            item = item4;
        }
            break;
        case XLTRightFilterTypePrice:
        {
            XLTRightFilterItem *item4 =  [[XLTRightFilterItem alloc] init];
            item4.itemName = @"价格区间";
            item4.itemCode = @"2";
            item4.minPriceHolder = @"最低价";
            item.maxPriceHolder = @"最高价";
            item = item4;
        }
            break;
        default:
            break;
    }
    return item;
}

+ (XLTRightFilterItem *)configItemWithPlatformInfo:(NSDictionary *)platformInfo {
    if ([platformInfo isKindOfClass:[NSDictionary class]]) {
        NSString *name = platformInfo[@"name"];
        NSString *code = platformInfo[@"code"];
        if (name && code) {
            XLTRightFilterItem *item =  [[XLTRightFilterItem alloc] init];
            item.itemName = name;
            item.itemCode = code;
            return item;
        }
    }
    return nil;
}

- (XLTRightFilterType )defaultSupportFilterType {
    XLTRightFilterType type = XLTRightFilterTypeNone;
    type = type | XLTRightFilterTypeGoodsSource;
    type = type | XLTRightFilterTypePrice;
    type = type | XLTRightFilterTypeFreePost;
    return type;
}

- (void)setupDataArray {
    if (self.letaoPageDataArray == nil) {
        XLTRightFilterType type = [self defaultSupportFilterType];
        [self configDataArrayWithType:type];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    if (!CGRectContainsPoint(self.contentBgView.frame, [gestureRecognizer locationInView:self.view])) {
        [self dismissFilterViewController];
    }
}
- (void)dismissFilterViewController {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.contentBgView.transform = CGAffineTransformMakeTranslation(kScreenWidth -98, 0);
          self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe {
    if (swipe.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [swipe translationInView:self.view];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
            // 设置滑动有效距离
            if (MAX(absX, absY) < 20)
                return;
            if (absX > absY ) {
                if (translation.x > 0) {
                    //向右滑动
                    [self dismissFilterViewController];
                }
            }
    }
}



//header
static NSString *const kXLTRightFilterReusableViewHeader = @"kXLTRightFilterReusableViewHeader";
// CELL
static NSString *const kXLTRightFilterCell = @"kXLTRightFilterCell";
static NSString *const kXLTRightFilterPriceCell = @"XLTRightFilterPriceCell";


- (void)collectionViewRegisterNibs {
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLTRightFilterReusableViewHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTRightFilterReusableViewHeader];
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTRightFilterCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTRightFilterCell];
    [self.collectionView  registerNib:[UINib nibWithNibName:@"XLTRightFilterPriceCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXLTRightFilterPriceCell];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *sectionArray = self.letaoPageDataArray[indexPath.section];
    XLTRightFilterItem *item = sectionArray[indexPath.row];
    if (indexPath.section == 1 && [item.itemCode isEqualToString:@"2"]) {
        XLTRightFilterPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTRightFilterPriceCell forIndexPath:indexPath];
        cell.model = item;
        return cell;
    }else{
        XLTRightFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXLTRightFilterCell forIndexPath:indexPath];
        if ([item.itemName isKindOfClass:[NSString class]]) {
            cell.textLabel.text = item.itemName;
        } else {
            cell.textLabel.text = nil;
        }
        if (item.isSelected) {
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor letaomainColorSkinColor];
        } else {
            cell.textLabel.textColor = [UIColor colorWithHex:0xFF25282D];
            cell.textLabel.backgroundColor = [UIColor colorWithHex:0XFFF6F5F5];
        }
        return cell;
    }
    
    
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.letaoPageDataArray.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionArray =  self.letaoPageDataArray[section];
    return sectionArray.count;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray =  self.letaoPageDataArray[indexPath.section];
    XLTRightFilterItem *item = sectionArray[indexPath.row];
    if (indexPath.section == 1 && [item.itemCode isEqualToString:@"2"]) {
        return CGSizeMake(collectionView.bounds.size.width, 33);
    }
    return CGSizeMake(collectionView.bounds.size.width/2 -30, 33);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (kind == UICollectionElementKindSectionHeader) {
        XLTRightFilterReusableViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLTRightFilterReusableViewHeader forIndexPath:indexPath];
         if (indexPath.section == 0) {
             headerView.textLabel.text = @"筛选";
         } else if (indexPath.section == 2) {
             headerView.textLabel.text = @"物流";
         } else if (indexPath.section == 1){
            headerView.textLabel.text = @"价格区间(元）";
         }
         
        return headerView;
         
     }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    NSArray *sectionArray =  self.letaoPageDataArray[section];
    if (sectionArray.count > 0) {
        return CGSizeMake(collectionView.size.width, 50);
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray =  self.letaoPageDataArray[indexPath.section];
    XLTRightFilterItem *item = sectionArray[indexPath.row];
    item.isSelected = !item.isSelected;
    
    
    XLTRightFilterCell *cell = (XLTRightFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XLTRightFilterCell class]]) {
        if (item.isSelected) {
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor letaomainColorSkinColor];
        } else {
            cell.textLabel.textColor = [UIColor colorWithHex:0xFF25282D];
            cell.textLabel.backgroundColor = [UIColor colorWithHex:0XFFF6F5F5];
        }
    }

}

- (IBAction)resetAction:(id)sender {
    [self.letaoPageDataArray enumerateObjectsUsingBlock:^(NSArray *  _Nonnull sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionArray enumerateObjectsUsingBlock:^(XLTRightFilterItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.isSelected = NO;
            item.minPrice = nil;
            item.maxPrice = nil;
        }];
    }];
    [self.collectionView reloadData];
}

- (IBAction)completeAction:(id)sender {
    if (self.letaoPageDataArray.count > 1) {
        NSArray *setionArray = self.letaoPageDataArray[1];
        XLTRightFilterItem *item = setionArray.firstObject;
        if (item && [item.itemCode isEqualToString:@"2"]) {
            [self handlePriceFilterItem:item];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(letaoFilterVC:didChangeFilterData:)]) {
        [self.delegate letaoFilterVC:self didChangeFilterData:self.letaoPageDataArray];
    }
    [self dismissFilterViewController];
}

/**
*  处理价格区间
*/
- (void)handlePriceFilterItem:(XLTRightFilterItem *)item {
    if ([item.maxPrice length] > 0) {
        NSInteger tempMinPrice = MAX([item.minPrice integerValue], 0);
        NSInteger tempMaxPrice = MAX([item.maxPrice integerValue], 0);
        NSInteger minPrice = MIN(tempMinPrice, tempMaxPrice);
        NSInteger maxPrice = MAX(tempMinPrice, tempMaxPrice);
        if (maxPrice == 0) {
            // 最大值为0，抛弃数据
            item.minPrice = nil;
            item.maxPrice = nil;
        } else {
            item.minPrice = [NSString stringWithFormat:@"%ld",(long)minPrice];
            item.maxPrice = [NSString stringWithFormat:@"%ld",(long)maxPrice];
        }
    } else {
        item.maxPrice = nil;
    }
}
@end
