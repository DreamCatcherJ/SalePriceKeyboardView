//
//  JFSalePriceKeyboardView.m
//  JFCommunityCenter
//
//  Created by 江嘉荣 on 2017/3/17.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "JFSalePriceKeyboardView.h"
#import "ReactiveObjC.h"

@interface JFSalePriceKeyboardView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIButton *oriPriceBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;

@property (nonatomic,weak) UITextField *selTextField;

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,strong) UILabel *toLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,strong) UILabel *priceLabel1;

@end

@implementation JFSalePriceKeyboardView

+(instancetype)priceKeyboardView{
    return [[[NSBundle mainBundle] loadNibNamed:@"JFSalePriceKeyboardView" owner:self options:nil] lastObject];
}

#pragma mark - init
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    
    self.priceTextField.delegate = self;
    self.oriPriceTextField.delegate = self;
    
    //self.selTextField = self.priceTextField;
    self.priceTextField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    self.oriPriceTextField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    
}

- (void)configWant2ByConstrains{

    [self.priceLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.priceLabel);
    }];
    
    [self.toLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    [self.priceTextField1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel1.mas_right);
        make.right.mas_equalTo(self.toLabel.mas_left);
        make.centerY.mas_equalTo(self.toLabel);
    }];
    
    [self.priceTextField2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self.toLabel.mas_right);
        make.centerY.mas_equalTo(self.toLabel);
    }];

    
}

#pragma mark - setter

- (void)setSaleType:(SaleType)saleType{
    
    _saleType = saleType;
    if (saleType == SaleTypeResell) {
        
        self.selTextField = self.priceTextField;
        
        self.topView.hidden = NO;
        
        [self.toLabel removeFromSuperview];
        [self.priceLabel1 removeFromSuperview];
        [self.priceTextField1 removeFromSuperview];
        [self.priceTextField2 removeFromSuperview];
        
    }else if (saleType == SaleTypewant2By){
        
        self.topView.hidden = YES;
        self.selTextField = self.priceTextField1;
        
        [self addSubview:self.priceLabel1];
        [self addSubview:self.toLabel];
        [self addSubview:self.priceTextField1];
        [self addSubview:self.priceTextField2];
        
        [self configWant2ByConstrains];
        
    }
    
}

#pragma mark - public
- (void)show{
    
    if (self.need_coverView) {
        [self.superview addSubview:self.coverView];
        [self.superview bringSubviewToFront:self];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentHeight);
        make.left.right.bottom.mas_equalTo(self.superview);
    }];
    
    if (self.saleType == SaleTypewant2By) [self.priceTextField1 becomeFirstResponder];
    else [self.priceTextField becomeFirstResponder];
}

- (void)dismiss{
    [self.coverView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)reset{
    self.priceTextField.text = @"";
    self.oriPriceTextField.text = @"";
    self.priceTextField1.text = @"";
    self.priceTextField2.text = @"";
}

- (void)configPrice1:(NSString *)price1 price2:(NSString *)price2 saleType:(SaleType)saleType{

    self.saleType = saleType;
    
    if (saleType == SaleTypeResell) {
        self.priceTextField.text = price1;
        self.oriPriceTextField.text = price2;
    }else{
        self.priceTextField1.text = price1;
        self.priceTextField2.text = price2;
    }
    
}

#pragma mark - event

- (IBAction)didClickPriceBtn:(UIButton *)btn {
    
    self.selTextField.textColor = RGB(153, 153, 153);
    self.selTextField = self.priceTextField;
    self.selTextField.textColor = RGB(255, 105, 105);
    
}
- (IBAction)didClickOriPriceBtn:(UIButton *)btn {
    
    self.selTextField.textColor = RGB(153, 153, 153);
    self.selTextField = self.oriPriceTextField;
    self.selTextField.textColor = RGB(255, 105, 105);
    
}

- (BOOL)checkWith:(NSString *)str{
    
    BOOL res = YES;
    
    // 开头已经有0
    if ([self.selTextField.text isEqualToString:@"0"]) {
        if ([str isEqualToString:@"0"]) {
            return NO;
        }else if (![str isEqualToString:@"."]){
            self.selTextField.text = @"";
        }
    }
    
    // 最高100万
    if ([[self.selTextField.text stringByAppendingString:str] doubleValue] > 1000000) return NO;
    
    // 小数点后面的处理
    if ([self.selTextField.text containsString:@"."]){
        NSRange range = [self.selTextField.text rangeOfString:@"."];
        NSString *subStr = [self.selTextField.text substringFromIndex:range.location+1];
        if (subStr.length == 2) return NO;
        if ([str isEqualToString:@"."]) return NO;
    }
    return res;
}

- (IBAction)didClick1{
    
    NSString *str = @"1";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick2{
    NSString *str = @"2";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick3{
    NSString *str = @"3";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick4{
    NSString *str = @"4";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick5{
    NSString *str = @"5";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick6{
    NSString *str = @"6";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick7{
    NSString *str = @"7";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick8{
    NSString *str = @"8";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick9{
    NSString *str = @"9";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClick0{
    NSString *str = @"0";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClickDot{
    NSString *str = @".";
    if (![self checkWith:str]) return;
    
    self.selTextField.text = [self.selTextField.text stringByAppendingString:str];
    
}

- (IBAction)didClickDismissBtn {
    
    if ([self.delegate respondsToSelector:@selector(salePriceKeyboardViewDidClickDismiss:)]) {
        [self.delegate salePriceKeyboardViewDidClickDismiss:self];
    }
    
}

- (IBAction)didClickBackBtn {

    if (self.selTextField.text.length == 0) return;
    
    self.selTextField.text = [self.selTextField.text substringToIndex:self.selTextField.text.length-1];
    
    if ([self.delegate respondsToSelector:@selector(salePriceKeyboardViewDidClickBack:)]) {
        [self.delegate salePriceKeyboardViewDidClickBack:self];
    }
    
}

- (IBAction)didClickConfirm {
    
    if ([self.delegate respondsToSelector:@selector(salePriceKeyboardViewDidClickConfirm:)]) {
        [self.delegate salePriceKeyboardViewDidClickConfirm:self];
    }
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.selTextField = textField;
    return YES;
    
}

#pragma mark - lazy

- (UIView *)coverView{
    
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = RGBA(0, 0, 0, .3);
        _coverView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            [self didClickDismissBtn];
            [self dismiss];
        }];
        [_coverView addGestureRecognizer:tap];
        
    }
    return _coverView;
}

- (UILabel *)toLabel{
    
    if (!_toLabel) {
        _toLabel = [UILabel new];
        _toLabel.text = @"至";
        [_toLabel sizeToFit];
        _toLabel.font = [UIFont systemFontOfSize:14];
        _toLabel.textColor = RGBS(51);
    }
    return _toLabel;
}

- (UITextField *)priceTextField1{
    
    if (!_priceTextField1) {
        _priceTextField1 = [UITextField new];
        _priceTextField1.delegate = self;
        _priceTextField1.textAlignment = NSTextAlignmentCenter;
        _priceTextField1.placeholder = @"￥0.00";
        _priceTextField1.font = [UIFont systemFontOfSize:14];
        _priceTextField1.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _priceTextField1;
}

- (UITextField *)priceTextField2{
    
    if (!_priceTextField2) {
        _priceTextField2 = [UITextField new];
        _priceTextField2.delegate = self;
        _priceTextField2.textAlignment = NSTextAlignmentCenter;
        _priceTextField2.placeholder = @"￥0.00";
        _priceTextField2.font = [UIFont systemFontOfSize:14];
        _priceTextField2.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _priceTextField2;
}

- (UILabel *)priceLabel1{
    
    if (!_priceLabel1) {
        _priceLabel1 = [UILabel new];
        _priceLabel1.text = @"价格";
        _priceLabel1.font = [UIFont systemFontOfSize:14];
        _priceLabel1.textColor = RGBS(51);
    }
    return _priceLabel1;
}

@end
