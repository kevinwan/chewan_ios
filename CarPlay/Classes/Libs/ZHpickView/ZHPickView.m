//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//
#define ZHToobarHeight 40
#import "ZHPickView.h"

@interface ZHPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,assign)BOOL isFromPlist;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@end

@implementation ZHPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{

    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _isLevelDic=YES;
        _isLevelString=NO;
        _isLevelArray=NO;
        _isFromPlist=YES;
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
        areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSArray *components = [areaDic allKeys];
        NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *tmp = [[areaDic objectForKey: index] allKeys];
            [provinceTmp addObject: [tmp objectAtIndex:0]];
        }
        
        province = [[NSArray alloc] initWithArray: provinceTmp];
        
        NSString *index = [sortedArray objectAtIndex:0];
        NSString *selected = [province objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
        
        NSArray *cityArray = [dic allKeys];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
        city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
        
        
        NSString *selectedCity = [city objectAtIndex: 0];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
        
        selectedProvince = [province objectAtIndex: 0];
        
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
//         _dicKeyArray=[[NSMutableArray alloc] init];
//        for (id levelTwo in areaDic) {
//                _isLevelDic=YES;
//                _isLevelString=NO;
//                _isLevelArray=NO;
//                _levelTwoDic=levelTwo;
//                [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
//        }
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
            _isFromPlist=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            _isFromPlist=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _isFromPlist=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
    
    
//    for (id levelTwo in array) {
//            _isLevelDic=YES;
//            _isLevelString=NO;
//            _isLevelArray=NO;
//            _isFromPlist=NO;
//            _levelTwoDic=levelTwo;
//            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
//    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+ZHToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}
-(void)setUpPickView{
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, ZHToobarHeight, pickView.frame.size.width, pickView.frame.size.height);
//    pickView.showsSelectionIndicator = YES;
//    [pickView selectRow: 0 inComponent: 0 animated: YES];
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor whiteColor];
    NSDate *now = [[NSDate alloc]init];
    datePicker.maximumDate=now;
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}
-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

#pragma mark piackView 数据源方法
#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        if (_isFromPlist) {
            component=3;
        }else{
            component=[_levelTwoDic allKeys].count*2;
        }
        
    }
    return component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        if (_isFromPlist) {
        if (component == PROVINCE_COMPONENT) {
            rowArray=province;
        }
        else if (component == CITY_COMPONENT) {
            rowArray=city;
        }
        else {
            rowArray=district;
        }
        }else{
            NSInteger pIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dic=_plistArray[pIndex];
            for (id dicValue in [dic allValues]) {
                if ([dicValue isKindOfClass:[NSArray class]]) {
                    if (component%2==1) {
                        rowArray=dicValue;
                    }else{
                        rowArray=_plistArray;
                    }
                }
            }
        }
    }
    return rowArray.count;
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        if (_isFromPlist) {
            if (component == PROVINCE_COMPONENT) {
                rowTitle = [province objectAtIndex: row];
            }
            else if (component == CITY_COMPONENT) {
                rowTitle = [city objectAtIndex: row];
            }
            else {
                rowTitle = [district objectAtIndex: row];
            }
        }else{
            NSInteger pIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dic=_plistArray[pIndex];
            if(component%2==0)
            {
                rowTitle=_dicKeyArray[row][component];
            }
            for (id aa in [dic allValues]) {
                if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                    NSArray *bb=aa;
                    if (bb.count>row) {
                        rowTitle=aa[row];
                    }
                    
                }
            }
        }
       
    }
    return rowTitle;
    
    
    
    
    
//    if (component == PROVINCE_COMPONENT) {
//        return [province objectAtIndex: row];
//    }
//    else if (component == CITY_COMPONENT) {
//        return [city objectAtIndex: row];
//    }
//    else {
//        return [district objectAtIndex: row];
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (_isFromPlist) {
            if (component == PROVINCE_COMPONENT) {
                selectedProvince = [province objectAtIndex: row];
                NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
                NSArray *cityArray = [dic allKeys];
                NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                    
                    if ([obj1 integerValue] > [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;//递减
                    }
                    
                    if ([obj1 integerValue] < [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;//上升
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (int i=0; i<[sortedArray count]; i++) {
                    NSString *index = [sortedArray objectAtIndex:i];
                    NSArray *temp = [[dic objectForKey: index] allKeys];
                    [array addObject: [temp objectAtIndex:0]];
                }
                
                city = [[NSArray alloc] initWithArray: array];
                
                NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
                district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
                [pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
                [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
                [pickerView reloadComponent: CITY_COMPONENT];
                [pickerView reloadComponent: DISTRICT_COMPONENT];
                
            }
            else if (component == CITY_COMPONENT) {
                NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
                NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
                NSArray *dicKeyArray = [dic allKeys];
                NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                    
                    if ([obj1 integerValue] > [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([obj1 integerValue] < [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
                NSArray *cityKeyArray = [cityDic allKeys];
                
                district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
                [pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
                [pickerView reloadComponent: DISTRICT_COMPONENT];
            }else if (component == DISTRICT_COMPONENT){
                
            }
        }else{
            if (component==0) {
                _state =_dicKeyArray[row][0];
            }else{
                NSInteger cIndex = [pickerView selectedRowInComponent:0];
                NSDictionary *dicValueDic=_plistArray[cIndex];
                NSArray *dicValueArray=[dicValueDic allValues][0];
                if (dicValueArray.count>row) {
                    _city =dicValueArray[row];
                }
            }
        }
    }
}

-(void)remove{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];
    [self removeFromSuperview];
}
-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)doneClick
{
    if (_pickerView) {
        
        if (_resultString) {
           
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                
                NSInteger provinceIndex = [_pickerView selectedRowInComponent: PROVINCE_COMPONENT];
                NSInteger cityIndex = [_pickerView selectedRowInComponent: CITY_COMPONENT];
                NSInteger districtIndex = [_pickerView selectedRowInComponent: DISTRICT_COMPONENT];
                
                NSString *provinceStr = [province objectAtIndex: provinceIndex];
                NSString *cityStr = [city objectAtIndex: cityIndex];
                NSString *districtStr = [district objectAtIndex:districtIndex];
                
                if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
                    cityStr = @"";
                    districtStr = @"";
                }
                else if ([cityStr isEqualToString: districtStr]) {
                    districtStr = @"";
                }
              _resultString=[NSString stringWithFormat: @"%@,%@,%@", provinceStr, cityStr, districtStr];
           }
        }
    }else if (_datePicker) {
//        NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
//        [dateFormtter setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateString=[dateFormtter stringFromDate:_datePicker.date];
       
        _resultString=[NSString stringWithFormat:@"%f",[_datePicker.date timeIntervalSinceNow]];
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];
}
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor=color;
}
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
-(void)dealloc{
    
    //NSLog(@"销毁了");
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
