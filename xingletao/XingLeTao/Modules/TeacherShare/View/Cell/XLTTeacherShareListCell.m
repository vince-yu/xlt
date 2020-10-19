//
//  XLTTeacherShareListCell.m
//  XingLeTao
//
//  Created by vince on 2020/9/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTTeacherShareListCell.h"
#import "NSString+XLTSourceStringHelper.h"

@interface XLTTeacherShareListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upBtnRight;

@end

@implementation XLTTeacherShareListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.upBtn.hidden = YES;
    self.downBtn.hidden = YES;
    self.topTipLabel.hidden = YES;
    self.lookBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(XLTTeacherShareListModel *)model{
    _model = model;
    self.nameLabel.text = self.model.title.length ? self.model.title : @"";
    self.timeLabel.text = self.model.itime.length ? [self.model.itime convertDateStringWithSecondTimeStr:@"创建于 yyyy-MM-dd"] : @"";
    [self.logo sd_setImageWithURL:[NSURL URLWithString:[self.model.logo letaoConvertToHttpsUrl]] placeholderImage:[UIImage imageNamed:@"xinletao_placeholder_loading_small"]];
    switch (self.model.type) {
        case XLTTeacherShareCellTypeNomal:
        {
            self.topBtn.hidden = YES;
            self.downBtn.hidden = YES;
            self.topTipLabel.hidden = YES;
            self.moreBtn.hidden = NO;
            self.lookBtn.hidden = YES;
            self.upBtn.hidden = YES;
        }
            break;
        case XLTTeacherShareCellTypeMeAll:
        {
            self.topBtn.hidden = NO;
            self.downBtn.hidden = YES;
            self.topTipLabel.hidden = YES;
            self.moreBtn.hidden = YES;
            self.lookBtn.hidden = !(self.model.status.intValue == 2);
            self.upBtn.hidden = YES;
        }
            break;
        case XLTTeacherShareCellTypeMeShow:
        {
            
            
            self.moreBtn.hidden = YES;
            self.lookBtn.hidden = YES;
            self.upBtn.hidden = YES;
            if (self.model.is_top.boolValue) {
                self.topTipLabel.hidden = NO;
                self.topBtn.hidden = NO;
                self.downBtn.hidden = YES;
                
            }else{
                self.topTipLabel.hidden = YES;
                switch (self.model.indexType) {
                    case XLTTeacherShareIndexTypeFirst:
                        self.upBtn.hidden = YES;
                        self.downBtn.hidden = NO;
                        self.upBtnRight.constant = 60;
                        break;
                    case XLTTeacherShareIndexTypeLast:
                        self.upBtn.hidden = NO;
                        self.downBtn.hidden = YES;
                        self.upBtnRight.constant = 15;
                        break;
                    case XLTTeacherShareIndexTypeNomal:
                        self.upBtn.hidden = NO;
                        self.downBtn.hidden = NO;
                        self.upBtnRight.constant = 60;
                        break;
                    default:
                        self.upBtn.hidden = YES;
                        self.downBtn.hidden = YES;
                        self.topBtn.hidden = NO;
                        self.upBtnRight.constant = 60;
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
}
- (IBAction)editAction:(id)sender {
    if (self.model.type == XLTTeacherShareCellTypeMeAll) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setShowWithModel:)]) {
            [self.delegate setShowWithModel:self.model];
        }
    }else if (self.model.type == XLTTeacherShareCellTypeMeShow) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setTopWithModel:)]) {
            [self.delegate setTopWithModel:self.model];
        }
    }
}
- (IBAction)upAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveWithModel:isUp:)]) {
        [self.delegate moveWithModel:self.model isUp:YES];
    }
}
- (IBAction)downAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveWithModel:isUp:)]) {
        [self.delegate moveWithModel:self.model isUp:NO];
    }
}

@end
