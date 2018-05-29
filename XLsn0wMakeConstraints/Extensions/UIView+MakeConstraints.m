
#import "UIView+MakeConstraints.h"
#import "XLsn0wMakeConstraints.h"
#import "XLsn0wConstraintsMaker.h"
#import <objc/runtime.h>

@implementation UIView (MakeConstraints)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"layoutSubviews"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"sd_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
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

- (NSNumber *)sd_maxWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_maxWidth:(NSNumber *)sd_maxWidth
{
    objc_setAssociatedObject(self, @selector(sd_maxWidth), sd_maxWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview {
    self.sd_indexPath = indexPath;
    self.sd_tableView = tableview;
}

- (XLsn0wConstraintsMaker *)ownLayoutModel
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(XLsn0wConstraintsMaker *)ownLayoutModel
{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (XLsn0wConstraintsMaker *)makeConstraints {
    
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

- (XLsn0wConstraintsMaker *)sd_resetLayout {
    /*
     * 方案待定
     [self sd_clearAutoLayoutSettings];
     return [self sd_layout];
     */
    
    XLsn0wConstraintsMaker *model = [self ownLayoutModel];
    XLsn0wConstraintsMaker *newModel = [XLsn0wConstraintsMaker new];
    newModel.needsAutoResizeView = self;
    [self sd_clearViewFrameCache];
    NSInteger index = 0;
    if (model) {
        index = [self.superview.autoLayoutModelsArray indexOfObject:model];
        [self.superview.autoLayoutModelsArray replaceObjectAtIndex:index withObject:newModel];
    } else {
        [self.superview.autoLayoutModelsArray addObject:newModel];
    }
    [self setOwnLayoutModel:newModel];
    [self sd_clearExtraAutoLayoutItems];
    return newModel;
}

- (XLsn0wConstraintsMaker *)sd_resetNewLayout
{
    [self sd_clearAutoLayoutSettings];
    [self sd_clearExtraAutoLayoutItems];
    return [self makeConstraints];
}


- (void)removeFromSuperviewAndClearAutoLayoutSettings
{
    [self sd_clearAutoLayoutSettings];
    [self removeFromSuperview];
}

- (void)sd_clearAutoLayoutSettings
{
    XLsn0wConstraintsMaker *model = [self ownLayoutModel];
    if (model) {
        [self.superview.autoLayoutModelsArray removeObject:model];
        [self setOwnLayoutModel:nil];
    }
    [self sd_clearExtraAutoLayoutItems];
}

- (void)sd_clearExtraAutoLayoutItems
{
    if (self.autoHeightRatioValue) {
        self.autoHeightRatioValue = nil;
    }
    self.fixedHeight = nil;
    self.fixedWidth = nil;
}

- (void)sd_clearViewFrameCache
{
    self.frame = CGRectZero;
}

- (void)sd_clearSubviewsAutoLayoutFrameCaches {
    if (self.sd_tableView && self.sd_indexPath) {
        return;
    }
    
    if (self.autoLayoutModelsArray.count == 0) return;
    
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(XLsn0wConstraintsMaker *model, NSUInteger idx, BOOL *stop) {
        model.needsAutoResizeView.frame = CGRectZero;
    }];
}

- (void)sd_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self sd_layoutSubviews];
    
    [self sd_layoutSubviewsHandle];
}

- (void)sd_layoutSubviewsHandle{

    if (self.sd_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            XLsn0wConstraintsMaker *model = view.makeConstraints;
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
                [self setupCornerRadiusWithView:model.needsAutoResizeView model:model];
            } else {

                [self sd_resizeWithModel:model];
            }
        }];
    }
    

}

- (void)sd_resizeWithModel:(XLsn0wConstraintsMaker *)model
{
    UIView *view = model.needsAutoResizeView;
    
//    if (!view || view.sd_isClosingAutoLayout) return;
    
    if (view.sd_maxWidth && (model.rightSpaceToView || model.rightEqualToView)) { // 靠右布局前提设置
        [self layoutAutoWidthWidthView:view model:model];
        view.fixedWidth = @(view.width_sd);
    }
    
    [self layoutWidthWithView:view model:model];
    
    [self layoutHeightWithView:view model:model];
    
    [self layoutLeftWithView:view model:model];
    
    [self layoutRightWithView:view model:model];
    
    if (view.autoHeightRatioValue && view.width_sd > 0 && (model.bottomEqualToView || model.bottomSpaceToView)) { // 底部布局前提设置
        [self layoutAutoHeightWidthView:view model:model];
        view.fixedHeight = @(view.height_sd);
    }
    
    if (view.autoWidthRatioValue) {
        view.fixedWidth = @(view.height_sd * [view.autoWidthRatioValue floatValue]);
    }
    
    
    [self layoutTopWithView:view model:model];
    
    [self layoutBottomWithView:view model:model];
    
    if (view.sd_maxWidth) {
        [self layoutAutoWidthWidthView:view model:model];
    }
    
    if (model.maxWidth && [model.maxWidth floatValue] < view.width_sd) {
        view.width_sd = [model.maxWidth floatValue];
    }
    
    if (model.minWidth && [model.minWidth floatValue] > view.width_sd) {
        view.width_sd = [model.minWidth floatValue];
    }
    
    if (view.autoHeightRatioValue && view.width_sd > 0) {
        [self layoutAutoHeightWidthView:view model:model];
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
    

    
    [self setupCornerRadiusWithView:view model:model];
}

- (void)layoutAutoHeightWidthView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if ([view.autoHeightRatioValue floatValue] > 0) {
        view.height_sd = view.width_sd * [view.autoHeightRatioValue floatValue];
    } else {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.numberOfLines = 0;
            if (label.text.length) {
                if (!label.isAttributedContent) {
                    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.width_sd, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                    label.height_sd = rect.size.height + 0.1;
                } else {
                    [label sizeToFit];
                    if (label.sd_maxWidth && label.width_sd > [label.sd_maxWidth floatValue]) {
                        label.width_sd = [label.sd_maxWidth floatValue];
                    }
                }
            } else {
                label.height_sd = 0;
            }
        } else {
            view.height_sd = 0;
        }
    }
}

- (void)layoutAutoWidthWidthView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        CGFloat width = [view.sd_maxWidth floatValue] > 0 ? [view.sd_maxWidth floatValue] : MAXFLOAT;
        label.numberOfLines = 1;
        if (label.text.length) {
            if (!label.isAttributedContent) {
                CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.height_sd) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                if (rect.size.width > width) {
                    rect.size.width = width;
                }
                label.width_sd = rect.size.width + 0.1;
            } else{
                [label sizeToFit];
                if (label.width_sd > width) {
                    label.width_sd = width;
                }
            }
        } else {
            label.size_sd = CGSizeZero;
        }
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


- (void)setupCornerRadiusWithView:(UIView *)view model:(XLsn0wConstraintsMaker *)model
{
    CGFloat cornerRadius = view.layer.cornerRadius;
    CGFloat newCornerRadius = 0;
    
    if (view.sd_cornerRadius && (cornerRadius != [view.sd_cornerRadius floatValue])) {
        newCornerRadius = [view.sd_cornerRadius floatValue];
    } else if (view.sd_cornerRadiusFromWidthRatio && (cornerRadius != [view.sd_cornerRadiusFromWidthRatio floatValue] * view.width_sd)) {
        newCornerRadius = view.width_sd * [view.sd_cornerRadiusFromWidthRatio floatValue];
    } else if (view.sd_cornerRadiusFromHeightRatio && (cornerRadius != view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue])) {
        newCornerRadius = view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue];
    }
    
    if (newCornerRadius > 0) {
        view.layer.cornerRadius = newCornerRadius;
        view.clipsToBounds = YES;
    }
}

- (void)addAutoLayoutModel:(XLsn0wConstraintsMaker *)model
{
    [self.autoLayoutModelsArray addObject:model];
}

@end

@implementation UIView (SDLayoutExtention)

- (void (^)(CGRect))didFinishAutoLayoutBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidFinishAutoLayoutBlock:(void (^)(CGRect))didFinishAutoLayoutBlock
{
    objc_setAssociatedObject(self, @selector(didFinishAutoLayoutBlock), didFinishAutoLayoutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)sd_cornerRadius
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadius:(NSNumber *)sd_cornerRadius
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadius), sd_cornerRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromWidthRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromWidthRatio:(NSNumber *)sd_cornerRadiusFromWidthRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromWidthRatio), sd_cornerRadiusFromWidthRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromHeightRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromHeightRatio:(NSNumber *)sd_cornerRadiusFromHeightRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromHeightRatio), sd_cornerRadiusFromHeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)sd_equalWidthSubviews
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_equalWidthSubviews:(NSArray *)sd_equalWidthSubviews
{
    objc_setAssociatedObject(self, @selector(sd_equalWidthSubviews), sd_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sd_addSubviews:(NSArray *)subviews
{
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }
    }];
}

@end




@implementation UILabel (SDLabelAutoResize)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"setText:"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"sd_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
        }];
    });
}

- (void)sd_setText:(NSString *)text
{
    // 如果程序崩溃在这行代码说明是你的label在执行“setText”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“setText”方法
    [self sd_setText:text];
    
    
    if (self.sd_maxWidth) {
        [self sizeToFit];
    } else if (self.autoHeightRatioValue) {
        self.size_sd = CGSizeZero;
    }
}

- (BOOL)isAttributedContent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAttributedContent:(BOOL)isAttributedContent
{
    objc_setAssociatedObject(self, @selector(isAttributedContent), @(isAttributedContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSingleLineAutoResizeWithMaxWidth:(CGFloat)maxWidth
{
    self.sd_maxWidth = @(maxWidth);
}

- (void)setMaxNumberOfLinesToShow:(NSInteger)lineCount
{
    NSAssert(self.ownLayoutModel, @"请在布局完成之后再做此步设置！");
    if (lineCount > 0) {
        if (self.isAttributedContent) {
            NSDictionary *attrs = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
            NSMutableParagraphStyle *paragraphStyle = attrs[NSParagraphStyleAttributeName];
            self.makeConstraints.maxHeightIs((self.font.lineHeight) * lineCount + paragraphStyle.lineSpacing * (lineCount - 1) + 0.1);
        } else {
            self.makeConstraints.maxHeightIs(self.font.lineHeight * lineCount + 0.1);
        }
    } else {
        self.makeConstraints.maxHeightIs(MAXFLOAT);
    }
}

@end

@implementation UIButton (SDExtention)

- (void)setupAutoSizeWithHorizontalPadding:(CGFloat)hPadding buttonHeight:(CGFloat)buttonHeight
{
    self.fixedHeight = @(buttonHeight);
    
    self.titleLabel.makeConstraints
    .leftSpaceToView(self, hPadding)
    .topEqualToView(self)
    .heightIs(buttonHeight);
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
}

@end

@implementation UIButton (SDAutoLayoutButton)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *selString = @"layoutSubviews";
        NSString *mySelString = [@"sd_button_" stringByAppendingString:selString];
        
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
        Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
        method_exchangeImplementations(originalMethod, myMethod);
    });
}

- (void)sd_button_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self sd_button_layoutSubviews];
    
    [self sd_layoutSubviewsHandle];
    
}

@end


@implementation UIView (SDChangeFrame)


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

// 兼容旧版本

- (CGFloat)left
{
    return self.left_sd;
}

- (void)setLeft:(CGFloat)left
{
    self.left_sd = left;
}

- (CGFloat)right
{
    return self.right_sd;
}

- (void)setRight:(CGFloat)right
{
    self.right_sd = right;
}

- (CGFloat)width
{
    return self.width_sd;
}

- (CGFloat)height
{
    return self.height_sd;
}

- (CGFloat)top
{
    return self.top_sd;
}

- (void)setTop:(CGFloat)top
{
    self.top_sd = top;
}

- (CGFloat)bottom
{
    return self.bottom_sd;
}

- (void)setBottom:(CGFloat)bottom
{
    self.bottom_sd = bottom;
}

- (CGFloat)centerX
{
    return self.centerX_sd;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.centerX_sd = centerX;
}

- (CGFloat)centerY
{
    return self.centerY_sd;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.centerY_sd = centerY;
}

- (CGPoint)origin
{
    return self.origin_sd;
}

- (void)setOrigin:(CGPoint)origin
{
    self.origin_sd = origin;
}

- (CGSize)size
{
    return self.size_sd;
}

@end

@implementation SDUIViewCategoryManager

@end

