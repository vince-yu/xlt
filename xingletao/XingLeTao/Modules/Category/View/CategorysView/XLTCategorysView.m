
#import "XLTCategorysView.h"
#import "XLDCategorysLeftTableViewCell.h"
#import "XLDCategorysRightTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLTUIConstant.h"
#import "MJRefreshNormalHeader.h"
#import "XLDCategorysRightFooterView.h"

#define kXLDCategorysRightTableViewCell @"XLDCategorysRightTableViewCell"
#define kXLDCategorysRightHeaderView   @"XLDCategorysRightHeaderView"
#define kXLDCategorysRightFooterView   @"XLDCategorysRightFooterView"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface XLTCategorysView()

@property(strong,nonatomic ) UITableView * letaoLeftTableView;
@property(strong,nonatomic ) UICollectionView * letaoRightCollectionView;

@property(assign,nonatomic) BOOL letaoIsReturnLastOffset;

@end
@implementation XLTCategorysView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withCategorysArray:(NSArray *)data withSelectIndex:(void (^)(NSInteger, NSInteger, id))selectIndex
{
    self=[super initWithFrame:frame];
    if (self) {
        if (data.count==0) {
            return nil;
        }
        
        _letaoCategoryBlock=selectIndex;
        self.letaoLeftSelectColor=[UIColor blackColor];
        self.letaoLeftSelectBgColor=[UIColor whiteColor];
        self.letaoLeftBgColor=UIColorFromRGB(0xF3F4F6);
        self.letaoLeftSeparatorColor=UIColorFromRGB(0xE5E5E5);
        self.letaoLeftUnSelectBgColor=UIColorFromRGB(0xF3F4F6);
        self.letaoLeftUnSelectColor=[UIColor blackColor];
        
        _letaoSelectIndex=0;
        _letaoAllDataArray=data;
        
        
        /**
         左边的视图
        */
        self.letaoLeftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCategorysViewLeftTableWidth, frame.size.height)];
        self.letaoLeftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.letaoLeftTableView.dataSource=self;
        self.letaoLeftTableView.delegate=self;
        [self.letaoLeftTableView registerNib:[UINib nibWithNibName:@"XLDCategorysLeftTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLDCategorysLeftTableViewCell"];
        
        self.letaoLeftTableView.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.letaoLeftTableView];
        self.letaoLeftTableView.backgroundColor=self.letaoLeftBgColor;
        if ([self.letaoLeftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            self.letaoLeftTableView.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.letaoLeftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            self.letaoLeftTableView.separatorInset=UIEdgeInsetsZero;
        }
        self.letaoLeftTableView.separatorColor=self.letaoLeftSeparatorColor;
        
        /**
         右边的视图
         */
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        float leftMargin =0;
        self.letaoRightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCategorysViewLeftTableWidth+leftMargin,0,kScreenWidth-kCategorysViewLeftTableWidth-leftMargin*2,frame.size.height) collectionViewLayout:flowLayout];
        self.letaoRightCollectionView.alwaysBounceVertical = YES;
        self.letaoRightCollectionView.delegate=self;
        self.letaoRightCollectionView.dataSource=self;
        self.letaoRightCollectionView.contentInset = UIEdgeInsetsMake(28, 0, 0, 0);
        UINib *nib=[UINib nibWithNibName:kXLDCategorysRightTableViewCell bundle:nil];
        
        [self.letaoRightCollectionView registerNib: nib forCellWithReuseIdentifier:kXLDCategorysRightTableViewCell];
        
        
        UINib *header=[UINib nibWithNibName:kXLDCategorysRightHeaderView bundle:nil];
    
        [self.letaoRightCollectionView registerNib:header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXLDCategorysRightHeaderView];
        
        [self.letaoRightCollectionView registerNib:[UINib nibWithNibName:kXLDCategorysRightFooterView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXLDCategorysRightFooterView];

        
        [self addSubview:self.letaoRightCollectionView];
        self.letaoIsReturnLastOffset=YES;
        self.letaoRightCollectionView.backgroundColor=self.letaoLeftSelectBgColor;

        self.backgroundColor=self.letaoLeftSelectBgColor;
        
    }
    return self;
}


-(void)setLetaoNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
        /**
         *  滑动到 指定行数
         */
    [self.letaoLeftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

    _letaoSelectIndex=needToScorllerIndex;
        
    [self.letaoRightCollectionView reloadData];

    _letaoNeedToScorllerIndex=needToScorllerIndex;
}

-(void)setLetaoLeftBgColor:(UIColor *)leftBgColor{
    _letaoLeftBgColor=leftBgColor;
    self.letaoLeftTableView.backgroundColor=leftBgColor;
   
}
-(void)setLetaoLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _letaoLeftSelectBgColor=leftSelectBgColor;
    self.letaoRightCollectionView.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLetaoLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _letaoLeftSeparatorColor=leftSeparatorColor;
    self.letaoLeftTableView.separatorColor=leftSeparatorColor;
}

-(void)reloadData {
    [self.letaoLeftTableView reloadData];
    [self.letaoRightCollectionView reloadData];
}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letaoAllDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLDCategorysLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLDCategorysLeftTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    XLTCategoryModel * title=self.letaoAllDataArray[indexPath.row];
    
    cell.letaoTitleTextLabel.text=title.letaoCategoryName;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset=UIEdgeInsetsZero;
    }

    BOOL selected = (indexPath.row == _letaoSelectIndex);
    [cell adjustStyleForSelected:selected];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self leftCategoryDidSelectRowAtIndexPath:indexPath];
}

-(void)leftCategoryDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _letaoSelectIndex=indexPath.row;

    XLTCategoryModel * title=self.letaoAllDataArray[indexPath.row];
    
    self.letaoIsReturnLastOffset=NO;
    
    
    [self.letaoRightCollectionView reloadData];

    
    if (self.letaoIsRecordLastScrollPosition) {
        [self.letaoRightCollectionView scrollRectToVisible:CGRectMake(0, title.letaoTopOffset, self.letaoRightCollectionView.frame.size.width, self.letaoRightCollectionView.frame.size.height) animated:self.letaoIsRecordLastScrollAnimated];
    }
    else{
        CGFloat  y = 0 - self.letaoRightCollectionView.contentInset.top;
        [self.letaoRightCollectionView setContentOffset:CGPointMake(0, y) animated:self.letaoIsRecordLastScrollAnimated];
    }
    
    // 汇报事件
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"classify_name"] = [SDRepoManager repoResultValue:title.letaoCategoryName];
    properties[@"xlt_item_level"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:title.letaoLevel]];
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_CATEGORY properties:properties];
}


#pragma mark---imageCollectionView--------------------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.letaoAllDataArray.count==0) {
        return 0;
    }
    XLTCategoryModel * title = self.letaoAllDataArray[self.letaoSelectIndex];
    return   title.letaoChildCategoryArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    XLTCategoryModel * title=self.letaoAllDataArray[self.letaoSelectIndex];
    if (title.letaoChildCategoryArray.count>0) {
        XLTCategoryModel *sub = title.letaoChildCategoryArray[section];
        if (sub.letaoChildCategoryArray.count==0)//没有下一级
        {
            return 1;
        } else {
            return sub.letaoChildCategoryArray.count;
        }
    }
    else{
        return title.letaoChildCategoryArray.count;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XLTCategoryModel * title=self.letaoAllDataArray[self.letaoSelectIndex];
    NSArray * list;
    
    
    
    XLTCategoryModel * meun;
    
    meun=title.letaoChildCategoryArray[indexPath.section];
    
    if (meun.letaoChildCategoryArray.count>0) {
        meun=title.letaoChildCategoryArray[indexPath.section];
        list=meun.letaoChildCategoryArray;
        meun=list[indexPath.row];
    }


    void (^select)(NSInteger left,NSInteger right,id info) = self.letaoCategoryBlock;
    
    select(self.letaoSelectIndex,indexPath.row,meun);
    // 汇报事件
    NSMutableDictionary *properties = @{}.mutableCopy;
    properties[@"classify_name"] = [SDRepoManager repoResultValue:title.letaoCategoryName];
    properties[@"xlt_item_level"] = [NSString stringWithFormat:@"%@",[SDRepoManager repoResultValue:title.letaoLevel]];
    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_CATEGORY properties:properties];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XLDCategorysRightTableViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kXLDCategorysRightTableViewCell forIndexPath:indexPath];
    XLTCategoryModel * title=self.letaoAllDataArray[self.letaoSelectIndex];
    NSArray * list;
    
    XLTCategoryModel * meun;

    meun=title.letaoChildCategoryArray[indexPath.section];

    if (meun.letaoChildCategoryArray.count>0) {
        meun=title.letaoChildCategoryArray[indexPath.section];
        list=meun.letaoChildCategoryArray;
        meun=list[indexPath.row];
    }
    
    cell.letaoCategoryTitleLabel.text=meun.letaoCategoryName;
    [cell.letaoCategoryImageView sd_setImageWithURL:[NSURL URLWithString:[meun.letaoCategoryIcon letaoConvertToHttpsUrl]] placeholderImage:kPlaceholderSmallImage];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = kXLDCategorysRightFooterView;
    }else{
        reuseIdentifier = kXLDCategorysRightHeaderView;
    }
    
    XLTCategoryModel * title = self.letaoAllDataArray[self.letaoSelectIndex];
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    UILabel *label = (UILabel *)[view viewWithTag:1234];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        if (title.letaoChildCategoryArray.count>0) {            XLTCategoryModel * meun = title.letaoChildCategoryArray[indexPath.section];
            label.text=meun.letaoCategoryName;
        }
        else{
            label.text=@"暂无";
        }
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width =  floorl((kScreenWidth - kCategorysViewLeftTableWidth - 120) /3);
    return CGSizeMake(width, kScreen_iPhone375Scale(86));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 30, 15, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {kScreenWidth,49};
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    XLTCategoryModel *title = self.allData[self.selectIndex];
//    if (title.nextCategoryArray.count > 0) {
//        XLTCategoryModel *sub = title.nextCategoryArray[section];
//        if (sub.nextCategoryArray.count > 0) {
//            return CGSizeMake(kScreenWidth, 10);
//        }
//    }
    return CGSizeMake(kScreenWidth, 20);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}


#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.letaoRightCollectionView]) {

        
        self.letaoIsReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.letaoRightCollectionView]) {
        
        XLTCategoryModel * title=self.letaoAllDataArray[self.letaoSelectIndex];
        
        title.letaoTopOffset=scrollView.contentOffset.y;
        self.letaoIsReturnLastOffset=NO;
        
    }

 }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.letaoRightCollectionView]) {
        
        XLTCategoryModel * title=self.letaoAllDataArray[self.letaoSelectIndex];
        
        title.letaoTopOffset=scrollView.contentOffset.y;
        self.letaoIsReturnLastOffset=NO;
        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.letaoRightCollectionView] && self.letaoIsReturnLastOffset) {
        XLTCategoryModel * title=self.letaoAllDataArray[self.letaoSelectIndex];
        
        title.letaoTopOffset=scrollView.contentOffset.y;

        
    }
}



#pragma mark--Tools
-(void)letaoPerformBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


- (void)needPickCategory:(NSString *)categoryId categoryLevel:(NSNumber *)categoryLevel {
    if ([categoryId isKindOfClass:[NSString class]]) {
        if ([categoryLevel integerValue] == 1) {
            // 一级分类
            __block NSInteger categoryIdx = NSNotFound;
            [self.letaoAllDataArray enumerateObjectsUsingBlock:^(XLTCategoryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.letaoCategoryId isKindOfClass:[NSString class]]
                    && [categoryId isEqualToString:obj.letaoCategoryId]) {
                    categoryIdx = idx;
                    *stop = YES;
                }
            }];
            if (categoryIdx != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:categoryIdx inSection:0];
                [self.letaoLeftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self leftCategoryDidSelectRowAtIndexPath:indexPath];
            }
            
        } else if ([categoryLevel integerValue] == 2) {
            // 二级分类
            __block NSInteger leftCategoryIdx = NSNotFound;
            __block NSInteger rightCategoryIdx = NSNotFound;
            [self.letaoAllDataArray enumerateObjectsUsingBlock:^(XLTCategoryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *childCategoryArray = obj.letaoChildCategoryArray;
                [childCategoryArray enumerateObjectsUsingBlock:^(XLTCategoryModel * _Nonnull chilObj, NSUInteger childIdx, BOOL * _Nonnull childStop) {
                    if ([chilObj.letaoCategoryId isKindOfClass:[NSString class]]
                        && [categoryId isEqualToString:chilObj.letaoCategoryId]) {
                        rightCategoryIdx = childIdx;
                        leftCategoryIdx = idx;
                        *stop = YES;
                        *childStop = YES;
                    }
                }];
            }];
            
            if (leftCategoryIdx != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:leftCategoryIdx inSection:0];
                [self.letaoLeftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self leftCategoryDidSelectRowAtIndexPath:indexPath];
            }
            
            if (rightCategoryIdx != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:rightCategoryIdx];
                [ self.letaoRightCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
                
            }
        }
    }


}
@end



