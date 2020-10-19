//
//  XLTFeedRecommedRankingListVC.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/19.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTFeedRecommedRankingListVC.h"
#import "XLTFeedRecommedRankingTextCell.h"
#import "XLTFeedRecommedRankingTopCell.h"
#import "XLTRecommedFeedLogic.h"
#import "XLTShareFeedEmptyCell.h"
#import "XLTShareFeedEmptyCell.h"
#import "XLTShareFeedTextCell.h"
#import "XLTShareFeedMediaCell.h"
#import "XLTShareFeedGoodsCell.h"
#import "XLTShareFeedGoodsStepCell.h"
#import "XLTGoodsDetailVC.h"

@interface XLTFeedRecommedRankingListVC ()

@end

@implementation XLTFeedRecommedRankingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// CELL
- (void)registerTableViewCells {
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedTopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedTopCell"];
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedTextCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedMediaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedMediaCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedGoodsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedGoodsCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedGoodsStepCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedGoodsStepCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTShareFeedEmptyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTShareFeedEmptyCell"];

    // 新增
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTFeedRecommedRankingTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTFeedRecommedRankingTextCell"];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"XLTFeedRecommedRankingTopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XLTFeedRecommedRankingTopCell"];
}

- (void)letaoFetchPageDataForIndex:(NSInteger)index pageSize:(NSInteger)pageSize success:(XLTBaseListRequestSuccess)success failed:(XLTBaseListRequestFailed)failed {
    __weak typeof(self)weakSelf = self;
    [XLTRecommedFeedLogic requeFeedRecommedRankingListDataForIndex:index pageSize:pageSize rankingType:self.rankingType success:^(NSArray * _Nonnull feedArray, NSURLSessionDataTask * _Nonnull task) {
        [weakSelf.unFoldIndexDictionary removeAllObjects];
        success(feedArray);
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        failed(nil,errorMsg);
    }];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView shareCellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView shareCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![self isValidCellForRowAtIndexPath:indexPath]) {
        XLTShareFeedEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedEmptyCell" forIndexPath:indexPath];
        NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == (numberOfRows - 1)) {
            cell.contentMediaViewHeight.constant = 10;
        } else {
            cell.contentMediaViewHeight.constant = 1;
        }
        return cell;
    } else if (indexPath.row == 0) {
        XLTFeedRecommedRankingTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTFeedRecommedRankingTopCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell letaoUpdateCellDataWithInfo:self.letaoPageDataArray[indexPath.section] indexPath:indexPath];
        return cell;
        
    } else if (indexPath.row == 1) {
        XLTFeedRecommedRankingTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTFeedRecommedRankingTextCell" forIndexPath:indexPath];
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        [cell letaoUpdateCellDataWithInfo:info rankingType:self.rankingType];
        return cell;
           
    }  else if (indexPath.row == 2) {
        XLTShareFeedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedTextCell" forIndexPath:indexPath];
        cell.delegate = self;
        BOOL fold = ![self isUnFoldIndexPath:indexPath];
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSString *content = nil;
        if ([info isKindOfClass:[NSDictionary class]] && [info[@"share_content"] isKindOfClass:[NSString class]]) {
            content = info[@"share_content"];
        }
        [cell letaoUpdateCellContentText:content fold:fold];
        cell.stackViewTop.constant = 3;
        return cell;
    } else if (indexPath.row == 3) {
        XLTShareFeedMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedMediaCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        [cell letaoUpdateCellDataWithInfo:info];
        
        return cell;
    } else if (indexPath.row == 4) {
        XLTShareFeedGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedGoodsCell" forIndexPath:indexPath];
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *goodBase = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            goodBase = info[@"goods_info"];
        }
        [cell letaoUpdateCellGoodsInfo:goodBase otherDataInfo:info];
        return cell;
    } else {
        XLTShareFeedGoodsStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTShareFeedGoodsStepCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *goodBase = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            goodBase = info[@"goods_info"];
        }
        [cell letaoUpdateCellDataWithInfo:goodBase];
        return cell;
    }
}

- (BOOL)isValidCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *info = self.letaoPageDataArray[indexPath.section];
    if (indexPath.row == 0) {
        return YES;
    } else if (indexPath.row == 1) {
        NSString *order_count = nil;
        NSString *rank = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            
            if ([info[@"order_count"] isKindOfClass:[NSNumber class]]) {
                order_count = info[@"order_count"];
            }
            
            if ([info[@"rank"] isKindOfClass:[NSNumber class]]) {
                rank = info[@"rank"];
            }
        }
//        return [rank integerValue] >0 && [rank integerValue] < 9999999 ;
        return YES;
    } else if (indexPath.row == 2) {
        NSString *content = nil;
        if ([info isKindOfClass:[NSDictionary class]] && [info[@"share_content"] isKindOfClass:[NSString class]]) {
            content = info[@"share_content"];
        }
        return content.length > 0;
    } else if (indexPath.row == 3) {
        NSArray *images = nil;
        NSArray *videos = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            if ([info[@"images"] isKindOfClass:[NSArray class]]) {
                images = info[@"images"];
            }
            if ([info[@"videos"] isKindOfClass:[NSArray class]]) {
                videos = info[@"videos"];
            }
        }
        NSMutableArray *mediaArray = [NSMutableArray array];
        if (videos.count) {
            [mediaArray addObjectsFromArray:videos];
        }
        if (images.count) {
            [mediaArray addObjectsFromArray:images];
        }
        return mediaArray.count > 0;
    } else if (indexPath.row == 4) {
           NSDictionary *goodBase = nil;
           if ([info isKindOfClass:[NSDictionary class]]) {
               goodBase = info[@"goods_info"];
           }
           return ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0);
    }else if (indexPath.row == 5) {
        NSDictionary *goodBase = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            goodBase = info[@"goods_info"];
        }
        return ([goodBase isKindOfClass:[NSDictionary class]] && goodBase.count >0);
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.letaoPageDataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        return 6;
    } else {
        return 5;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        NSDictionary *info = self.letaoPageDataArray[indexPath.section];
        NSDictionary *itemInfo = nil;
        if ([info isKindOfClass:[NSDictionary class]]) {
            itemInfo = info[@"goods_info"];
        }

        if ([itemInfo isKindOfClass:[NSDictionary class]]) {
            NSString *letaoGoodsId = itemInfo[@"_id"];
            NSString *letaoStoreId = itemInfo[@"seller_shop_id"];
            XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
            goodDetailViewController.letaoPassDetailInfo = itemInfo;
            goodDetailViewController.letaoGoodsId = letaoGoodsId;
            goodDetailViewController.letaoStoreId = letaoStoreId;
            NSString *item_source = itemInfo[@"item_source"];
            goodDetailViewController.letaoGoodsSource = item_source;
            NSString *letaoGoodsItemId = itemInfo[@"item_id"];
            goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
            [self.navigationController pushViewController:goodDetailViewController animated:YES];
        }

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    if ([self.delegate respondsToSelector:@selector(xlt_scrollPageViewDidScroll:)]) {
        [self.delegate xlt_scrollPageViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(xlt_scrollPageViewDidEndDecelerating:)]) {
        [self.delegate xlt_scrollPageViewDidEndDecelerating:scrollView];
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(xlt_scrollPageViewDidEndDragging:willDecelerate:)]) {
        [self.delegate xlt_scrollPageViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(xlt_scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate xlt_scrollViewDidEndScrollingAnimation:scrollView];
    }
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
