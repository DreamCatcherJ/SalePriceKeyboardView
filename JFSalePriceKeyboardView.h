//
//  JFSalePriceKeyboardView.h
//  JFCommunityCenter
//
//  Created by 江嘉荣 on 2017/3/17.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFEnumDefs.h"

@class JFSalePriceKeyboardView;

@protocol JFSalePriceKeyboardViewDelegate <NSObject>

@optional

- (void)salePriceKeyboardViewDidClickDismiss:(JFSalePriceKeyboardView *)priceKeyboardView;

- (void)salePriceKeyboardViewDidClickBack:(JFSalePriceKeyboardView *)priceKeyboardView;

- (void)salePriceKeyboardViewDidClickConfirm:(JFSalePriceKeyboardView *)priceKeyboardView;

@end

@interface JFSalePriceKeyboardView : UIView

+(instancetype)priceKeyboardView;

- (void)show;
- (void)dismiss;
- (void)reset;

- (void)configPrice1:(NSString *)price1 price2:(NSString *)price2 saleType:(SaleType)saleType;

@property (nonatomic,assign) BOOL need_coverView;
@property (nonatomic,assign) CGFloat contentHeight;

@property (nonatomic,assign) SaleType saleType;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UITextField *oriPriceTextField;

@property (nonatomic,strong) UITextField *priceTextField1;

@property (nonatomic,strong) UITextField *priceTextField2;

@property (nonatomic,weak) id<JFSalePriceKeyboardViewDelegate> delegate;

@end
