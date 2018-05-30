
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XLsn0wConstraintsSizer : NSObject

@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, weak)   UIView   *refView;
@property (nonatomic, assign) CGFloat   offset;
@property (nonatomic, strong) NSArray  *refViewsArray;

@end

@class  XLsn0wConstraintsMaker, XLsn0wConstraintsSizer;

typedef XLsn0wConstraintsMaker *(^MarginToView)(id referenceView, CGFloat value);
typedef XLsn0wConstraintsMaker *(^Margin)(CGFloat value);
typedef XLsn0wConstraintsMaker *(^MarginEqualToView)(UIView *toView);
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


/* 设置x、y、width、height、centerX、centerY 值 */

/** x值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin xIs;
/** y值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin yIs;
/** centerX值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin centerXIs;
/** centerY值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) Margin centerYIs;




/* 设置最大宽度和高度、最小宽度和高度 */

/** 最大宽度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight maxWidthIs;
/** 最大高度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight maxHeightIs;
/** 最小宽度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight minWidthIs;
/** 最小高度值，参数为“(CGFloat)”  */
@property (nonatomic, copy, readonly) WidthHeight minHeightIs;



/* 设置和某个参照view的边距相同 */

/** 左间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView left_equalTo;
/** 右间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView right_equalTo;
/** 顶部间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView top_equalTo;
/** 底部间距与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView bottom_equalTo;
/** centerX与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView centerX_equalTo;
/** centerY与参照view相同，参数为“(View)”  */
@property (nonatomic, copy, readonly) MarginEqualToView centerY_equalTo;



/*  设置宽度或者高度等于参照view的多少倍 */

/** 宽度是参照view宽度的多少倍，参数为“(View, CGFloat)” */
@property (nonatomic, copy, readonly) WidthHeightEqualToView widthRatioToView;
/** 高度是参照view高度的多少倍，参数为“(View, CGFloat)” */
@property (nonatomic, copy, readonly) WidthHeightEqualToView heightRatioToView;
/** 设置一个view的宽度和它的高度相同，参数为空“()” */
@property (nonatomic, copy, readonly) SameWidthHeight widthEqualToHeight;
/** 设置一个view的高度和它的宽度相同，参数为空“()” */
@property (nonatomic, copy, readonly) SameWidthHeight heightEqualToWidth;
/** 自适应高度，传入高宽比值，label可以传0实现文字高度自适应 */
@property (nonatomic, copy, readonly) AutoHeightWidth autoHeightRatio;

/** 自适应宽度，参数为宽高比值 */
@property (nonatomic, copy, readonly) AutoHeightWidth autoWidthRatio;



/* 填充父view(快捷方法) */

/** 传入UIEdgeInsetsMake(top, left, bottom, right)，可以快捷设置view到其父view上左下右的间距  */
@property (nonatomic, copy, readonly) SpaceToSuperView spaceToSuperView;

/** 设置偏移量，参数为“(CGFloat value)，目前只有带有equalToView的方法可以设置offset” */
@property (nonatomic, copy, readonly) Offset offset;

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
