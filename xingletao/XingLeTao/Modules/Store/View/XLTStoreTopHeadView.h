//
//  XLTStoreTopHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTStoreTopHeadView : UIView
- (void)letaoUpdateStoreWithDictionary :(NSDictionary * )letaoStoreDictionary;
- (void)letaoHiddenStoreInfo:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
