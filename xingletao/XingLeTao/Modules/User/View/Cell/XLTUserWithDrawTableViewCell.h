//
//  XLTUserWithDrawTableViewCell.h
//  XingLeTao
//
//  Created by SNQU on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserWithDrawTableViewCell : UITableViewCell
//@property (nonatomic ,strong) NSString *miniPrice;
@property (nonatomic ,strong) NSString *maxPrice;
@property (nonatomic ,copy) void(^textFieldChange)(NSString *text);
- (void)clearTextField;
@end

NS_ASSUME_NONNULL_END
