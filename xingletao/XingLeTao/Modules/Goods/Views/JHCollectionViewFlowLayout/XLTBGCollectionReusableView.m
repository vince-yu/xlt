

#import "XLTBGCollectionReusableView.h"
#import "XLTBGCollectionViewLayoutAttributes.h"

@implementation XLTBGCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[XLTBGCollectionViewLayoutAttributes class]]) {
        XLTBGCollectionViewLayoutAttributes *attr = (XLTBGCollectionViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroundColor;
    }
}
@end
