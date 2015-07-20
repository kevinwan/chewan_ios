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
#import <SDWebImage/UIImageView+WebCache.h>

@interface CPBrandModelViewController ()
{
    NSArray *brandArray;
    NSMutableDictionary *sortedBrandData;
}

@end

@implementation CPBrandModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    brandArray=[[NSArray alloc]init];
    sortedBrandData=[[NSMutableDictionary alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == _brandTableView) {
//        return [CustomBrandCell standardHeight];
//        return 60;
//    }
//    else if (tableView == _modelTableView){
//        return [CustomSlideCell standardHeight];
        return 50;
//    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _brandTableView) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
                imageview.backgroundColor = [UIColor redColor];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.text = [brandArray objectAtIndex:section];
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [Tools getColor:@"aab3bd"];
                [imageview addSubview:label];
                return imageview;
    } else {
//        self.sectionView = [[CustomSectionView alloc] initWithFrame:CGRectMake(0, 0, _modelTableView.width, 50.0f)];
//        if (_slugString) {
//            _sectionView.CarName = _slugString;
//            _sectionView.imageName = [(brand_json *)[[MD_DataBaseTool findAllObject:[brand_json class] conditions:@"name=?" args:[NSArray arrayWithObject:_slugString] order:Nil] lastObject] logo_img];
            return nil;
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
            return 0;
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
        
        // 对不限品牌稍微特殊处理一下
//        if ((indexPath.section == 1) && (self.type != SelectBrandTypeReckon) && (self.type != SelectBrandTypeModel)) {
//            cell.brandNameLabel.text = @"不限品牌";
//            cell.thumbnailView.image = [UIImage imageNamed:@"pinpaibiao"] ;
//        }else {
//            NSInteger index = indexPath.section;
//            if (index >= 1) {
//                [cell.thumbnailView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kImageHost,logoImageURL,[self.allBrands[index-1][indexPath.row] logo_img]]]];
//                cell.brandNameLabel.text = [self.allBrands[index-1][indexPath.row] name];
//            }
//        }
        return cell;
    }
    else if (tableView == _modelTableView) {
            CustomSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:slideIdentify];
            if (cell == nil) {
                cell = [[CustomSlideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:slideIdentify];
            }
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == _brandTableView) {
//        CustomBrandCell *cell = (CustomBrandCell *)[tableView cellForRowAtIndexPath:indexPath];
//        NSString *brandName = cell.brandNameLabel.text;
//        if (self.type == SelectBrandTypeBusiness || self.type == SelectBrandTypeBuyCar) {
//            if ([brandName isEqualToString:@"不限品牌"]) {
//                if (self.selectBrandBlock) {
//                    self.selectBrandBlock(@"", @"", @"", @"不限品牌", @"", @"");
//                }
//                return;
//            }
//            else {
//                // 如果是商家此时就要直接返回了
//                if (self.type == SelectBrandTypeBusiness) {
//                    if (self.selectBrandBlock) {
//                        NSArray *dataArray = [MD_DataBaseTool findAllObject:[brand_json class] conditions:@"name=?" args:[NSArray arrayWithObject:brandName] order:nil];
//                        self.selectBrandBlock([[dataArray lastObject] slug], @"", @"", brandName, @"", @"");
//                    }
//                    return;
//                }
//            }
//        }
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            // 把第三层滚回去
//            _detailSlideView.x = self.view.width;
//            _modelSlideView.hidden = NO;
//            _modelSlideView.frame = CGRectMake(60, _topView.top, kScreenWidth - 60, _brandTableView.height);
//        }];
//        self.slugString = brandName;
//        [_modelTableView reloadData];
//    }
//    else if (tableView == _modelTableView) {
//        CustomSlideCell *cell = (CustomSlideCell *)[tableView cellForRowAtIndexPath:indexPath];
//        NSString *modelName = cell.carNameLabel.text;
 
//            NSArray *dataArray = [MD_DataBaseTool findAllObject:[model_json class] conditions:@"name=?" args:@[modelName] order:nil];
//            NSString *brand = [[dataArray lastObject] parent];
//            NSString *model = [[dataArray lastObject] slug];
//            if (self.type == SelectBrandTypeBuyCar || self.type == SelectBrandTypeModel) {
//                if (self.selectBrandBlock) {
//                    self.selectBrandBlock(brand, model, @"", modelName, @"", @"");
//                    return;
//                }
//            }
//            // 否则直接展示新的分类界面
//            [self.view showWaitWithMessage:@"加载中..."];
//            // 此时也应该清空之前可能有的过滤条件
//            _selectedControl = @"";
//            _selectedVolume = @"";
//            _brand = brand;
//            _model = model;
//            [GPJNetworkAdapter detailModelQueryWithBrandBrand:brand model:model successBlock:^(id responseData) {
//                [self.view hideWait];
//                NSDictionary *dic = (NSDictionary *)responseData;
//                if ([dic operationSuccess]) {
//                    _rawDetails = [dic objectForKey:@"detail_model"];
//                    [UIView animateWithDuration:0.25 animations:^{
//                        _detailSlideView.hidden = NO;
//                        _detailSlideView.frame = CGRectMake(120, _topView.top, kScreenWidth - 120, _brandTableView.height);
//                    }];
//                    [self filterRawDetailsDisplayAllVolume:YES];
//                    [_detailTableView reloadData];
//                }
//                else {
//                    [self.view alert:@"没有找到对应的款型"];
//                }
//            } failBlock:^(NSString *errorDescription) {
//                [self.view alertError:errorDescription];
//            }];
//        
//    }
//}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return brandArray;
}


#pragma mark - IndexViewDataSource

//- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView {
//    
//    if (_indexPathArray.count > 0) {
//        
//        return _indexPathArray;
//    }
//    return nil;
//}


//- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (_indexPathNumberArray.count > 0) {
//        [_brandTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection: [_indexPathNumberArray[index] integerValue]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}




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
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
    }];
}

@end
