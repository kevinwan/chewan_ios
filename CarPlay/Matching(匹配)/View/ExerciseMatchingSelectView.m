//
//  ExerciseMatchingSelectView.m
//  CarPlay
//
//  Created by 公平价 on 15/10/21.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "ExerciseMatchingSelectView.h"
#import "CPNameIndex.h"
#import "CPpinyin.h"
#import "CPTabBarController.h"
#import "CPUser.h"
#import "CPActivityModel.h"
#import "CPUser.h"
#import "CPMatchingPreview.h"
#import "CPAlbum.h"

@interface ExerciseMatchingSelectView ()<UIGestureRecognizerDelegate>
{
    UIView *corentView;
    NSMutableArray *lastParentIds;
    NSMutableArray *selectArea;
    NSInteger lastParentId;
    NSString *majorType;
    CPUser *user;
    NSString *path;
}
@property (nonatomic, strong) UIButton *lastTypebtn;
@property (nonatomic , strong) CPActivityModel *activity;
@end

@implementation ExerciseMatchingSelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whetherShuttle=@"0";
    majorType=@"足球";
    _lastTypebtn = self.footBallBtn;
    [self.footBallBtn setSelected:YES];
    lastParentIds=[[NSMutableArray alloc]init];
    selectArea=[[NSMutableArray alloc]init];
    [self.selectView.layer setMasksToBounds:YES];
    [self.selectView.layer setCornerRadius:10.0];
    [self.selectPlace.layer setMasksToBounds:YES];
    [self.selectPlace.layer setCornerRadius:10.0];
    self.selectPlace.layer.borderColor=[[Tools getColor:@"dddddd"]CGColor];
    self.selectPlace.layer.borderWidth= 1.0f;
    [self.matchingBtn.layer setMasksToBounds:YES];
    [self.matchingBtn.layer setCornerRadius:20.0];
    [self.selectPlace setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.selectPlace.imageView.size.width, 0, self.selectPlace.imageView.size.width)];
    [self.selectPlace setImageEdgeInsets:UIEdgeInsetsMake(0, self.selectPlace.titleLabel.bounds.size.width, 0, -self.selectPlace.titleLabel.bounds.size.width)];
    
    [self.locationAddressView.layer setMasksToBounds:YES];
    [self.locationAddressView.layer setCornerRadius:20.0];
    [self.addressSelection.layer setMasksToBounds:YES];
    [self.addressSelection.layer setCornerRadius:20.0];
    [self.confirmButton.layer setMasksToBounds:YES];
    [self.confirmButton.layer setCornerRadius:20.0];
    [self.reSelectionButton.layer setMasksToBounds:YES];
    [self.reSelectionButton.layer setCornerRadius:20.0];
    self.addressTableView.delegate=self;
    self.addressTableView.dataSource=self;
    self.areaList=[[NSMutableArray alloc]init];
    [self addMJindex];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenself:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    
    _addressLable.text=[[NSString alloc]initWithFormat:@"%@  %@  %@  %@",[ZYUserDefaults stringForKey:Province],[ZYUserDefaults stringForKey:City],[ZYUserDefaults stringForKey:District],[ZYUserDefaults stringForKey:Street]];
}

-(void)viewWillAppear:(BOOL)animated{
    path=[NSString stringWithFormat:@"%@.info",CPUserId];
    user=[NSKeyedUnarchiver unarchiveObjectWithFile:path.documentPath];
    [self.navigationController.navigationBar setHidden:YES];
    if (user.isMan || !CPIsLogin) {
        [self.shuttleBtn setImage:[UIImage imageNamed:@"点击效果"] forState:UIControlStateNormal];
        self.whetherShuttle=@"1";
        [ZYUserDefaults setBool:YES forKey:Transfer];
    }else{
        [self.shuttleBtn setImage:[UIImage imageNamed:@"初始效果"] forState:UIControlStateNormal];
        self.whetherShuttle=@"0";
        [ZYUserDefaults setBool:NO forKey:Transfer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addMJindex{
    self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(190.0/320.0*ZYScreenWidth, 170.0, 100.0/320.0*ZYScreenWidth, 230.0)];
    //    }
    _indexView.dataSource = self;
    _indexView.fontColor = [Tools getColor:@"48d1d5"];
    _indexView.font = [UIFont systemFontOfSize:11.0f];
    _indexView.minimumGapBetweenItems = 0.f;
    _indexView.ergonomicHeight = NO;
    _indexView.selectedItemFontColor=[Tools getColor:@"48d1d5"];
    [self.view addSubview:_indexView];
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
//选择地址
- (IBAction)selectPlaceClick:(id)sender {
    _locationAddressView.alpha=1.0;
    _selectView.alpha=0.0;
    corentView=_locationAddressView;
}
//
- (IBAction)matchingBtnClick:(id)sender {
    if (CPIsLogin) {
        
        NSDictionary *estabPoint=[[NSDictionary alloc]initWithObjectsAndKeys:@([Tools getLongitude]),@"longitude",@([Tools getLatitude]),@"latitude", nil];
        
        NSDictionary *establish=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:Province],@"province",[ZYUserDefaults stringForKey:City],@"city",[ZYUserDefaults stringForKey:District],@"district",[ZYUserDefaults stringForKey:Street],@"street", nil];
//        NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType].type,@"majorType",@([ZYUserDefaults boolForKey:Transfer]),@"transfer",establish,@"establish",estabPoint,@"estabPoint",estabPoint,@"destPoint",establish,@"destination",majorType.type,@"type", nil];
//        NSString *path=[[NSString alloc]initWithFormat:@"activity/register?userId=%@&token=%@",[Tools getUserId],[Tools getToken]];
//        [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
//            if (CPSuccess) {
                _activity=[CPActivityModel new];
                _activity.destination=establish;
                _activity.destabPoint = estabPoint;
//                _activity.activityId=responseObject[@"data"];
                _activity.type=majorType.type;
                _activity.distance=0;
                _activity.transfer=[ZYUserDefaults boolForKey:Transfer];
                _activity.organizer = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@.info",CPUserId].documentPath];
                if ([_activity.organizer.album count]>0) {
                    CPAlbum *album=_activity.organizer.album[0];
                     _activity.organizer.cover=album.url;
                }else{
                    _activity.organizer.cover=_activity.organizer.avatar;
                }
                CPMatchingPreview *matchingPreview=[UIStoryboard storyboardWithName:@"CPMatchingPreview" bundle:nil].instantiateInitialViewController;
                matchingPreview.activity=_activity;
                [self.navigationController pushViewController:matchingPreview animated:YES];
//            }else{
//                NSString *errmsg =[responseObject objectForKey:@"errmsg"];
//                [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            }
//        } failed:^(NSError *error) {
//           [self showInfo:@"请检查您的手机网络!"];
//        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        CPTabBarController *tab = (CPTabBarController *)self.view.window.rootViewController;
        [ZYNotificationCenter postNotificationName:NOTIFICATION_STARTMATCHING object:nil];
        [tab setSelectedIndex:4];
    }
}

- (IBAction)closeLocatoinAddressView:(id)sender {
    _locationAddressView.alpha=0.0;
    _selectView.alpha=1.0;
    corentView=_selectView;
}

- (IBAction)confirm:(id)sender {
    _locationAddressView.alpha=0.0;
    _addressSelection.alpha=0.0;
    _selectView.alpha=1.0;
    _indexView.alpha=0.0;
    NSString *area=[[NSString alloc]initWithFormat:@"%@  %@  %@",[ZYUserDefaults stringForKey:City],[ZYUserDefaults stringForKey:District],[ZYUserDefaults stringForKey:Street]];
    [self.selectPlace setTitle:area forState:UIControlStateNormal];
    [self.selectPlace setImage:nil forState:UIControlStateNormal];
    [self.selectPlace setTitleColor:[Tools getColor:@"333333"] forState:UIControlStateNormal];
    [self.selectPlace setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    CGSize titleSize = [area sizeWithFont:ZYFont14 maxW:MAXFLOAT];
    if (titleSize.width > _selectPlace.width) {
        [self.selectPlace setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
}

- (IBAction)exerciseBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        self.lastTypebtn.selected = NO;
        sender.selected = YES;
        self.lastTypebtn = sender;
        switch (sender.tag) {
            case 1:
                majorType=@"足球";
                break;
            case 2:
                majorType=@"篮球";
                break;
            case 3:
                majorType=@"羽毛球";
                break;
            case 4:
                majorType=@"桌球";
                break;
            case 5:
                majorType=@"健身";
                break;
            default:
                break;
        }
    }
}

- (IBAction)reSelection:(id)sender {
    _locationAddressView.alpha=0.0;
    _addressSelection.alpha=1.0;
    _parentId=0;
    _indexView.alpha=1.0;
    corentView=_addressSelection;
    [lastParentIds removeAllObjects];
    [selectArea removeAllObjects];
    _locationAddressLable.text=[[NSString alloc]initWithFormat:@"%@  %@  %@  %@",[ZYUserDefaults stringForKey:Province],[ZYUserDefaults stringForKey:City],[ZYUserDefaults stringForKey:District],[ZYUserDefaults stringForKey:Street]];
    [self getArea];
}
- (IBAction)closeAddressSelectionView:(id)sender {
    _locationAddressView.alpha=1.0;
    _selectView.alpha=0.0;
    _addressSelection.alpha=0.0;
    _indexView.alpha=0.0;
    corentView=_locationAddressView;
    [lastParentIds removeAllObjects];
}

//获取省市列表
-(void)getArea{
    
    NSString *path=[[NSString alloc]initWithFormat:@"area/list?parentId=%ld",(long)_parentId];
    [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
        if (CPSuccess) {
            NSLog(@"%@",responseObject);
            [_areaListBeforeSort removeAllObjects];
            _areaListBeforeSort=[[NSMutableArray alloc]initWithArray:responseObject[@"data"]];
            if ([_areaListBeforeSort count]>0) {
                [self reloadData];
                [_addressTableView reloadData];
            }
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
        item._code=[_areaListBeforeSort objectAtIndex:i][@"code"];
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
    //进行排序后，加入到数据源中  先清空原来数据
    [self.areaList removeAllObjects];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getFirstName)]; //按firstName进行排序
        if ([sortedSection count]>0) {
            [self.areaList addObject:sortedSection];//这里friendsList是自己定义的列表数据源
        }
    }
    
    
    [self.addressTableView reloadData];
    [self.indexView refreshIndexItems];
}

#pragma UITableViewDataSource UITableViewDelegate
#pragma mark - IndexViewDataSource

- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView {
    
    NSMutableArray * existTitles = [NSMutableArray array];
    for (NSArray *nameIndex in self.areaList) {
        CPNameIndex *n = nameIndex.firstObject;
        char c = pinyinFirstLetter([n._lastName characterAtIndex:0]);
        NSString *s = [NSString stringWithFormat:@"%c",c-32];
        [existTitles addObject:s];
        
    }
    return existTitles;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if (self.areaList.count > 0) {
        NSIndexPath *scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:index];
        if (scrollIndexPath) {
            [_addressTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.areaList count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CPNameIndex *n = [self.areaList[section] firstObject];
    char c = pinyinFirstLetter([n._lastName characterAtIndex:0]);
    NSString *s = [NSString stringWithFormat:@"%c",c-32];
    return s;
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
    cell.textLabel.font = [UIFont systemFontOfSize:10.0];
    cell.textLabel.textColor=[Tools getColor:@"666666"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *code=[NSString stringWithFormat:@"%@",((CPNameIndex*)[[self.areaList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row])._code];
    NSString *area=[NSString stringWithFormat:@"%@",((CPNameIndex*)[[self.areaList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row])._lastName];
    if ([code length]<10 && lastParentId!=[code intValue]) {
        [lastParentIds addObject:@(_parentId)];
        lastParentId = [code intValue];
        _parentId=[code intValue];
        [selectArea addObject:area];
        self.lastStepBtn.hidden=NO;
        
        NSMutableString *areas=[[NSMutableString alloc]init];
        for (NSString *area in selectArea) {
            [areas appendFormat:@" %@ ",area];
        }
        if ([areas length]>0) {
            self.locationAddressLable.text=areas;
        }
        if ((lastParentId >1000000)) {
            _locationAddressView.alpha=0.0;
            _selectView.alpha=1.0;
            _addressSelection.alpha=0.0;
            _indexView.alpha=0.0;
            [self.selectPlace setTitle:areas forState:UIControlStateNormal];
            [self.selectPlace setImage:nil forState:UIControlStateNormal];
            [self.selectPlace setTitleColor:[Tools getColor:@"333333"] forState:UIControlStateNormal];
        }else{
            [self getArea];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != [self view]) {
        return NO;
    }
    return YES;
}

-(void)hidenself:(UITapGestureRecognizer *)tapGes{
    CGPoint p = [tapGes locationInView:tapGes.view];
    CGFloat topBottomY=corentView.y;
    CGFloat bottomTopY=corentView.y+corentView.height;
    
    if (CGRectContainsPoint(CGRectMake(0, 0, ZYScreenWidth, topBottomY), p) || CGRectContainsPoint(CGRectMake(0, bottomTopY, ZYScreenWidth, ZYScreenHeight-bottomTopY), p)) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.navigationController removeFromParentViewController];
            [self.navigationController.view removeFromSuperview];
        }];
    }
}

- (IBAction)lastStep:(id)sender {
    _parentId=[[lastParentIds lastObject] integerValue];
    [self getArea];
    [lastParentIds removeLastObject];
    lastParentId = [lastParentIds lastObject];
    [selectArea removeLastObject];
    if (![lastParentIds count]) {
        self.lastStepBtn.hidden=YES;
    }
}
@end
