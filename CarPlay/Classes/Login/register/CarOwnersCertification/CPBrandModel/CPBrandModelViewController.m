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
#import "CPMySubscribeModel.h"
#import "MJNIndexView.h"
#import "CustomSectionView.h"

@interface CPBrandModelViewController ()<MJNIndexViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *brandArray;
    NSArray *modelArray;
    NSMutableDictionary *sortedBrandData;
    NSString *currentBrandName;
    NSString *currentBrandUrl;
    CPOrganizer *organizer;
}

@end

@implementation CPBrandModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    brandArray=[[NSArray alloc]init];
    modelArray=[[NSArray alloc]init];
    
//    NSInteger index = 1;
//    self.indexPathNumberArray = [NSMutableArray array];
//    if (self.type != SelectBrandTypeReckon && self.type != SelectBrandTypeModel) {
//        [brandArray addObject:@[[NSNull null]]];
//        [brandArray addObject:@"#"];
//        [_indexPathNumberArray addObject:@(index++)];
//    }
//    for (char c = 'A'; c <= 'Z'; c++) {
//        NSString *initial = [NSString stringWithFormat:@"%c", c];
//        NSArray *brand = [NSMutableArray arrayWithArray:[Interface brandsWithFirstLetter:initial]];
//        if (brand.count > 0) {
//            [self.allBrands addObject:brand];
//            [brandArray addObject:initial];
//            [_indexPathNumberArray addObject:@(index++)];
//        }
//    }
    
    sortedBrandData=[[NSMutableDictionary alloc]init];
//    if (!_fromMy || ![_fromMy isEqualToString:@"1"]) {
//        self.brandTableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
//    }
    //隐藏视图
    self.modelSlideView = [UIView new];
    _modelSlideView.hidden = YES;
    _modelSlideView.userInteractionEnabled = YES;
    [self.view addSubview:_modelSlideView];
    [_modelSlideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
    }];
//    [_modelSlideView setFrame:CGRectMake(60.0f, 0, SCREEN_WIDTH-60.0f,SCREEN_HEIGHT)];
    
    // 第三方控件视图我就不修改了
//    if (!_fromMy || ![_fromMy isEqualToString:@"1"]) {
//        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
//    }else{
        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    }
    _indexView.dataSource = self;
    _indexView.fontColor = [Tools getColor:@"aab2bd"];
    _indexView.font = [UIFont systemFontOfSize:11.0f];
    _indexView.minimumGapBetweenItems = 0.f;
    _indexView.ergonomicHeight = NO;
    _indexView.selectedItemFontColor=[Tools getColor:@"48d1d5"];
    [self.view addSubview:_indexView];
    
    // DetailsTbView
    
    self.modelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    _modelTableView.bounces = NO;
    _modelTableView.sectionHeaderHeight=50.0f;
    _modelTableView.delegate = self;
    _modelTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _modelTableView.backgroundColor = [UIColor whiteColor];
    [_modelTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_modelSlideView addSubview:_modelTableView];
    _modelSlideView.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.8];
    _modelTableView.tableFooterView = [UIView new];
//    [_modelTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_modelSlideView).with.insets(UIEdgeInsetsMake(66.0f, 0.5f, 0.0f, 0.0f));
//    }];
//    if (!_fromMy || ![_fromMy isEqualToString:@"1"]) {
//        self.modelTableView.frame=CGRectMake(60, 64, SCREEN_WIDTH-60, SCREEN_HEIGHT-64);
//    }else{
        self.modelTableView.frame=CGRectMake(60, 0, SCREEN_WIDTH-60, SCREEN_HEIGHT);
//    }
    // 清扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    swipeGesture.numberOfTouchesRequired = 1;
    [_modelSlideView addGestureRecognizer:swipeGesture];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent=NO;
    organizer = [NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(_fileName)];
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
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
                imageview.backgroundColor = [Tools getColor:@"f5f7fa"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth, 20)];
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
            NSURL *url=[[NSURL alloc]initWithString:[cellData objectForKey:@"logo_img"]];
            [cell.thumbnailView sd_setImageWithURL:url];
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
        
//        if ((indexPath.row == 0) && (self.type == SelectBrandTypeBuyCar)) {
//            cell.picImage.image = [UIImage imageNamed:@"kuanxingbuxian"];
//            cell.picImage.contentMode = UIViewContentModeScaleAspectFit;
//     }
//        NSURL *url=[[NSURL alloc]initWithString:[cellData objectForKey:@"logo_img"]];
        
//        if ([data objectForKey:@"name"]) {
//            cell.picImage sd_setImageWithURL
//        }
        
//            if (_slugString) {
//                NSString * brandSlug = [[[MD_DataBaseTool findAllObject:[brand_json class] conditions:@"name=?" args:[NSArray arrayWithObject:_slugString] order:nil] lastObject] slug];
//                
//                NSMutableArray * logoImages =[NSMutableArray arrayWithArray:[MD_DataBaseTool findAllObject:[model_json class] conditions:@"parent=?" args:[NSArray arrayWithObject:brandSlug] order:nil]];
//                if (self.type == SelectBrandTypeBuyCar) {
//                    [logoImages insertObject:@"不限车型" atIndex:0];
//                }
//                
//                if ((indexPath.row == 0) && (self.type == SelectBrandTypeBuyCar)) {
//                    cell.carNameLabel.text = [logoImages objectAtIndex:indexPath.row];
//                    cell.picImage.image = [UIImage imageNamed:@"kuanxingbuxian"];
//                    cell.picImage.contentMode = UIViewContentModeScaleAspectFit;
//                    
//                }else{
//                    
//                    if ([logoImages[indexPath.row] thumbnail].length==0 || [[logoImages[indexPath.row] thumbnail] isEqualToString:@""]) {
//                        [cell.picImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kImageHost,logoImageURL,kPlaceholder]]];
//                    }
//                    else {
//                        [cell.picImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kImageHost,logoImageURL,[logoImages[indexPath.row] thumbnail]]]];
//                    }
//                    
//                    cell.carNameLabel.text = [logoImages[indexPath.row] name];
//                }
//            }
            return cell;
        }
    return nil;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _brandTableView) {
        CustomBrandCell *cell = (CustomBrandCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *data=[[sortedBrandData objectForKey:[brandArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        NSString *brandName =[data objectForKey:@"slug"];
        currentBrandName = [data objectForKey:@"name"];
        currentBrandUrl = [data objectForKey:@"logo_img"];
        [Tools setValueForKey:currentBrandName key:@"brandName"];
        [Tools setValueForKey:currentBrandUrl key:@"brandUrl"];
        [UIView animateWithDuration:0.25 animations:^{
            // 把第三层滚回去
            _modelSlideView.hidden = NO;
            _indexView.hidden=YES;
            _modelSlideView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _brandTableView.height);
        }];
        [self getModelData:brandName];
    }
    else if (tableView == _modelTableView) {
        CustomSlideCell *cell = (CustomSlideCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *modelName = cell.carNameLabel.text;
        [Tools setValueForKey:modelName key:@"modelName"];
        NSString *slug=[[modelArray objectAtIndex:indexPath.row] objectForKey:@"slug"];
        [Tools setValueForKey:slug key:@"slug"];
        organizer.carModel = modelName;
        organizer.slug = slug;
        [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(_fileName)];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return brandArray;
//}


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
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.labelText=@"加载中…";
    hud.dimBackground=NO;
    
    [ZYNetWorkTool getWithUrl:@"v1/car/brand" params:nil success:^(id responseObject) {
        [hud hide:YES];
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
        [hud hide:YES];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
    }];
}

-(void)getModelData:(NSString *)model{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.labelText=@"加载中…";
    hud.dimBackground=NO;
//    NSString *path=[[NSString alloc]initWithFormat:@"v1/car/model",model];
    NSDictionary *para=[[NSDictionary alloc]initWithObjectsAndKeys:model,@"brand", nil];
    [ZYNetWorkTool getWithUrl:@"v1/car/model" params:para success:^(id responseObject) {
        [hud hide:YES];
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
        [hud hide:YES];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
    }];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.25 animations:^{
            // 如果拖动model，则detail也要一起滚
            [swipe.view setX:SCREEN_WIDTH];
            _indexView.hidden=NO;
        }];
    }
}

@end
