//
//  CPBrandModelViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPBrandModelViewController.h"
#import "CustomBrandCell.h"
#import "CustomSlideCell.h"
#import "MJNIndexView.h"
#import "CustomSectionView.h"
#import "CPUser.h"

@interface CPBrandModelViewController ()<MJNIndexViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *brandArray;
    NSArray *modelArray;
    NSMutableDictionary *sortedBrandData;
    NSString *currentBrandName;
    NSString *currentBrandUrl;
    CPUser *user;
    NSString *path;
}

@end

@implementation CPBrandModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    brandArray=[[NSArray alloc]init];
    modelArray=[[NSArray alloc]init];
    path=[NSString stringWithFormat:@"%@.info",CPUserId];
    user=[NSKeyedUnarchiver unarchiveObjectWithFile:path.documentPath];
    sortedBrandData=[[NSMutableDictionary alloc]init];
    //隐藏视图
    self.modelSlideView = [UIView new];
    _modelSlideView.hidden = YES;
    _modelSlideView.userInteractionEnabled = YES;
    [self.view addSubview:_modelSlideView];
    _modelSlideView.frame = self.view.bounds;
    self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0, ZYScreenWidth, ZYScreenHeight-64)];
    _indexView.dataSource = self;
    _indexView.fontColor = [Tools getColor:@"aab2bd"];
    _indexView.font = [UIFont systemFontOfSize:11.0f];
    _indexView.minimumGapBetweenItems = 0.f;
    _indexView.ergonomicHeight = NO;
    _indexView.selectedItemFontColor=[Tools getColor:@"48d1d5"];
    [self.view addSubview:_indexView];
    
    // DetailsTbView
    
    self.modelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _modelTableView.sectionHeaderHeight=50.0f;
    _modelTableView.delegate = self;
    _modelTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _modelTableView.backgroundColor = [UIColor whiteColor];
    [_modelTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_modelSlideView addSubview:_modelTableView];
    _modelSlideView.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.8];
    _modelTableView.tableFooterView = [UIView new];
    self.modelTableView.frame=CGRectMake(60, 0, ZYScreenWidth-60, ZYScreenHeight-64);
    // 清扫手势
    
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    [_modelSlideView addGestureRecognizer:swipeGesture];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent=NO;
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _brandTableView) {
        return [CustomBrandCell standardHeight];
    }
    else if (tableView == _modelTableView){
        return [CustomSlideCell standardHeight];
    }
    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _brandTableView) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZYScreenWidth, 20)];
                imageview.backgroundColor = [Tools getColor:@"f5f7fa"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ZYScreenWidth, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.text = [brandArray objectAtIndex:section];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [Tools getColor:@"434a53"];
                [imageview addSubview:label];
                return imageview;
    } else {
        self.sectionView = [[CustomSectionView alloc] initWithFrame:CGRectMake(0, 0, _modelTableView.width, 50.0f)];
        if (currentBrandName) {
            _sectionView.CarName = currentBrandName;
            _sectionView.imageName=currentBrandUrl;
        }
        return _sectionView;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _brandTableView) {
            return [brandArray count];
        }else{
            return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _brandTableView)
    {
        return [[sortedBrandData objectForKey:[brandArray objectAtIndex:section]] count];
    }else {
            return [modelArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentify = @"BrandCellIdentify";
    static NSString *slideIdentify = @"SlideCellIdentify";
    
    if (tableView == _brandTableView) {
        CustomBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify];
        if (cell == nil) {
            cell = [[CustomBrandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentify];
        }
        NSArray *datas=[sortedBrandData objectForKey:[brandArray objectAtIndex:indexPath.section]];
        NSDictionary *cellData=[datas objectAtIndex:indexPath.row];
        if ([cellData objectForKey:@"logo_img"]) {
            [cell.thumbnailView zySetImageWithUrl:[cellData objectForKey:@"logo_img"] placeholderImage:nil];
        }
        
        if ([cellData objectForKey:@"name"]) {
            cell.brandNameLabel.text=[cellData objectForKey:@"name"];
        }
        return cell;
    }
    else if (tableView == _modelTableView) {
            CustomSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:slideIdentify];
            if (cell == nil) {
                cell = [[CustomSlideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:slideIdentify];
            }
        NSDictionary *data=[modelArray objectAtIndex:indexPath.row];
        if ([data objectForKey:@"name"]) {
            cell.carNameLabel.text =[data objectForKey:@"name"];
        }
            return cell;
        }
    return nil;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _brandTableView) {
        NSDictionary *data=[[sortedBrandData objectForKey:[brandArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        NSString *brandName =[data objectForKey:@"slug"];
        currentBrandName = [data objectForKey:@"name"];
        currentBrandUrl = [data objectForKey:@"logo_img"];
        user.car.brand=[data objectForKey:@"name"];
        user.car.slug=[data objectForKey:@"slug"];
        user.car.logo=[data objectForKey:@"logo_img"];
        [UIView animateWithDuration:0.25 animations:^{
            // 把第三层滚回去
            _modelSlideView.hidden = NO;
            _indexView.hidden=YES;
            _modelSlideView.frame = CGRectMake(0, 0, ZYScreenWidth, _brandTableView.height);
        }completion:^(BOOL finished) {
            [self getModelData:brandName];
        }];
    }
    else if (tableView == _modelTableView) {
        CustomSlideCell *cell = (CustomSlideCell *)[tableView cellForRowAtIndexPath:indexPath];
        user.car.model =cell.carNameLabel.text;
        [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - IndexViewDataSource

- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView {
    if ([brandArray count] > 0) {
        return brandArray;
    }
    return brandArray;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (brandArray.count > 0) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [_brandTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma privateMethods
-(void)getData{
    [ZYNetWorkTool getWithUrl:@"car/brand" params:nil success:^(id responseObject) {

        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if (![state isEqualToString:@"0"]) {
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            NSArray *brandData=[responseObject objectForKey:@"data"];
            for (NSDictionary *data in brandData) {
                NSString *first_letter=[data objectForKey:@"first_letter"];
                if ([sortedBrandData objectForKey:first_letter]) {
                    NSMutableArray *brands=[sortedBrandData objectForKey:first_letter];
                    [brands addObject:data];
                    [sortedBrandData setObject:brands forKey:first_letter];
                }else{
                    NSMutableArray *brands=[[NSMutableArray alloc]initWithObjects:data, nil];
                    [sortedBrandData setObject:brands forKey:first_letter];
                }
            }
            NSArray *keys = [sortedBrandData allKeys];
            brandArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            
//            brandArray=[sortedBrandData allValues];
            [self.brandTableView reloadData];
            [self.indexView refreshIndexItems];
        }
    } failure:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

-(void)getModelData:(NSString *)model{

//    NSString *path=[[NSString alloc]initWithFormat:@"v1/car/model",model];
    NSDictionary *para=[[NSDictionary alloc]initWithObjectsAndKeys:model,@"brand", nil];
    [ZYNetWorkTool getWithUrl:@"car/model" params:para success:^(id responseObject) {
      
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if (![state isEqualToString:@"0"]) {
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            modelArray=[responseObject objectForKey:@"data"];
            [self.modelTableView reloadData];
        }
    } failure:^(NSError *error) {
    
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
    }];
}

- (void)handleSwipes:(UIPanGestureRecognizer *)swipe
{
    
    CGPoint p = [swipe translationInView:_modelSlideView];
    switch (swipe.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            _modelSlideView.x+=p.x;
            if (_modelSlideView.x > ZYScreenWidth) {
                _modelSlideView.x = ZYScreenWidth;
            }else if (_modelSlideView.x < 0){
                _modelSlideView.x = 0;
            }
            break;
        }
        case UIGestureRecognizerStateCancelled :
        case UIGestureRecognizerStateEnded:
        {
            if (_modelSlideView.x > ZYScreenWidth * 0.4) {
                [UIView animateWithDuration:0.25 animations:^{
                    _modelSlideView.x = ZYScreenWidth;
                }completion:^(BOOL finished) {
                    _indexView.hidden = NO;
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    _modelSlideView.x = 0;
                }];
            }
            break;
        }
        default:
            break;
    }
    [swipe setTranslation:CGPointZero inView:swipe.view];
}

@end
