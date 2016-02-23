//
//  CardCollectionViewController.m
//  Card
//
//  Created by LuYang on 16/2/17.
//  Copyright © 2016年 LuYang. All rights reserved.
//

#import "CardCollectionViewController.h"
#import "CardViewLayout.h"
#import "CardViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
static NSString * const reuseCellIdentifier = @"cardCellID";
static NSString * const reuseHeaderIdentifier = @"cardHeaderID";
static NSString * const reuseFooterIdentifier = @"cardFooterID";

@interface CardCollectionViewController()<CardViewLayoutDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) CardViewLayout *cardLayout;
@end
@implementation CardCollectionViewController
{
    CGFloat cellHeight;
    CGFloat widthMargin;
    CGFloat heightMargin;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡片动画";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    cellHeight = 530.f;
    widthMargin = 20.f;
    heightMargin = 8.f;
    
    CardViewLayout *cardLayout = [CardViewLayout new];
    cardLayout.layoutDelegate = self;
    UICollectionView *cardCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,cellHeight) collectionViewLayout:cardLayout];
    cardCollectionView.layer.masksToBounds = NO;
    cardCollectionView.dataSource = self;
    cardCollectionView.backgroundColor = [UIColor whiteColor];
    cardCollectionView.pagingEnabled = YES;
    cardCollectionView.bounces = YES;
    [cardCollectionView registerClass:[CardViewCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [cardCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    [cardCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
    
    [self.view addSubview:cardCollectionView];
}

#pragma mark <LayoutDelegate>

- (CGSize)itemSizeWithCollectionView:(UICollectionView *)collectionView
                collectionViewLayout:(CardViewLayout *)collectionViewLayout {
    return CGSizeMake(SCREEN_WIDTH,cellHeight);
}

- (CGFloat)marginHeightWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CardViewLayout *)collectionViewLayout
{
    return heightMargin;
}

-(CGFloat)marginWidthSizeWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CardViewLayout *)collectionViewLayout
{
    return widthMargin;
}

-(NSInteger)showsPagesWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CardViewLayout *)collectionViewLayout
{
    return 3;
}

-(CGSize)headerViewSizeWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CardViewLayout *)collectionViewLayout
{
    return CGSizeMake(SCREEN_WIDTH,65.f);
}

-(CGSize)footerViewSizeWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CardViewLayout *)collectionViewLayout
{
    return CGSizeMake(SCREEN_WIDTH,65.f);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"00%ld.jpg",indexPath.row];
    [cell setImage:imageName];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        view.backgroundColor = [UIColor greenColor];
        return view;
    }
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseFooterIdentifier forIndexPath:indexPath];
    view.backgroundColor = [UIColor grayColor];
    return view;
}
@end
