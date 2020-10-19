
#import "XLDCategorysLeftTableViewCell.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"

@implementation XLDCategorysLeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self adjustStyleForSelected:selected];
}

- (void)adjustStyleForSelected:(BOOL)selected {
    if (selected) {
           self.contentView.backgroundColor = [UIColor whiteColor];
           self.letaoLineView.backgroundColor = [UIColor colorWithHex:0xFFFF6E02];
           self.letaoTitleTextLabel.textColor = [UIColor colorWithHex:0xFF25282D];
       } else {
           self.contentView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
           self.letaoLineView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
           self.letaoTitleTextLabel.textColor = [UIColor colorWithHex:0xFF848487];
       }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    if (highlighted) {
//        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.letaoLineView.backgroundColor = [UIColor colorWithHex:0xFFFF6E02];
//        self.letaoTitleTextLabel.textColor = [UIColor colorWithHex:0xFF25282D];
//    } else {
//        self.contentView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
//        self.letaoLineView.backgroundColor = [UIColor colorWithHex:0xFFF5F5F7];
//        self.letaoTitleTextLabel.textColor = [UIColor colorWithHex:0xFF848487];
//    }
//}

-(void)setZero{
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins=UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        self.separatorInset=UIEdgeInsetsZero;
    }

}
@end
