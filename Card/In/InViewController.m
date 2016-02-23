//
//  InViewController.m
//  Card
//
//  Created by LuYang on 16/2/23.
//  Copyright © 2016年 LuYang. All rights reserved.
//

#import "InViewController.h"
#import "InLayout.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
static NSString * const reuseCellIdentifier = @"cardCellID";
static NSString * const reuseHeaderIdentifier = @"cardHeaderID";
static NSString * const reuseFooterIdentifier = @"cardFooterID";
@interface InViewController ()<InLayoutDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) InLayout *cardLayout;
@end

@implementation InViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"仿In动态显示动画";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    InLayout *inLayout = [InLayout new];
    inLayout.layoutDelegate = self;
    UICollectionView *cardCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT-64) collectionViewLayout:inLayout];
    cardCollectionView.layer.masksToBounds = NO;
    cardCollectionView.dataSource = self;
    cardCollectionView.backgroundColor = [UIColor whiteColor];
    cardCollectionView.pagingEnabled = NO;
    cardCollectionView.bounces = YES;
    [cardCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [cardCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    [cardCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
    [self.view addSubview:cardCollectionView];

}

#pragma mark <LayoutDelegate>

- (NSArray *)itemHeightWithCollectionView:(UICollectionView *)collectionView
                collectionViewLayout:(InLayout *)collectionViewLayout {
    /*
     *每个cell高度最小为整个屏幕正好显示下,即collectionView的长度
     *会有个布局计算,返回每个cell的高度,数组添加后返回
     *这边模拟下
     */
    CGFloat minHeight = collectionView.frame.size.height;
    NSMutableArray *heightArray = [[NSMutableArray alloc]initWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {
        minHeight += i*100;
        [heightArray addObject:[NSNumber numberWithFloat:minHeight]];
    }
    return heightArray;
}

-(CGSize)headerViewSizeWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(InLayout *)collectionViewLayout
{
    return CGSizeMake(SCREEN_WIDTH,65.f);
}

-(CGSize)footerViewSizeWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(InLayout *)collectionViewLayout
{
    return CGSizeMake(SCREEN_WIDTH,65.f);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    UIColor *bgColor;
    switch (indexPath.row) {
        case 0:
            bgColor = [UIColor yellowColor];
            break;
        case 1:
            bgColor = [UIColor blueColor];
            break;
        default:
            bgColor = [UIColor redColor];
            break;
    }
    [cell setBackgroundColor:bgColor];
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
