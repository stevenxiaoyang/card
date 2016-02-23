//
//  CardViewLayout.h
//  testApp
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardViewLayout;

@protocol CardViewLayoutDelegate <NSObject>
/**
 * 确定cell的大小
 */
- (CGSize) itemSizeWithCollectionView:(UICollectionView *)collectionView
                 collectionViewLayout:(CardViewLayout *)collectionViewLayout;

/**
 * 确定cell高度间距
 */
- (CGFloat) marginHeightWithCollectionView:(UICollectionView *)collectionView
                      collectionViewLayout:(CardViewLayout *)collectionViewLayout;

/**
 * 确定cell宽度间距
 */
- (CGFloat) marginWidthSizeWithCollectionView:(UICollectionView *)collectionView
                         collectionViewLayout:(CardViewLayout *)collectionViewLayout;

/**
 * 确定cell显示张数
 */
- (NSInteger) showsPagesWithCollectionView:(UICollectionView *)collectionView
                      collectionViewLayout:(CardViewLayout *)collectionViewLayout;;


/**
 * 确定头尾View的大小
 */
-(CGSize) headerViewSizeWithCollectionView:(UICollectionView *)collectionView
                      collectionViewLayout:(CardViewLayout *)collectionViewLayout;

-(CGSize) footerViewSizeWithCollectionView:(UICollectionView *)collectionView
                      collectionViewLayout:(CardViewLayout *)collectionViewLayout;

@end

@interface CardViewLayout : UICollectionViewLayout
@property (nonatomic, weak) id<CardViewLayoutDelegate> layoutDelegate;
@end
