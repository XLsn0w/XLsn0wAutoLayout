
#import <UIKit/UIKit.h>

@class XLsn0wConstraintsMaker;

#pragma mark - UIView 设置约束、更新约束、清空约束、从父view移除并清空约束、开启cell的frame缓存等相关方法

@interface UIView (MakeConstraints)

/** 开始自动布局  */
- (XLsn0wConstraintsMaker *)makeConstraints;

/** 清空之前的自动布局设置，重新开始自动布局(重新生成布局约束并使其在父view的布局序列数组中位置保持不变)  */
- (XLsn0wConstraintsMaker *)sd_resetLayout;

/** 清空之前的自动布局设置，重新开始自动布局(重新生成布局约束并添加到父view布局序列数组中的最后一个位置)  */
- (XLsn0wConstraintsMaker *)sd_resetNewLayout;

/** 是否关闭自动布局  */
//@property (nonatomic, getter = sd_isClosingAutoLayout) BOOL sd_closeAutoLayout;

/** 从父view移除并清空约束  */
- (void)removeFromSuperviewAndClearAutoLayoutSettings;

/** 清空之前的自动布局设置  */
- (void)sd_clearAutoLayoutSettings;

/** 将自身frame清零（一般在cell内部控件重用前调用）  */
- (void)sd_clearViewFrameCache;

/** 将自己的需要自动布局的subviews的frame(或者frame缓存)清零  */
- (void)sd_clearSubviewsAutoLayoutFrameCaches;

/** 设置固定宽度保证宽度不在自动布局过程再做中调整  */
@property (nonatomic, strong) NSNumber *fixedWidth;

/** 设置固定高度保证高度不在自动布局过程中再做调整  */
@property (nonatomic, strong) NSNumber *fixedHeight;

/** 启用cell frame缓存（可以提高cell滚动的流畅度, 目前为cell专用方法，后期会扩展到其他view） */
- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview;

/** 所属tableview（目前为cell专用属性，后期会扩展到其他view） */
@property (nonatomic) UITableView *sd_tableView;

/** cell的indexPath（目前为cell专用属性，后期会扩展到cell的其他子view） */
@property (nonatomic) NSIndexPath *sd_indexPath;

- (NSMutableArray *)autoLayoutModelsArray;
- (void)addAutoLayoutModel:(XLsn0wConstraintsMaker *)model;
@property (nonatomic) XLsn0wConstraintsMaker *ownLayoutModel;
@property (nonatomic, strong) NSNumber *sd_maxWidth;
@property (nonatomic, strong) NSNumber *autoHeightRatioValue;
@property (nonatomic, strong) NSNumber *autoWidthRatioValue;

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/

@property (nonatomic) BOOL shouldReadjustFrameBeforeStoreCache;

@property (nonatomic) CGFloat left_sd;
@property (nonatomic) CGFloat top_sd;
@property (nonatomic) CGFloat right_sd;
@property (nonatomic) CGFloat bottom_sd;
@property (nonatomic) CGFloat centerX_sd;
@property (nonatomic) CGFloat centerY_sd;

@property (nonatomic) CGFloat width_sd;
@property (nonatomic) CGFloat height_sd;

@property (nonatomic) CGPoint origin_sd;
@property (nonatomic) CGSize size_sd;

/** 自动布局完成后的回调block，可以在这里获取到view的真实frame  */
@property (nonatomic) void (^didFinishAutoLayoutBlock)(CGRect frame);

/** 添加一组子view  */
- (void)sd_addSubviews:(NSArray *)subviews;

/* 设置圆角 */

/** 设置圆角半径值  */
@property (nonatomic, strong) NSNumber *sd_cornerRadius;
/** 设置圆角半径值为view宽度的多少倍  */
@property (nonatomic, strong) NSNumber *sd_cornerRadiusFromWidthRatio;
/** 设置圆角半径值为view高度的多少倍  */
@property (nonatomic, strong) NSNumber *sd_cornerRadiusFromHeightRatio;

/** 设置等宽子view（子view需要在同一水平方向） */
@property (nonatomic, strong) NSArray *sd_equalWidthSubviews;

@end
