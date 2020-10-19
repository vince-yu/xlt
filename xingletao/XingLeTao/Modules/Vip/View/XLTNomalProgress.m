//
//  SDNomalProgress.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/27.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "XLTNomalProgress.h"

@interface XLTNomalProgress ()

@end

@implementation XLTNomalProgress
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    self.aView=[[UIView alloc] initWithFrame:self.frame];
    self.aView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.3];
//        self.aView.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
//        self.aView.layer.borderWidth = 1;
    self.UIProess=[[UIView alloc] init];
    self.aView.layer.cornerRadius= 6.5/2;
    self.aView.layer.masksToBounds=YES;
    self.UIProess.layer.cornerRadius= 6.5/2;
    self.UIProess.layer.masksToBounds=YES;
    self.UIProess.backgroundColor= [UIColor whiteColor];
    
    self.UIProess.center = self.aView.center;
    
    [self addSubview:self.aView];
    [self.aView addSubview:self.UIProess];
    
    self.progressLabel = [[UILabel alloc] init];
//        [self.aView addSubview:self.progressLabel];
////        self.progressLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
//        self.progressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:10];
//        self.progressLabel.textAlignment = NSTextAlignmentCenter;
//
//        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.equalTo(self.aView);
//        }];
    
    [self.aView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - 34 - 30);
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.UIProess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.aView);
        make.width.mas_equalTo(12);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self initialize];
    }
    return self;
}
- (void)setTaskProgressValue:(CGFloat)taskProgressValue {
    _taskProgressValue = taskProgressValue;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(100 * (taskProgressValue > 1 ? 1 : taskProgressValue))];

    [self.UIProess mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.aView);
        make.width.equalTo(self.aView.mas_width).multipliedBy(taskProgressValue);
    }];
}

@end
