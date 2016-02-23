//
//  RootViewController.m
//  Card
//
//  Created by LuYang on 16/2/23.
//  Copyright © 2016年 LuYang. All rights reserved.
//

#import "RootViewController.h"
static NSString * const reuseCellIdentifier = @"RootCellID";
@interface RootViewController ()
@property (nonatomic,strong)NSArray *cellTitleArray;
@property (nonatomic,strong)NSArray *classNameArray;
@end

@implementation RootViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"卡片动画";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellIdentifier];
}

#pragma mark -- TableView Delegate DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellIdentifier];
    }
    cell.textLabel.text = self.cellTitleArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class pushClass = NSClassFromString(self.classNameArray[indexPath.row]);
    if ([pushClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *pushViewController = [[pushClass alloc] init];
        pushViewController.title = self.cellTitleArray[indexPath.row];
        [self.navigationController pushViewController:pushViewController animated:YES];
    }
}

#pragma mark -- Lazy Loading
-(NSArray *)cellTitleArray
{
    if (!_cellTitleArray) {
        _cellTitleArray = @[@"卡片层叠动画",@"仿in动态实现"];
    }
    return _cellTitleArray;
}

-(NSArray *)classNameArray
{
    if (!_classNameArray) {
        _classNameArray = @[@"CardCollectionViewController",@"InViewController"];
    }
    return _classNameArray;
}
@end
