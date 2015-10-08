//
//  ViewController.m
//  Masary不定行高
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry/Masonry.h"
#import "ZYTableViewCell.h"
// 定义这个宏可以使用一些更简洁的方法
#define MAS_SHORTHAND
#define ImageName(__imageName) [UIImage imageNamed:__imageName];
// 定义这个宏可以使用自动装箱功能
#define MAS_SHORTHAND_GLOBALS
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSCache *cellHeight;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation ViewController

- (NSArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        [_datas addObject:@"dfs;adsfjklasdjflkajsdflkjaslkdflasdkhflkadjfkljadslfjaldfjklasdjfslkdflasdkhflkadjfkljadslfjaldfjklasdjfkladjsfklasdjfkldafjklasdjkladfjadsklfjadfskljdfsa"];
                [_datas addObject:@"dfs;adsfjklasdjflkajsdflkjaslkdflasdkhflkadjfkljadslfjaldfjklasdjfslkdflasdkhflkadjfkljadslfjaldfjklasdjfkladjsfklasdjfkldafjklasdjkladfjadsklfjadfskljdfsa"];
                [_datas addObject:@"dfs;adsfjklasdjflkajsdflkjaslkdflasdkhflkadjfkljadslfjaldfjklasdjfslkdflasdkhflkadjfkljadslfjaldfjklasdjfkladjsfklasdjfkldafjklasdjkladfjadsklfjadfskljdfsa"];
                [_datas addObject:@"dfs;adsfjklasdjflkajsdflkjaslkdflasdkhflkadjfkljadslfjaldfjklasdjfslkdflasdkhflkafjklasdjkladfjadsklfjadfskljdfsa"];
                [_datas addObject:@"dfs;adsfjklasdjflkfjadfskljdfsa"];
                [_datas addObject:@"dfs;adsfjklasdjflkadjfkljadslfjaldfjklasdjfkladjsfklasdjfkldafjklasdjkladfjadsklfjadfskljdfsa"];
                [_datas addObject:@"dfs;adsfjklasdjflkajsdflkjaslkdflasdkhflkadjfkljadslfjaldfjklasdjfslkdflasdkhflkadjfkljadslfjaldfjklasdjfkladjsfklasdjfkldafjklasdjkladfjadsklfjadfskljdfsa"];
    }
    return _datas;
}

- (NSCache *)cellHeight
{
    if (_cellHeight == nil) {
        _cellHeight = [NSCache new];

    }
    return _cellHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero]);
    }];
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@64);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    ZYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.text = self.datas[indexPath.row];
    [self.cellHeight setObject:@(cell.cellHeight) forKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellH = [self.cellHeight objectForKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
    if (cellH) {
        NSLog(@"缓存高度不用算");
        return [cellH floatValue];
    }
    ZYTableViewCell *cell = (ZYTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    [self.cellHeight setObject:@(cell.cellHeight) forKey:[NSString stringWithFormat:@"%zd",indexPath.row]];
    NSLog(@"计算高度效率差");
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
