//
//  XLTGoodsEarnShareImageView.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTGoodsEarnShareImageView : UIView
- (void)updateGoodsData:(id _Nullable )itemInfo    imageURLStringsGroup:(NSMutableArray *)imageURLStringsGroup
                    tkl:(NSString * _Nullable)tkl
                    jdkl:(NSString * _Nullable)jdkl
 complete:(void(^)(BOOL success, NSMutableArray *imageArray))complete;
@end

NS_ASSUME_NONNULL_END
