

#import "XLTUserPickerPopView.h"

@interface XLTUserPickerPopView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) ConfirmBlock block;
@property (nonatomic, assign) XLTPickerPopViewType type;
@property (nonatomic, assign) CGFloat pickerH;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UIPickerView *sexPicker;
@property (nonatomic, strong) NSArray *sexArr;

@end

@implementation XLTUserPickerPopView

static CGFloat toolBarH = 44;

+ (instancetype)showPopViewWithType:(XLTPickerPopViewType)type confirmBlock:(ConfirmBlock)block {
    return [[self alloc] initWithShowPopViewWithType:type confirmBlock:block];
}

- (instancetype)initWithShowPopViewWithType:(XLTPickerPopViewType)type confirmBlock:(ConfirmBlock)block {
    if (self = [super init]) {
        [self addSubview:self.contentView];
//        [self initWindow];
        self.type = type;
        self.block = block;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)];
        [self addGestureRecognizer:tap];
//        [self showSelf];
    }
    return self;
}
- (void)initWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)setType:(XLTPickerPopViewType)type {
    _type = type;
    if (_type == XLTPickerPopViewTypeDate) {
        self.pickerH = 216;
        [self initToolBar];
        [self initDatePicker];
    }else {
        self.pickerH = 116;
        [self initToolBar];
        [self initSexPicker];
    }
}

- (void)initDatePicker {
    UIDatePicker *datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, toolBarH,kScreenWidth,self.pickerH)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    [datePicker setMaximumDate:[NSDate date]];
//    datePicker setMinimumDate:[NXLTate]
    self.datePicker = datePicker;
    [self.contentView addSubview:datePicker];
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    [self.datePicker setDate:selectedDate animated:YES];
}

- (void)initSexPicker {
    UIPickerView *sexPicker = [[UIPickerView alloc] init];
    sexPicker.backgroundColor = [UIColor whiteColor];
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    sexPicker.frame = CGRectMake(0, toolBarH,kScreenWidth,self.pickerH);
    self.sexPicker = sexPicker;
    [self.contentView addSubview:sexPicker];
}

- (void)setSelectedSex:(int)selectedSex {
    _selectedSex = selectedSex;
    [self.sexPicker selectRow:selectedSex inComponent:0 animated:YES];
}

- (void)initToolBar {
//    CGFloat y = kScreenHeight - toolBarH - self.pickerH;
    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = [UIColor colorWithHex:0xededed];
    toolBar.frame = CGRectMake(0, 0, kScreenWidth, toolBarH);
    [self.contentView addSubview:toolBar];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0x0a7ffb] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closePopView) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    UIButton *canfirmBtn = [[UIButton alloc] init];
    [canfirmBtn setTitleColor:[UIColor colorWithHex:0x0a7ffb] forState:UIControlStateNormal];
    [canfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [canfirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:canfirmBtn];
    [canfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

- (void)show {
    XLT_WeakSelf
    [self initWindow];
    CGFloat contentY = kScreenHeight - toolBarH - self.pickerH;
    self.alpha = 0;
    self.contentView.frame = CGRectMake(0, kScreenHeight + contentY, kScreenWidth, self.pickerH + kBottomSafeHeight);
    [UIView animateWithDuration:0.40 animations:^{
        XLT_StrongSelf
        self.alpha = 1;
        self.contentView.frame = CGRectMake(0, contentY, kScreenWidth, self.pickerH + kBottomSafeHeight + toolBarH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSelf {
    XLT_WeakSelf
    CGFloat contentY = kScreenHeight - toolBarH - self.pickerH;
    self.alpha = 1;
    [UIView animateWithDuration:0.40 animations:^{
        XLT_StrongSelf
        self.alpha = 0;
        self.contentView.frame = CGRectMake(0, kScreenHeight + contentY, kScreenWidth, self.pickerH + kBottomSafeHeight + toolBarH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - action
- (void)closePopView {
    [self hideSelf];
}

- (void)confirmBtnClick {
    if(self.block) {
        if (self.type == XLTPickerPopViewTypeDate) {
            NSString *dateStr= [self.datePicker.date formattedDateWithFormat:@"yyyy-MM"];
            self.block(dateStr);
        }else {
            NSInteger row = [self.sexPicker selectedRowInComponent:0];
            NSString *sexStr =[self.sexArr objectAtIndex:row];
            self.block(sexStr);
        }
    }
    [self closePopView];
}
#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.sexArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = self.sexArr[row];
    return title;
}

#pragma mark - lazy
- (NSArray *)sexArr {
    if (!_sexArr) {
        _sexArr = @[@"保密", @"男", @"女",];
    }
    return _sexArr;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

@end
