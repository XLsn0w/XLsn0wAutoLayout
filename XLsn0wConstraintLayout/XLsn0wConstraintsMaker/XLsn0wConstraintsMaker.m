
#import "XLsn0wConstraintsMaker.h"
#import "UIView+MakeConstraints.h"

@implementation XLsn0wConstraintsSizer

- (instancetype)init {
    if (self = [super init]) {
        _offset = 0;
    }
    return self;
}

@end

@implementation XLsn0wConstraintsMaker

@synthesize leftValue = _leftValue;
@synthesize rightValue = _rightValue;
@synthesize topValue = _topValue;
@synthesize bottomValue = _bottomValue;
@synthesize widthValue = _widthValue;
@synthesize heightValue = _heightValue;

@synthesize widthRatioToView = _widthRatioToView;
@synthesize heightRatioToView = _heightRatioToView;

@synthesize left_equalTo = _left_equalTo;
@synthesize right_equalTo = _right_equalTo;
@synthesize top_equalTo = _top_equalTo;
@synthesize bottom_equalTo = _bottom_equalTo;
@synthesize centerX_equalTo = _centerX_equalTo;
@synthesize centerY_equalTo = _centerY_equalTo;

@synthesize xIs = _xIs;
@synthesize yIs = _yIs;
@synthesize centerXIs = _centerXIs;
@synthesize centerYIs = _centerYIs;
@synthesize autoHeightRatio = _autoHeightRatio;
@synthesize autoWidthRatio = _autoWidthRatio;
@synthesize spaceToSuperView = _spaceToSuperView;
@synthesize maxWidthIs = _maxWidthIs;
@synthesize maxHeightIs = _maxHeightIs;
@synthesize minWidthIs = _minWidthIs;
@synthesize minHeightIs = _minHeightIs;
@synthesize widthEqualToHeight = _widthEqualToHeight;
@synthesize heightEqualToWidth = _heightEqualToWidth;
@synthesize offset = _offset;


- (MarginToView)leftValue {
    if (!_leftValue) {
        _leftValue = [self marginToViewblockWithKey:@"left"];
    }
    return _leftValue;
}

- (MarginToView)rightValue
{
    if (!_rightValue) {
        _rightValue = [self marginToViewblockWithKey:@"right"];
    }
    return _rightValue;
}

- (MarginToView)topValue
{
    if (!_topValue) {
        _topValue = [self marginToViewblockWithKey:@"top"];
    }
    return _topValue;
}

- (MarginToView)bottomSpaceToView
{
    if (!_bottomValue) {
        _bottomValue = [self marginToViewblockWithKey:@"bottom"];
    }
    return _bottomValue;
}

- (MarginToView)marginToViewblockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return ^(id viewOrViewsArray, CGFloat value) {
        XLsn0wConstraintsSizer *item = [XLsn0wConstraintsSizer new];
        item.value = @(value);
        if ([viewOrViewsArray isKindOfClass:[UIView class]]) {
            item.refView = viewOrViewsArray;
        } else if ([viewOrViewsArray isKindOfClass:[NSArray class]]) {
            item.refViewsArray = [viewOrViewsArray copy];
        }
        [weakSelf setValue:item forKey:key];
        return weakSelf;
    };
}

- (WidthHeight)widthValue
{
    if (!_widthValue) {
        __weak typeof(self) weakSelf = self;
        _widthValue = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.fixedWidth = @(value);
            XLsn0wConstraintsSizer *widthItem = [XLsn0wConstraintsSizer new];
            widthItem.value = @(value);
            weakSelf.width = widthItem;
            return weakSelf;
        };
    }
    return _widthValue;
}

- (WidthHeight)heightValue
{
    if (!_heightValue) {
        __weak typeof(self) weakSelf = self;
        _heightValue = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.fixedHeight = @(value);
            XLsn0wConstraintsSizer *heightItem = [XLsn0wConstraintsSizer new];
            heightItem.value = @(value);
            weakSelf.height = heightItem;
            return weakSelf;
        };
    }
    return _heightValue;
}

- (WidthHeightEqualToView)widthRatioToView
{
    if (!_widthRatioToView) {
        __weak typeof(self) weakSelf = self;
        _widthRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_width = [XLsn0wConstraintsSizer new];
            weakSelf.ratio_width.value = @(value);
            weakSelf.ratio_width.refView = view;
            return weakSelf;
        };
    }
    return _widthRatioToView;
}

- (WidthHeightEqualToView)heightRatioToView
{
    if (!_heightRatioToView) {
        __weak typeof(self) weakSelf = self;
        _heightRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_height = [XLsn0wConstraintsSizer new];
            weakSelf.ratio_height.refView = view;
            weakSelf.ratio_height.value = @(value);
            return weakSelf;
        };
    }
    return _heightRatioToView;
}

- (WidthHeight)maxWidthIs
{
    if (!_maxWidthIs) {
        _maxWidthIs = [self limitingWidthHeightWithKey:@"maxWidth"];
    }
    return _maxWidthIs;
}

- (WidthHeight)maxHeightIs
{
    if (!_maxHeightIs) {
        _maxHeightIs = [self limitingWidthHeightWithKey:@"maxHeight"];
    }
    return _maxHeightIs;
}

- (WidthHeight)minWidthIs
{
    if (!_minWidthIs) {
        _minWidthIs = [self limitingWidthHeightWithKey:@"minWidth"];
    }
    return _minWidthIs;
}

- (WidthHeight)minHeightIs
{
    if (!_minHeightIs) {
        _minHeightIs = [self limitingWidthHeightWithKey:@"minHeight"];
    }
    return _minHeightIs;
}


- (WidthHeight)limitingWidthHeightWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        [weakSelf setValue:@(value) forKey:key];
        
        return weakSelf;
    };
}

- (MarginEqualToView)marginEqualToViewBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view) {
        XLsn0wConstraintsSizer *item = [XLsn0wConstraintsSizer new];
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        weakSelf.lastModelItem = item;

        return weakSelf;
    };
}

- (MarginEqualToView)left_equalTo {
    if (!_left_equalTo) {
        _left_equalTo = [self marginEqualToViewBlockWithKey:@"equalLeft"];
    }
    return _left_equalTo;
}

- (MarginEqualToView)right_equalTo {
    if (!_right_equalTo) {
        _right_equalTo = [self marginEqualToViewBlockWithKey:@"equalRight"];
    }
    return _right_equalTo;
}

- (MarginEqualToView)top_equalTo {
    if (!_top_equalTo) {
        _top_equalTo = [self marginEqualToViewBlockWithKey:@"equalTop"];
    }
    return _top_equalTo;
}

- (MarginEqualToView)bottom_equalTo {
    if (!_bottom_equalTo) {
        _bottom_equalTo = [self marginEqualToViewBlockWithKey:@"equalBottom"];
    }
    return _bottom_equalTo;
}

- (MarginEqualToView)centerX_equalTo {
    if (!_centerX_equalTo) {
        _centerX_equalTo = [self marginEqualToViewBlockWithKey:@"equalCenterX"];
    }
    return _centerX_equalTo;
}

- (MarginEqualToView)centerY_equalTo {
    if (!_centerY_equalTo) {
        _centerY_equalTo = [self marginEqualToViewBlockWithKey:@"equalCenterY"];
    }
    return _centerY_equalTo;
}


- (Margin)marginBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        
        if ([key isEqualToString:@"x"]) {
//            weakSelf.needsAutoResizeView.left_value = value;
        } else if ([key isEqualToString:@"y"]) {
//            weakSelf.needsAutoResizeView.top_value = value;
        } else if ([key isEqualToString:@"centerX"]) {
            weakSelf.centerX = @(value);
        } else if ([key isEqualToString:@"centerY"]) {
            weakSelf.centerY = @(value);
        }
        
        return weakSelf;
    };
}

- (Margin)xIs
{
    if (!_xIs) {
        _xIs = [self marginBlockWithKey:@"x"];
    }
    return _xIs;
}

- (Margin)yIs
{
    if (!_yIs) {
        _yIs = [self marginBlockWithKey:@"y"];
    }
    return _yIs;
}

- (Margin)centerXIs
{
    if (!_centerXIs) {
        _centerXIs = [self marginBlockWithKey:@"centerX"];
    }
    return _centerXIs;
}

- (Margin)centerYIs
{
    if (!_centerYIs) {
        _centerYIs = [self marginBlockWithKey:@"centerY"];
    }
    return _centerYIs;
}

- (AutoHeightWidth)autoHeightRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoHeightRatio) {
        _autoHeightRatio = ^(CGFloat ratioaValue) {
            weakSelf.needsAutoResizeView.autoHeightRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoHeightRatio;
}

- (AutoHeightWidth)autoWidthRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoWidthRatio) {
        _autoWidthRatio = ^(CGFloat ratioaValue) {
            weakSelf.needsAutoResizeView.autoWidthRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoWidthRatio;
}

- (SpaceToSuperView)spaceToSuperView
{
    __weak typeof(self) weakSelf = self;
    
    if (!_spaceToSuperView) {
        _spaceToSuperView = ^(UIEdgeInsets insets) {
            UIView *superView = weakSelf.needsAutoResizeView.superview;
            if (superView) {
                weakSelf.needsAutoResizeView
                .make.leftValue(superView, insets.left).topValue(superView, insets.top)
                .rightValue(superView, insets.right).bottomValue(superView, insets.bottom);
            }
        };
    }
    return _spaceToSuperView;
}

- (SameWidthHeight)widthEqualToHeight
{
    __weak typeof(self) weakSelf = self;
    
    if (!_widthEqualToHeight) {
        _widthEqualToHeight = ^() {
            weakSelf.widthEqualHeight = [XLsn0wConstraintsSizer new];
            weakSelf.lastModelItem = weakSelf.widthEqualHeight;
            // 主动触发一次赋值操作
//            weakSelf.needsAutoResizeView.height_value = weakSelf.needsAutoResizeView.height_value;
            return weakSelf;
        };
    }
    return _widthEqualToHeight;
}

- (SameWidthHeight)heightEqualToWidth
{
    __weak typeof(self) weakSelf = self;
    
    if (!_heightEqualToWidth) {
        _heightEqualToWidth = ^() {
            weakSelf.heightEqualWidth = [XLsn0wConstraintsSizer new];
            weakSelf.lastModelItem = weakSelf.heightEqualWidth;
            // 主动触发一次赋值操作
//            weakSelf.needsAutoResizeView.width_value = weakSelf.needsAutoResizeView.width_value;
            return weakSelf;
        };
    }
    return _heightEqualToWidth;
}

- (XLsn0wConstraintsMaker *(^)(CGFloat))offset
{
    __weak typeof(self) weakSelf = self;
    if (!_offset) {
        _offset = ^(CGFloat offset) {
            weakSelf.lastModelItem.offset = offset;
            return weakSelf;
        };
    }
    return _offset;
}

@end

