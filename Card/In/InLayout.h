//
//  InLayout.h
//  Card
//
//  Created by LuYang on 16/2/23.
//  Copyright © 2016年 LuYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InLayout;

@protocol InLayoutDelegate <NSObject>
/**
 * 确定每个cell的长度
 */
- (NSArray *) itemHeightWithCollectionView:(UICollectionView *)collectionView
                 collectionViewLayout:(InLayout *)collectionViewLayout;

/**
 * 确定头尾View的大小
 */
-(CGSize) headerViewSizeWithCollectionView:(UICollectionView *)collectionView
                      collectionViewLayout:(InLayout *)collectionViewLayout;

-(CGSize) footerViewSizeWithCollectionView:(UICollectionView *)collectionView
                      collectionViewLayout:(InLayout *)collectionViewLayout;

@end

@interface InLayout : UICollectionViewLayout
@property (nonatomic, weak) id<InLayoutDelegate> layoutDelegate;
@end
