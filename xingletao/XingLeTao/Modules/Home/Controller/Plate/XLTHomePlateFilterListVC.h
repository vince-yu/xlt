//
//  XLTHomePlateFilterListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionFilterViewController.h"
#import "XLTHomePlateContainerVC.h"

NS_ASSUME_NONNULL_BEGIN
#define kFilterHeaderViewIdentifier @"kFilterHeaderViewIdentifier"

@interface XLTHomePlateFilterListVC : XLTBaseCollectionFilterViewController
@property (nonatomic, copy) NSString *letaoParentPlateId;
@property (nonatomic, copy) NSString *letaoParentPlateName;

@property (nonatomic, copy) NSString *letaoCurrentPlateId;
@property (nonatomic, copy) NSString *plateName;

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSNumber *categoryLevel;

@property (nonatomic, copy) NSString *parentCategoryId;
@property (nonatomic, copy) NSString *parentCategoryName;

@property (nonatomic, assign) BOOL nonePlateList;


- (NSString *)letaoSortValueTypeParameter;

- (NSString *)sourceParameter;

- (NSNumber *)postageParameter;

@property(nonatomic, readonly) BOOL letaoSwitchOn;
@end

NS_ASSUME_NONNULL_END
