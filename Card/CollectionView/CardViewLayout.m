//
//  CardViewLayout.m
//  testApp
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CardViewLayout.h"
static CGFloat Animation_Scale = 0.5;
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface CardViewLayout()
@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) NSInteger numberOfCellsInSection;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize headerSize;
@property (nonatomic) CGSize footerSize;
@property (nonatomic) CGFloat itemMarginWidth;
@property (nonatomic) CGFloat itemMarginHeight;
@property (nonatomic, strong) NSMutableArray *itemsY;
@property (nonatomic, strong) NSMutableArray *itemsScale;
@property (nonatomic)NSInteger showPages;
@end
@implementation CardViewLayout
#pragma mark -- UICollectionViewLayout 重写的方法
- (void)prepareLayout {
    [super prepareLayout];
    
    [self initData];
    
    [self initItems];
}

/**
 * 该方法返回CollectionView的ContentSize的大小
 */
-(CGSize)collectionViewContentSize {
    return CGSizeMake(SCREEN_WIDTH,  _itemSize.height*_numberOfCellsInSection + _footerSize.height);
}


/**
 * 该方法为每个Cell绑定一个Layout属性~
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *array = [NSMutableArray array];
    
    //add cells
    for (int i = 0; i < _numberOfCellsInSection; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [array addObject:attributes];
    }
    
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:headerIndexPath];
    [array addObject:headerAttributes];
    
    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:_numberOfCellsInSection - 1 inSection:0];
    UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:footerIndexPath];
    [array addObject:footerAttributes];
    return array;
}


/**
 * 为每个Cell设置attribute
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前Cell的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //获取滑动的位移
    CGFloat contentOffsetY = self.collectionView.contentOffset.y;
    NSInteger currentIndex = contentOffsetY/_itemSize.height;
    NSInteger startIndex = indexPath.row - currentIndex;
    if (indexPath.row >= currentIndex) {
        //获取Cell的X坐标
        CGFloat centerX = SCREEN_WIDTH/2;
        //计算Cell的Y坐标
        CGFloat centerY = [_itemsY[startIndex] floatValue] + contentOffsetY;
        //设置ratio用于做动画
        CGFloat ratio = (contentOffsetY - currentIndex*_itemSize.height)/(_itemSize.height*Animation_Scale);
        if (ratio >= 1) {
            ratio = 1.f;
        }
        //设置Cell的center和size属性
        //当前页面后两张做动画
        if ((startIndex == 1 || startIndex == 2) && contentOffsetY > 0) {
            attributes.size = CGSizeMake(SCREEN_WIDTH, _itemSize.height);
            CGFloat heightChange = [_itemsY[startIndex] floatValue] - [_itemsY[startIndex - 1] floatValue];
            attributes.center = CGPointMake(centerX, centerY - heightChange*ratio);
            CGFloat scaleChange = [_itemsScale[startIndex - 1] floatValue] - [_itemsScale[startIndex] floatValue];
            attributes.transform = CGAffineTransformMakeScale([_itemsScale[startIndex] floatValue] + scaleChange*ratio, [_itemsScale[startIndex] floatValue] + scaleChange*ratio);
        }
        else
        {
            attributes.size = CGSizeMake(SCREEN_WIDTH, _itemSize.height);
            attributes.center = CGPointMake(centerX, centerY);
            attributes.transform = CGAffineTransformMakeScale([_itemsScale[startIndex] floatValue], [_itemsScale[startIndex] floatValue]);
        }
        attributes.zIndex = 10000 - indexPath.row;
    }
    if (indexPath.row == currentIndex || contentOffsetY < 0) {
        //attributes.transform = CGAffineTransformMakeTranslation(0,-(contentOffsetY - currentIndex*_itemSize.height));
        attributes.transform = CGAffineTransformTranslate(attributes.transform, 0, -(contentOffsetY - currentIndex*_itemSize.height));
    }
    return attributes;
}

/**
 * 为每个Header和footer设置attribute
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        attributes.frame = CGRectMake(0,-_headerSize.height,_headerSize.width,_headerSize.height);
    }else if (elementKind == UICollectionElementKindSectionFooter) {
        attributes.frame = CGRectMake(0, self.collectionView.contentSize.height - _headerSize.height,_headerSize.width,_headerSize.height);
    }
    
    return attributes;
}

//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//修正Cell的位置，使当前Cell显示在屏幕的中心
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    NSInteger currentIndex = proposedContentOffset.y/_itemSize.height;
    if (proposedContentOffset.y - currentIndex*_itemSize.height > Animation_Scale*_itemSize.height) {
        proposedContentOffset.y = (currentIndex + 1)*_itemSize.height;
    }
    return proposedContentOffset;
}





#pragma mark -- 自定义的方法
/**
 * 初始化私有属性，通过代理获取配置参数
 */
- (void) initData{
    _numberOfSections = self.collectionView.numberOfSections;
    
    _numberOfCellsInSection = [self.collectionView numberOfItemsInSection:0];
    
    _itemSize = [_layoutDelegate itemSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _itemMarginHeight = [_layoutDelegate marginHeightWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _itemMarginWidth = [_layoutDelegate marginWidthSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _showPages = [_layoutDelegate showsPagesWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _headerSize = [_layoutDelegate headerViewSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _footerSize = [_layoutDelegate footerViewSizeWithCollectionView:self.collectionView collectionViewLayout:self];
}

/**
 * 计算每个Cell的Y坐标和缩放比例
 */
- (void) initItems
{
    _itemsY = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSection];
    _itemsScale = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSection];
    
    for (int i = 0; i < _numberOfCellsInSection; i ++) {
        CGFloat tempScale = (i >= _showPages)?((_itemSize.width - 2*_itemMarginWidth)/_itemSize.width):((_itemSize.width - i*_itemMarginWidth)/_itemSize.width);
        [_itemsScale addObject:@(tempScale)];
        
        CGFloat scaleHeight = (1 - tempScale)/2*(_itemSize.height);
        
        CGFloat tempY = (i >= _showPages)?(_itemSize.height/2+2*_itemMarginHeight + scaleHeight):(_itemSize.height/2 + i*_itemMarginHeight + scaleHeight);
        [_itemsY addObject:@(tempY)];
    }
}
@end
