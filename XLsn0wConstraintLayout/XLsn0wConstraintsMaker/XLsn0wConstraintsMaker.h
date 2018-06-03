
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 以4.7-inch iPhone 7 设置屏幕比例
#define   left_scale     ([UIScreen mainScreen].bounds.size.width  / 375)///左边距*当前屏幕宽度比例
#define   right_scale    ([UIScreen mainScreen].bounds.size.width  / 375)///右边距*当前屏幕宽度比例
/************************************************************************///
#define   top_scale      ([UIScreen mainScreen].bounds.size.height / 667)///上边距*当前屏幕高度比例
#define   bottom_scale   ([UIScreen mainScreen].bounds.size.height / 667)///下边距*当前屏幕高度比例

@interface XLsn0wConstraintsSizer : NSObject

@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, weak)   UIView   *refView;
@property (nonatomic, strong) NSArray  *refViewsArray;
@property (nonatomic, assign) CGFloat   offset;

@end

@class  XLsn0wConstraintsMaker;

typedef XLsn0wConstraintsMaker *(^MarginToView)(id referenceView, CGFloat value);
typedef XLsn0wConstraintsMaker *(^Margin)(CGFloat value);
typedef XLsn0wConstraintsMaker *(^MarginEqualToView)(UIView *equalView);
typedef XLsn0wConstraintsMaker *(^WidthHeight)(CGFloat value);
typedef XLsn0wConstraintsMaker *(^WidthHeightEqualToView)(UIView *toView, CGFloat ratioValue);
typedef XLsn0wConstraintsMaker *(^AutoHeightWidth)(CGFloat ratioValue);
typedef XLsn0wConstraintsMaker *(^SameWidthHeight)(void);
typedef XLsn0wConstraintsMaker *(^Offset)(CGFloat value);

typedef void (^SpaceToSuperView)(UIEdgeInsets insets);

@interface XLsn0wConstraintsMaker : NSObject

@property (nonatomic, copy, readonly) MarginToView topValue;
@property (nonatomic, copy, readonly) MarginToView bottomValue;
@property (nonatomic, copy, readonly) MarginToView leftValue;
@property (nonatomic, copy, readonly) MarginToView rightValue;

@property (nonatomic, copy, readonly) WidthHeight widthValue;
@property (nonatomic, copy, readonly) WidthHeight heightValue;

@property (nonatomic, copy, readonly) Margin xIs;
@property (nonatomic, copy, readonly) Margin yIs;
@property (nonatomic, copy, readonly) Margin centerXIs;
@property (nonatomic, copy, readonly) Margin centerYIs;

@property (nonatomic, copy, readonly) WidthHeight maxWidthIs;
@property (nonatomic, copy, readonly) WidthHeight maxHeightIs;
@property (nonatomic, copy, readonly) WidthHeight minWidthIs;
@property (nonatomic, copy, readonly) WidthHeight minHeightIs;

@property (nonatomic, copy, readonly) MarginEqualToView left_equalTo;
@property (nonatomic, copy, readonly) MarginEqualToView right_equalTo;
@property (nonatomic, copy, readonly) MarginEqualToView top_equalTo;
@property (nonatomic, copy, readonly) MarginEqualToView bottom_equalTo;
@property (nonatomic, copy, readonly) MarginEqualToView centerX_equalTo;
@property (nonatomic, copy, readonly) MarginEqualToView centerY_equalTo;
@property (nonatomic, copy, readonly) Offset offset;/// 偏移量

@property (nonatomic, copy, readonly) WidthHeightEqualToView widthRatioToView;
@property (nonatomic, copy, readonly) WidthHeightEqualToView heightRatioToView;
@property (nonatomic, copy, readonly) SameWidthHeight widthEqualToHeight;
@property (nonatomic, copy, readonly) SameWidthHeight heightEqualToWidth;
@property (nonatomic, copy, readonly) AutoHeightWidth autoHeightRatio;

@property (nonatomic, copy, readonly) AutoHeightWidth autoWidthRatio;

@property (nonatomic, copy, readonly) SpaceToSuperView spaceToSuperView;

@property (nonatomic, weak) UIView *needsAutoResizeView;

@property (nonatomic, strong) XLsn0wConstraintsSizer *width;
@property (nonatomic, strong) XLsn0wConstraintsSizer *height;
@property (nonatomic, strong) XLsn0wConstraintsSizer *left;
@property (nonatomic, strong) XLsn0wConstraintsSizer *top;
@property (nonatomic, strong) XLsn0wConstraintsSizer *right;
@property (nonatomic, strong) XLsn0wConstraintsSizer *bottom;

@property (nonatomic, strong) NSNumber *centerX;
@property (nonatomic, strong) NSNumber *centerY;

@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *maxHeight;
@property (nonatomic, strong) NSNumber *minWidth;
@property (nonatomic, strong) NSNumber *minHeight;

@property (nonatomic, strong) XLsn0wConstraintsSizer *ratio_width;
@property (nonatomic, strong) XLsn0wConstraintsSizer *ratio_height;
@property (nonatomic, strong) XLsn0wConstraintsSizer *ratio_left;
@property (nonatomic, strong) XLsn0wConstraintsSizer *ratio_top;
@property (nonatomic, strong) XLsn0wConstraintsSizer *ratio_right;
@property (nonatomic, strong) XLsn0wConstraintsSizer *ratio_bottom;

@property (nonatomic, strong) XLsn0wConstraintsSizer *equalLeft;
@property (nonatomic, strong) XLsn0wConstraintsSizer *equalRight;
@property (nonatomic, strong) XLsn0wConstraintsSizer *equalTop;
@property (nonatomic, strong) XLsn0wConstraintsSizer *equalBottom;
@property (nonatomic, strong) XLsn0wConstraintsSizer *equalCenterX;
@property (nonatomic, strong) XLsn0wConstraintsSizer *equalCenterY;

@property (nonatomic, strong) XLsn0wConstraintsSizer *widthEqualHeight;
@property (nonatomic, strong) XLsn0wConstraintsSizer *heightEqualWidth;

@property (nonatomic, strong) XLsn0wConstraintsSizer *lastModelItem;

@end
