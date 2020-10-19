

#import <UIKit/UIKit.h>

@interface XLDCategorysLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *letaoTitleTextLabel;
@property (weak, nonatomic) IBOutlet UIView *letaoLineView;
-(void)setZero;
- (void)adjustStyleForSelected:(BOOL)selected;
@end
