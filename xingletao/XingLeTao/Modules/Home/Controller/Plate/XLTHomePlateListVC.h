//
//  XLTHomePlateListVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseCollectionViewController.h"
#import "XLTHomePlateContainerVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTHomePlateListVC : XLTBaseCollectionViewController
@property (nonatomic, copy) NSString *letaoParentPlateId;
@property (nonatomic, copy) NSString *letaoParentPlateName;


@property (nonatomic, copy) NSString *plateCode;
@property (nonatomic, copy) NSString *plateName;

@property (nonatomic, assign) XLTPlateType plateType;

- (void)repoViewPage;
@end

NS_ASSUME_NONNULL_END
