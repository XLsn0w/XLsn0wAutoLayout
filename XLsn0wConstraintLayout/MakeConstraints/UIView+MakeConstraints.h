
#import <UIKit/UIKit.h>

@class XLsn0wConstraintsMaker;

#pragma mark - UIView 设置约束、更新约束、清空约束、从父view移除并清空约束、开启cell的frame缓存等相关方法

@interface UIView (MakeConstraints)

///Make Constraints To Layout
- (XLsn0wConstraintsMaker *)make;

- (XLsn0wConstraintsMaker *)resetConstraints;
- (XLsn0wConstraintsMaker *)newConstraints;


/** 从父view移除并清空约束  */
- (void)removeFromSuperviewAndClearAutoLayoutSettings;

/** 清空之前的自动布局设置  */
- (void)clearAutoLayoutSettings;

/** 将自身frame清零（一般在cell内部控件重用前调用）  */
- (void)clearViewFrameCache;

/** 将自己的需要自动布局的subviews的frame(或者frame缓存)清零  */
- (void)clearSubviewsAutoLayoutFrameCaches;

/** 设置固定宽度保证宽度不在自动布局过程再做中调整  */
@property (nonatomic, strong) NSNumber *fixedWidth;

/** 设置固定高度保证高度不在自动布局过程中再做调整  */
@property (nonatomic, strong) NSNumber *fixedHeight;

/** 启用cell frame缓存（可以提高cell滚动的流畅度, 目前为cell专用方法，后期会扩展到其他view） */
- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview;


- (NSMutableArray *)autoLayoutModelsArray;
- (void)addAutoLayoutModel:(XLsn0wConstraintsMaker *)model;

@property (nonatomic) XLsn0wConstraintsMaker *ownLayoutModel;
@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *autoHeightRatioValue;
@property (nonatomic, strong) NSNumber *autoWidthRatioValue;


@end
