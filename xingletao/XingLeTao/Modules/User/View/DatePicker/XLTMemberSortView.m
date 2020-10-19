//
//  XLTMemberSortView.m
//  XingLeTao
//
//  Created by SNQU on 2019/11/20.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTMemberSortView.h"

@interface XLTMemberSortView () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,assign) NSInteger selectIndex;
@end

@implementation XLTMemberSortView

- (instancetype)initWithSortArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.letaoPageDataArray = array;
    }
    return self;
}
- (void)initPickView
{
    [super initPickView];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    [self.confirmButton setTitleColor:[UIColor colorWithHex:0xD22C2F] forState:UIControlStateNormal];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.letaoPageDataArray.count;
    
    
}
- (NSInteger)getDaysWithYear:(NSInteger)year
                       month:(NSInteger)month
{
    switch (month) {
        case 1:
            return 31;
            break;
        case 2:
            if (year%400==0 || (year%100!=0 && year%4 == 0)) {
                return 29;
            }else{
                return 28;
            }
            break;
        case 3:
            return 31;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 31;
            break;
        case 6:
            return 30;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 31;
            break;
        case 9:
            return 30;
            break;
        case 10:
            return 31;
            break;
        case 11:
            return 30;
            break;
        case 12:
            return 31;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    //每一行的高度
    return 36;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    self.selectIndex = row;
//    [self refreshPickViewData];
    
 
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (row < self.letaoPageDataArray.count) {
        text = [self.letaoPageDataArray objectAtIndex:row];
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    label.text = text;
    
    return label;
}


- (void)clickConfirmButton
{
    
    
    if ([self.delegate respondsToSelector:@selector(pickerDateView:selectIndex:)]) {
        
        [self.delegate pickerDateView:self selectIndex:self.selectIndex];
    
    }
    
    [super clickConfirmButton];
    
}



- (void)refreshPickViewData
{
    self.selectIndex = 0;
    [self.pickerView selectedRowInComponent:0];
    
}
 


@end
