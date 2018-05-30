
#import "UIView+MakeConstraints.h"
#import "XLsn0wConstraintLayout.h"

#import <objc/runtime.h>

@implementation UIView (MakeConstraints)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [@[@"layoutSubviews"] enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"make_" stringByAppendingString:selString];
            
            Method appleMethod  = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method customMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            
            method_exchangeImplementations(appleMethod, customMethod);
        }];
    });
}

#pragma mark - properties

- (NSMutableArray *)autoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSNumber *)fixedWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWidth:(NSNumber *)fixedWidth
{
    if (fixedWidth) {
        self.width_sd = [fixedWidth floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedWidth), fixedWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight
{
    if (fixedHeight) {
        self.height_sd = [fixedHeight floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)autoHeightRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoHeightRatioValue:(NSNumber *)autoHeightRatioValue
{
    objc_setAssociatedObject(self, @selector(autoHeightRatioValue), autoHeightRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)autoWidthRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoWidthRatioValue:(NSNumber *)autoWidthRatioValue
{
    objc_setAssociatedObject(self, @selector(autoWidthRatioValue), autoWidthRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)maxWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMaxWidth:(NSNumber *)maxWidth
{
    objc_setAssociatedObject(self, @selector(maxWidth), maxWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview {

    
}

- (XLsn0wConstraintsMaker *)ownLayoutModel
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(XLsn0wConstraintsMaker *)ownLayoutModel
{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (XLsn0wConstraintsMaker *)make {
    
#ifdef SDDebugWithAssert
    NSAssert(self.superview, @"一定要先添加到SuperView才能约束");
#endif
    
    XLsn0wConstraintsMaker *model = [self ownLayoutModel];
    if (!model) {
        model = [XLsn0wConstraintsMaker new];
        model.needsAutoResizeView = self;
        [self setOwnLayoutModel:model];
        [self.superview.autoLayoutModelsArray addObject:model];
    }
    
    return model;
}

- (XLsn0wConstraintsMaker *)resetConstraints {

    XLsn0wConstraintsMaker *model = [self ownLayoutModel];
    XLsn0wConstraintsMaker *newModel = [XLsn0wConstraintsMaker new];
    newModel.needsAutoResizeView = self;
    [self clearViewFrameCache];
    NSInteger index = 0;
    if (model) {
        index = [self.superview.autoLayoutModelsArray indexOfObject:model];
        [self.superview.autoLayoutModelsArray replaceObjectAtIndex:index withObject:newModel];
    } else {
        [self.superview.autoLayoutModelsArray addObject:newModel];
    }
    [self setOwnLayoutModel:newModel];
    [self clearExtraAutoLayoutItems];
    return newModel;
}

- (XLsn0wConstraintsMaker *)newConstraints {
    [self clearAutoLayoutSettings];
    [self clearExtraAutoLayoutItems];
    return [self make];
}


- (void)removeFromSuperviewAndClearAutoLayoutSettings
{
    [self clearAutoLayoutSettings];
    [self removeFromSuperview];
}

- (void)clearAutoLayoutSettings
{
    XLsn0wConstraintsMaker *model = [self ownLayoutModel];
    if (model) {
        [self.superview.autoLayoutModelsArray removeObject:model];
        [self setOwnLayoutModel:nil];
    }
    [self clearExtraAutoLayoutItems];
}

- (void)clearExtraAutoLayoutItems
{
    if (self.autoHeightRatioValue) {
        self.autoHeightRatioValue = nil;
    }
    self.fixedHeight = nil;
    self.fixedWidth = nil;
}

- (void)clearViewFrameCache
{
    self.frame = CGRectZero;
}

- (void)clearSubviewsAutoLayoutFrameCaches {
    
    if (self.autoLayoutModelsArray.count == 0) return;
    
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(XLsn0wConstraintsMaker *model, NSUInteger idx, BOOL *stop) {
        model.needsAutoResizeView.frame = CGRectZero;
    }];
}

- (void)make_layoutSubviews {
    [self make_layoutSubviews];
    [self make_layoutSubviewsHandle];
}

- (void)make_layoutSubviewsHandle{

    if (self.sd_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            XLsn0wConstraintsMaker *model = view.make;
            CGFloat left = model.left ? [model.left.value floatValue] : model.needsAutoResizeView.left_sd;
            totalMargin += (left + [model.right.value floatValue]);
        }];
        CGFloat averageWidth = (self.width_sd - totalMargin) / self.sd_equalWidthSubviews.count;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.width_sd = averageWidth;
            view.fixedWidth = @(averageWidth);
        }];
    }
    

    
    if (self.autoLayoutModelsArray.count) {
        
        NSMutableArray *caches = nil;
        
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(XLsn0wConstraintsMaker *model, NSUInteger idx, BOOL *stop) {
            if (idx < caches.count) {
                CGRect originalFrame = model.needsAutoResizeView.frame;
                CGRect newFrame = [[caches objectAtIndex:idx] CGRectValue];
                if (CGRectEqualToRect(originalFrame, newFrame)) {
                    [model.needsAutoResizeView setNeedsLayout];
                } else {
                    model.needsAutoResizeView.frame = newFrame;
                }
             
            } else {

                [self sd_resizeWithModel:model];
            }
        }];
    }
    

}

- (void)sd_resizeWithModel:(XLsn0wConstraintsMaker *)model
{
    UIView *view = model.needsAutoResizeView;

    if (view.maxWidth && (model.rightValue || model.right_equalTo)) { // 靠右布局前提设置
  
        view.fixedWidth = @(view.width_sd);
    }
    
    [self layoutWidthWithView:view model:model];
    
    [self layoutHeightWithView:view model:model];
    
    [self layoutLeftWithView:view model:model];
    
    [self layoutRightWithView:view model:model];
    
    if (view.autoHeightRatioValue && view.width_sd > 0 && (model.bottom_equalTo || model.bottomValue)) { // 底部布局前提设置

        view.fixedHeight = @(view.height_sd);
    }
    
    if (view.autoWidthRatioValue) {
        view.fixedWidth = @(view.height_sd * [view.autoWidthRatioValue floatValue]);
    }
    
    
    [self layoutTopWithView:view model:model];
    
    [self layoutBottomWithView:view model:model];
    

    
    if (model.maxWidth && [model.maxWidth floatValue] < view.width_sd) {
        view.width_sd = [model.maxWidth floatValue];
    }
    
    if (model.minWidth && [model.minWidth floatValue] > view.width_sd) {
        view.width_sd = [model.minWidth floatValue];
    }

    
    if (model.maxHeight && [model.maxHeight floatValue] < view.height_sd) {
        view.height_sd = [model.maxHeight floatValue];
    }
    
    if (model.minHeight && [model.minHeight floatValue] > view.height_sd) {
        view.height_sd = [model.minHeight floatValue];
    }
    
    if (model.widthEqualHeight) {
        view.width_sd = view.height_sd;
    }
    
    if (model.heightEqualWidth) {
        view.height_sd = view.width_sd;
    }
    
    if (view.didFinishAutoLayoutBlock) {
        view.didFinishAutoLayoutBlock(view.frame);
    }
    

}



- (void)layoutWidthWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if (model.width) {
        view.width_sd = [model.width.value floatValue];
        view.fixedWidth = @(view.width_sd);
    } else if (model.ratio_width) {
        view.width_sd = model.ratio_width.refView.width_sd * [model.ratio_width.value floatValue];
        view.fixedWidth = @(view.width_sd);
    }
}

- (void)layoutHeightWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if (model.height) {
        view.height_sd = [model.height.value floatValue];
        view.fixedHeight = @(view.height_sd);
    } else if (model.ratio_height) {
        view.height_sd = [model.ratio_height.value floatValue] * model.ratio_height.refView.height_sd;
        view.fixedHeight = @(view.height_sd);
    }
}

- (void)layoutLeftWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if (model.left) {
        if (view.superview == model.left.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = view.right_sd - [model.left.value floatValue];
            }
            view.left_sd = [model.left.value floatValue];
        } else {
            if (model.left.refViewsArray.count) {
                CGFloat lastRefRight = 0;
                for (UIView *ref in model.left.refViewsArray) {
                    if ([ref isKindOfClass:[UIView class]] && ref.right_sd > lastRefRight) {
                        model.left.refView = ref;
                        lastRefRight = ref.right_sd;
                    }
                }
            }
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = view.right_sd - model.left.refView.right_sd - [model.left.value floatValue];
            }
            view.left_sd = model.left.refView.right_sd + [model.left.value floatValue];
        }
        
    } else if (model.equalLeft) {
        if (!view.fixedWidth) {
            if (model.needsAutoResizeView == view.superview) {
                view.width_sd = view.right_sd - (0 + model.equalLeft.offset);
            } else {
                view.width_sd = view.right_sd  - (model.equalLeft.refView.left_sd + model.equalLeft.offset);
            }
        }
        if (view.superview == model.equalLeft.refView) {
            view.left_sd = 0 + model.equalLeft.offset;
        } else {
            view.left_sd = model.equalLeft.refView.left_sd + model.equalLeft.offset;
        }
    } else if (model.equalCenterX) {
        if (view.superview == model.equalCenterX.refView) {
            view.centerX_sd = model.equalCenterX.refView.width_sd * 0.5 + model.equalCenterX.offset;
        } else {
            view.centerX_sd = model.equalCenterX.refView.centerX_sd + model.equalCenterX.offset;
        }
    } else if (model.centerX) {
        view.centerX_sd = [model.centerX floatValue];
    }
}

- (void)layoutRightWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if (model.right) {
        if (view.superview == model.right.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = model.right.refView.width_sd - view.left_sd - [model.right.value floatValue];
            }
            view.right_sd = model.right.refView.width_sd - [model.right.value floatValue];
        } else {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd =  model.right.refView.left_sd - view.left_sd - [model.right.value floatValue];
            }
            view.right_sd = model.right.refView.left_sd - [model.right.value floatValue];
        }
    } else if (model.equalRight) {
        if (!view.fixedWidth) {
            if (model.equalRight.refView == view.superview) {
                view.width_sd = model.equalRight.refView.width_sd - view.left_sd + model.equalRight.offset;
            } else {
                view.width_sd = model.equalRight.refView.right_sd - view.left_sd + model.equalRight.offset;
            }
        }
        
        view.right_sd = model.equalRight.refView.right_sd + model.equalRight.offset;
        if (view.superview == model.equalRight.refView) {
            view.right_sd = model.equalRight.refView.width_sd + model.equalRight.offset;
        }
        
    }
}

- (void)layoutTopWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if (model.top) {
        if (view.superview == model.top.refView) {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_sd = view.bottom_sd - [model.top.value floatValue];
            }
            view.top_sd = [model.top.value floatValue];
        } else {
            if (model.top.refViewsArray.count) {
                CGFloat lastRefBottom = 0;
                for (UIView *ref in model.top.refViewsArray) {
                    if ([ref isKindOfClass:[UIView class]] && ref.bottom_sd > lastRefBottom) {
                        model.top.refView = ref;
                        lastRefBottom = ref.bottom_sd;
                    }
                }
            }
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_sd = view.bottom_sd - model.top.refView.bottom_sd - [model.top.value floatValue];
            }
            view.top_sd = model.top.refView.bottom_sd + [model.top.value floatValue];
        }
    } else if (model.equalTop) {
        if (view.superview == model.equalTop.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.bottom_sd - model.equalTop.offset;
            }
            view.top_sd = 0 + model.equalTop.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_sd = view.bottom_sd - (model.equalTop.refView.top_sd + model.equalTop.offset);
            }
            view.top_sd = model.equalTop.refView.top_sd + model.equalTop.offset;
        }
    } else if (model.equalCenterY) {
        if (view.superview == model.equalCenterY.refView) {
            view.centerY_sd = model.equalCenterY.refView.height_sd * 0.5 + model.equalCenterY.offset;
        } else {
            view.centerY_sd = model.equalCenterY.refView.centerY_sd + model.equalCenterY.offset;
        }
    } else if (model.centerY) {
        view.centerY_sd = [model.centerY floatValue];
    }
}

- (void)layoutBottomWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if (model.bottom) {
        if (view.superview == model.bottom.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.superview.height_sd - view.top_sd - [model.bottom.value floatValue];
            }
            view.bottom_sd = model.bottom.refView.height_sd - [model.bottom.value floatValue];
        } else {
            if (!view.fixedHeight) {
                view.height_sd = model.bottom.refView.top_sd - view.top_sd - [model.bottom.value floatValue];
            }
            view.bottom_sd = model.bottom.refView.top_sd - [model.bottom.value floatValue];
        }
        
    } else if (model.equalBottom) {
        if (view.superview == model.equalBottom.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.superview.height_sd - view.top_sd + model.equalBottom.offset;
            }
            view.bottom_sd = model.equalBottom.refView.height_sd + model.equalBottom.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_sd = model.equalBottom.refView.bottom_sd - view.top_sd + model.equalBottom.offset;
            }
            view.bottom_sd = model.equalBottom.refView.bottom_sd + model.equalBottom.offset;
        }
    }
    if (model.widthEqualHeight && !view.fixedHeight) {
        [self layoutRightWithView:view model:model];
    }
}

//- (void)setupCornerRadiusWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model {
//    CGFloat cornerRadius = view.layer.cornerRadius;
//    CGFloat newCornerRadius = 0;
//
//    if (view.sd_cornerRadius && (cornerRadius != [view.sd_cornerRadius floatValue])) {
//        newCornerRadius = [view.sd_cornerRadius floatValue];
//    } else if (view.sd_cornerRadiusFromWidthRatio && (cornerRadius != [view.sd_cornerRadiusFromWidthRatio floatValue] * view.width_sd)) {
//        newCornerRadius = view.width_sd * [view.sd_cornerRadiusFromWidthRatio floatValue];
//    } else if (view.sd_cornerRadiusFromHeightRatio && (cornerRadius != view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue])) {
//        newCornerRadius = view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue];
//    }
//
//    if (newCornerRadius > 0) {
//        view.layer.cornerRadius = newCornerRadius;
//        view.clipsToBounds = YES;
//    }
//}

- (void)addAutoLayoutModel:(XLsn0wConstraintsMaker *)model
{
    [self.autoLayoutModelsArray addObject:model];
}

/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/
/*****************************************************************************************************************/

- (CGFloat)left_sd {
    return self.frame.origin.x;
}

- (void)setLeft_sd:(CGFloat)x_sd {
    CGRect frame = self.frame;
    frame.origin.x = x_sd;
    self.frame = frame;
}

- (CGFloat)top_sd {
    return self.frame.origin.y;
}

- (void)setTop_sd:(CGFloat)y_sd {
    CGRect frame = self.frame;
    frame.origin.y = y_sd;
    self.frame = frame;
}

- (CGFloat)right_sd {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_sd:(CGFloat)right_sd {
    CGRect frame = self.frame;
    frame.origin.x = right_sd - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom_sd {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_sd:(CGFloat)bottom_sd {
    CGRect frame = self.frame;
    frame.origin.y = bottom_sd - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX_sd
{
    return self.left_sd + self.width_sd * 0.5;
}

- (void)setCenterX_sd:(CGFloat)centerX_sd
{
    self.left_sd = centerX_sd - self.width_sd * 0.5;
}

- (CGFloat)centerY_sd
{
    return self.top_sd + self.height_sd * 0.5;
}

- (void)setCenterY_sd:(CGFloat)centerY_sd
{
    self.top_sd = centerY_sd - self.height_sd * 0.5;
}

- (CGFloat)width_sd {
    return self.frame.size.width;
}

- (void)setWidth_sd:(CGFloat)width_sd {
    if (self.ownLayoutModel.widthEqualHeight) {
        if (width_sd != self.height_sd) return;
    }
    [self setWidth:width_sd];
    if (self.ownLayoutModel.heightEqualWidth) {
        self.height_sd = width_sd;
    }
}

- (CGFloat)height_sd {
    return self.frame.size.height;
}

- (void)setHeight_sd:(CGFloat)height_sd {
    if (self.ownLayoutModel.heightEqualWidth) {
        if (height_sd != self.width_sd) return;
    }
    [self setHeight:height_sd];
    if (self.ownLayoutModel.widthEqualHeight) {
        self.width_sd = height_sd;
    }
}

- (CGPoint)origin_sd {
    return self.frame.origin;
}

- (void)setOrigin_sd:(CGPoint)origin_sd {
    CGRect frame = self.frame;
    frame.origin = origin_sd;
    self.frame = frame;
}

- (CGSize)size_sd {
    return self.frame.size;
}

- (void)setSize_sd:(CGSize)size_sd {
    [self setSize:size_sd];
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void (^)(CGRect))didFinishAutoLayoutBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidFinishAutoLayoutBlock:(void (^)(CGRect))didFinishAutoLayoutBlock {
    objc_setAssociatedObject(self,
                             @selector(didFinishAutoLayoutBlock),
                             didFinishAutoLayoutBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}






- (NSArray *)sd_equalWidthSubviews
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_equalWidthSubviews:(NSArray *)sd_equalWidthSubviews
{
    objc_setAssociatedObject(self, @selector(sd_equalWidthSubviews), sd_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
