//
//  MatchingSelectView.m
//  CarPlay
//
//  Created by 公平价 on 15/10/16.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "OtherMatchingSelectView.h"
#import "CPNameIndex.h"

@implementation OtherMatchingSelectView

- (void)awakeFromNib
{
    self.whetherShuttle=@"0";
    [self.selectView.layer setMasksToBounds:YES];
    [self.selectView.layer setCornerRadius:10.0];
    [self.selectPlace.layer setMasksToBounds:YES];
    [self.selectPlace.layer setCornerRadius:10.0];
    self.selectPlace.layer.borderColor=[[Tools getColor:@"dddddd"]CGColor];
    self.selectPlace.layer.borderWidth= 1.0f;
    [self.matchingBtn.layer setMasksToBounds:YES];
    [self.matchingBtn.layer setCornerRadius:20.0];
    [self.locationAddressView.layer setMasksToBounds:YES];
    [self.locationAddressView.layer setCornerRadius:20.0];
    [self.addressSelection.layer setMasksToBounds:YES];
    [self.addressSelection.layer setCornerRadius:20.0];
    [self.confirmButton.layer setMasksToBounds:YES];
    [self.confirmButton.layer setCornerRadius:20.0];
    [self.reSelectionButton.layer setMasksToBounds:YES];
    [self.reSelectionButton.layer setCornerRadius:20.0];
    self.addressTableView.dataSource=self;
    self.addressTableView.delegate=self;
    [self.selectPlace setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.selectPlace.imageView.size.width, 0, self.selectPlace.imageView.size.width)];
    [self.selectPlace setImageEdgeInsets:UIEdgeInsetsMake(0, self.selectPlace.titleLabel.bounds.size.width, 0, -self.selectPlace.titleLabel.bounds.size.width)];
    self.areaList=[[NSMutableArray alloc]init];
    [self addMJindex];
}

- (IBAction)shuttle:(id)sender {
    if ([self.whetherShuttle isEqualToString:@"0"]) {
        [self.shuttleBtn setImage:[UIImage imageNamed:@"点击效果"] forState:UIControlStateNormal];
        self.whetherShuttle=@"1";
        [ZYUserDefaults setBool:YES forKey:Transfer];
    }else{
        [self.shuttleBtn setImage:[UIImage imageNamed:@"初始效果"] forState:UIControlStateNormal];
        self.whetherShuttle=@"0";
        [ZYUserDefaults setBool:NO forKey:Transfer];
    }
}

-(void)addMJindex{
    self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(190.0/320.0*ZYScreenWidth, 170.0/568.0*ZYScreenHeight, 100.0/320.0*ZYScreenWidth, 230.0/568.0*ZYScreenHeight)];
    //    }
    _indexView.dataSource = self;
    _indexView.fontColor = [Tools getColor:@"48d1d5"];
    _indexView.font = [UIFont systemFontOfSize:11.0f];
    _indexView.minimumGapBetweenItems = 0.f;
    _indexView.ergonomicHeight = NO;
    _indexView.selectedItemFontColor=[Tools getColor:@"48d1d5"];
    [self addSubview:_indexView];
}

//选择地址
- (IBAction)selectPlaceClick:(id)sender {
    _locationAddressView.alpha=1.0;
    _selectView.alpha=0.0;
    _addressLable.text=[[NSString alloc]initWithFormat:@"%@  %@  %@  %@",[ZYUserDefaults stringForKey:Province],[ZYUserDefaults stringForKey:City],[ZYUserDefaults stringForKey:District],[ZYUserDefaults stringForKey:Street]];
    _locationAddressLable.text=[[NSString alloc]initWithFormat:@"%@  %@  %@  %@",[ZYUserDefaults stringForKey:Province],[ZYUserDefaults stringForKey:City],[ZYUserDefaults stringForKey:District],[ZYUserDefaults stringForKey:Street]];
}
//
- (IBAction)matchingBtnClick:(id)sender {
    NSDictionary *estabPoint=[[NSDictionary alloc]initWithObjectsAndKeys:@([Tools getLongitude]),@"longitude",@([Tools getLatitude]),@"latitude", nil];
    
    NSDictionary *establish=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:Province],@"province",[ZYUserDefaults stringForKey:City],@"city",[ZYUserDefaults stringForKey:District],@"district",[ZYUserDefaults stringForKey:Street],@"street", nil];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType],@"type",@([ZYUserDefaults boolForKey:Transfer]),@"transfer",establish,@"establish",estabPoint,@"estabPoint",estabPoint,@"destPoint",establish,@"destination",@"AA制",@"pay", nil];
    NSString *path=[[NSString alloc]initWithFormat:@"activity/register?userId=%@&token=%@",[Tools getUserId],[Tools getToken]];
    [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
        if (CPSuccess) {
            NSLog(@"%@",responseObject);
            [[[UIAlertView alloc]initWithTitle:@"测试提示" message:@"发布成功了，手动点击空白出退回先" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failed:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

+(void)show:(NSString *)colorStr{
    OtherMatchingSelectView *view= [[NSBundle mainBundle] loadNibNamed:@"OtherMatchingSelectView" owner:nil options:nil].lastObject;
    view.backgroundColor=[Tools getColor:colorStr];
    view.frame = [ZYKeyWindow bounds];
    [ZYKeyWindow addSubview:view];
    view.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1.0;
    }];
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [view addGestureRecognizer:tap];
}

- (IBAction)closeLocatoinAddressView:(id)sender {
    _locationAddressView.alpha=0.0;
    _selectView.alpha=1.0;
}
- (IBAction)confirm:(id)sender {
    
}

- (IBAction)reSelection:(id)sender {
    _locationAddressView.alpha=0.0;
    _addressSelection.alpha=1.0;
    _parentId=0;
    [self getArea];
}
- (IBAction)closeAddressSelectionView:(id)sender {
    
}

//获取省市列表
-(void)getArea{
    NSString *path=[[NSString alloc]initWithFormat:@"area/list?parentId=%ld",(long)_parentId];
    [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
        if (CPSuccess) {
            NSLog(@"%@",responseObject);
            _areaListBeforeSort=responseObject[@"data"];
            [self reloadData];
//            [_addressTableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)reloadData{
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];//这个是建立索引的核心
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    
    
    
    for (int i = 0; i<[_areaListBeforeSort count]; i++) {
        CPNameIndex *item = [[CPNameIndex alloc] init];
        item._lastName = [_areaListBeforeSort objectAtIndex:i][@"name"];
        item._originIndex = i;
        [temp addObject:item];
    }
    
    
    //名字分section
    for (CPNameIndex *item in temp) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSInteger sect = [theCollation sectionForObject:item collationStringSelector:@selector(getLastName)];
        //设定姓的索引编号
        item._sectionNum = sect;
    }
    
    //返回27，是a－z和＃
    NSInteger highSection = [[theCollation sectionTitles] count];
    //tableView 会被分成27个section
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    //根据sectionNum把名字加入到对应section数组里
    for (CPNameIndex *item in temp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:item._sectionNum] addObject:item];
    }
    //进行排序后，加入到数据源中
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getFirstName)]; //按firstName进行排序
        [self.areaList addObject:sortedSection];//这里friendsList是自己定义的列表数据源
    }
    [self.addressTableView reloadData];
    [self.indexView refreshIndexItems];
}

#pragma UITableViewDataSource UITableViewDelegate
#pragma mark - IndexViewDataSource

- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView {
    
    NSMutableArray * existTitles = [NSMutableArray array];
    NSArray * allTitles = [[UILocalizedIndexedCollation currentCollation]sectionTitles];
    //section数组为空的title过滤掉，不显示
    for (int i=0; i<[allTitles count]; i++) {
        if ([self.areaList count] >i && [[self.areaList objectAtIndex:i] count] > 0) {
            [existTitles addObject:[allTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.areaList.count > 0) {
        NSIndexPath *scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:index];
        NSLog(@"%@",scrollIndexPath);
        NSLog(@"%ld",(long)index);
        if (scrollIndexPath) {
            [_addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}
//
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
////    NSMutableArray * existTitles = [NSMutableArray array];
////    NSArray * allTitles = [[UILocalizedIndexedCollation currentCollation]sectionTitles];
////    //section数组为空的title过滤掉，不显示
////    for (int i=0; i<[allTitles count]; i++) {
////        if ([self.areaList count] >i && [[self.areaList objectAtIndex:i] count] > 0) {
////            [existTitles addObject:[allTitles objectAtIndex:i]];
////        }
////    }
//    return nil;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.areaList count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([[self.areaList objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.areaList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",((CPNameIndex*)[[self.areaList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row])._lastName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}
@end
