
#import <UIKit/UIKit.h>

@class XLsn0wConstraintsMaker;

#pragma mark - UIView 设置约束、更新约束、清空约束、从父view移除并清空约束、开启cell的frame缓存等相关方法

@interface UIView (MakeConstraints)

///Make Constraints To Layout
- (XLsn0wConstraintsMaker *)make;

- (XLsn0wConstraintsMaker *)resetConstraints;
- (XLsn0wConstraintsMaker *)newConstraints;


- (void)removeFromSuperviewAndClearAutoLayoutSettings;
- (void)clearAutoLayoutSettings;
- (void)clearViewFrameCache;
- (void)clearSubviewsAutoLayoutFrameCaches;


@property (nonatomic, strong) NSNumber *fixedWidth;
@property (nonatomic, strong) NSNumber *fixedHeight;


- (NSMutableArray *)autoLayoutModelsArray;
- (void)addAutoLayoutModel:(XLsn0wConstraintsMaker *)model;

@property (nonatomic) XLsn0wConstraintsMaker *ownLayoutModel;
@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *autoHeightRatioValue;
@property (nonatomic, strong) NSNumber *autoWidthRatioValue;


@end
