//
//  DYVideoCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/4/26.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DYVideoCell;
@protocol DYVideoCellDelegate <NSObject>

- (void)cell:(DYVideoCell *)cell playerAssetStatusReadyToPlayInfo:(NSDictionary *)info;
- (void)cell:(DYVideoCell *)cell playerAssetStatusDidFinishInfo:(NSDictionary *)info;


- (void)cell:(DYVideoCell *)cell buyButtonAction:(id)sneder;
- (void)cell:(DYVideoCell *)cell backButtonAction:(id)sneder;
- (void)cell:(DYVideoCell *)cell textButtonAction:(id)sneder;
- (void)cell:(DYVideoCell *)cell shareButtonAction:(id)sneder;
@end

@interface DYVideoCell : UITableViewCell

@property (nonatomic, weak) id <DYVideoCellDelegate> delegate;
@property (nonatomic, readonly) NSDictionary *letaoInfo;


- (void)updateDataInfo:(NSDictionary *)info atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;


- (void)gestureControlSingleTapHandler;

- (void)tryReplay;
- (void)stopPlay;

- (void)tryPlayWhenViewWillAppear;
- (void)tryPauseWhenViewWillDisappear;
@end

NS_ASSUME_NONNULL_END
