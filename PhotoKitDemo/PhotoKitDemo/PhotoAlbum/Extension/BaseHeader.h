//
//  BaseHeader.h
//  Category
//
//  Created by 徐杨 on 2016/12/5.
//  Copyright © 2016年 H&X. All rights reserved.
//

#ifndef BaseHeader_h
#define BaseHeader_h

//-----UIView  可以模仿masonry书写方式
typedef UIView *(^viewFrame)(CGRect);
typedef UIView *(^viewBackgroundColor)(UIColor *);
typedef UIView *(^viewAddToView)(UIView *);
typedef UIView *(^viewTag)(NSInteger);
typedef UIView *(^viewCenter)(CGPoint);
typedef UIView *(^viewAlpha)(CGFloat);
typedef void (^viewTapClosure)(UIView *);

//-----UIButton
typedef UIButton *(^btnFrame)(CGRect);
typedef UIButton *(^btnBackgroundColor)(UIColor *);
typedef UIButton *(^btnAddToView)(UIView *);
typedef UIButton *(^btnTitleLableFont)(UIFont *);
typedef UIButton *(^btnCenter)(CGPoint);
typedef UIButton *(^btnAlpha)(CGFloat);

typedef UIButton *(^btnTitle)(NSString *);
typedef UIButton *(^btnTitleForState)(NSString *, UIControlState state);
typedef UIButton *(^btnTitleColor)(UIColor *);
typedef UIButton *(^btnTitleColorForState)(UIColor *, UIControlState state);
typedef UIButton *(^btnImage)(UIImage *);
typedef UIButton *(^btnImageForState)(UIImage *, UIControlState state);
typedef UIButton *(^btnTitleEdgeInsets)(UIEdgeInsets);
typedef UIButton *(^btnImageEdgeInsets)(UIEdgeInsets);
typedef UIButton *(^btnContentEdgeInsets)(UIEdgeInsets);
typedef UIButton *(^btnTag)(NSInteger);

typedef UIButton *(^btnLayerCornerRadius)(CGFloat);
typedef UIButton *(^btnLayerMasksToBounds)(BOOL);
typedef UIButton *(^btnLayerBorderColor)(UIColor *);
typedef UIButton *(^btnLayerBorderWidth)(CGFloat);

//事件
typedef UIButton *(^btnAddTarget)(id target, SEL selector, UIControlEvents events);
typedef void (^btnClickClosure)(UIButton *);

//-----UILabel
typedef UILabel *(^labelFrame)(CGRect);
typedef UILabel *(^labelBackgroundColor)(UIColor *);
typedef UILabel *(^labelAddToView)(UIView *);
typedef UILabel *(^labelTag)(NSInteger);
typedef UILabel *(^labelCenter)(CGPoint);
typedef UILabel *(^labelAlpha)(CGFloat);

typedef UILabel *(^labelFont)(UIFont *);
typedef UILabel *(^labelTextColor)(UIColor *);
typedef UILabel *(^labelText)(NSString *);
typedef UILabel *(^labelTextAlignment)(NSTextAlignment);
typedef UILabel *(^labelNumberOfLines)(int);
typedef UILabel *(^labelAttributedText)(NSAttributedString *);
typedef UILabel *(^labelUserInteractionEnabled)(BOOL);
typedef void (^labelTapClosure)(UILabel *);

//-----UIImageView
typedef UIImageView *(^ivFrame)(CGRect);
typedef UIImageView *(^ivBackgroundColor)(UIColor *);
typedef UIImageView *(^ivAddToView)(UIView *);
typedef UIImageView *(^ivTag)(NSInteger);
typedef UIImageView *(^ivCenter)(CGPoint);
typedef UIImageView *(^ivAlpha)(CGFloat);
typedef UIImageView *(^ivUserInteractionEnabled)(BOOL);

typedef UIImageView *(^ivImage)(UIImage *);
typedef UIImageView *(^ivContentMode)(UIViewContentMode);
typedef UIImageView *(^ivLayerCornerRadius)(CGFloat);
typedef UIImageView *(^ivLayerMasksToBounds)(BOOL);
typedef UIImageView *(^ivLayerBorderColor)(UIColor *);
typedef UIImageView *(^ivLayerBorderWidth)(CGFloat);
typedef void (^imageViewTapClosure)(UIImageView *);

//-----UITableView
typedef UITableView *(^tvFrame)(CGRect);
typedef UITableView *(^tvBackgroundColor)(UIColor *);
typedef UITableView *(^tvAddToView)(UIView *);
typedef UITableView *(^tvTag)(NSInteger);
typedef UITableView *(^tvCenter)(CGPoint);
typedef UITableView *(^tvAlpha)(CGFloat);

typedef UITableView *(^tvDelegate)(id <UITableViewDelegate>);
typedef UITableView *(^tvDataSource)(id <UITableViewDataSource>);
typedef UITableView *(^tvBackgroundView)(UIView *);
typedef UITableView *(^tvSeparatorColor)(UIColor *);
typedef UITableView *(^tvSeparatorInset)(UIEdgeInsets);
typedef UITableView *(^tvSeparatorStyle)(UITableViewCellSeparatorStyle);
typedef UITableView *(^tvRowHeight)(CGFloat);
typedef UITableView *(^tvBounces)(BOOL);

//-----UIScrollView
typedef UIScrollView *(^svFrame)(CGRect);
typedef UIScrollView *(^svBackgroundColor)(UIColor *);
typedef UIScrollView *(^svAddToView)(UIView *);
typedef UIScrollView *(^svTag)(NSInteger);
typedef UIScrollView *(^svCenter)(CGPoint);
typedef UIScrollView *(^svAlpha)(CGFloat);

typedef UIScrollView *(^svDelegate)(id<UIScrollViewDelegate>);
typedef UIScrollView *(^svContentOffset)(CGPoint);
typedef UIScrollView *(^svContentSize)(CGSize);
typedef UIScrollView *(^svContentInset)(UIEdgeInsets);
typedef UIScrollView *(^svBounces)(BOOL);
typedef UIScrollView *(^svAlwaysBounceVertical)(BOOL);
typedef UIScrollView *(^svAlwaysBounceHorizontal)(BOOL);
typedef UIScrollView *(^svPagingEnabled)(BOOL);
typedef UIScrollView *(^svScrollEnabled)(BOOL);
typedef UIScrollView *(^svShowsHorizontalScrollIndicator)(BOOL);
typedef UIScrollView *(^svShowsVerticalScrollIndicator)(BOOL);
typedef UIScrollView *(^svZoomScale)(CGFloat);
typedef UIScrollView *(^svMinimumZoomScale)(CGFloat);
typedef UIScrollView *(^svMaximumZoomScale)(CGFloat);

//-----UITextField
typedef UITextField *(^tfFrame)(CGRect);
typedef UITextField *(^tfBackgroundColor)(UIColor *);
typedef UITextField *(^tfAddToView)(UIView *);
typedef UITextField *(^tfTag)(NSInteger);
typedef UITextField *(^tfCenter)(CGPoint);
typedef UITextField *(^tfAlpha)(CGFloat);

typedef UITextField *(^tfText)(NSString *);
typedef UITextField *(^tfAttributedText)(NSAttributedString *);
typedef UITextField *(^tfTextColor)(UIColor *);
typedef UITextField *(^tfFont)(UIFont *);
typedef UITextField *(^tfTextAlignment)(NSTextAlignment);
typedef UITextField *(^tfBorderStyle)(UITextBorderStyle);
typedef UITextField *(^tfPlaceholder)(NSString *);
typedef UITextField *(^tfDelegate)(id<UITextFieldDelegate>);
typedef UITextField *(^tfLeftView)(UIView *);
typedef UITextField *(^tfRightView)(UIView *);
typedef UITextField *(^tfRightViewMode)(UITextFieldViewMode);

typedef UITextField *(^tfKeyboardType)(UIKeyboardType);
typedef UITextField *(^tfTintColor)(UIColor *);
typedef UITextField *(^tfSecureTextEntry)(BOOL);

//-----UITextView
typedef UITextView *(^xvFrame)(CGRect);
typedef UITextView *(^xvBackgroundColor)(UIColor *);
typedef UITextView *(^xvAddToView)(UIView *);
typedef UITextView *(^xvTag)(NSInteger);
typedef UITextView *(^xvCenter)(CGPoint);
typedef UITextView *(^xvAlpha)(CGFloat);

typedef UITextView *(^xvDelegate)(id<UITextViewDelegate>);
typedef UITextView *(^xvText)(NSString *);
typedef UITextView *(^xvFont)(UIFont *);
typedef UITextView *(^xvTextColor)(UIColor *);
typedef UITextView *(^xvTextAlignment)(NSTextAlignment);

//-----UICollectionViewFlowLayout
typedef UICollectionViewFlowLayout *(^cvfMinimumLineSpacing)(CGFloat);
typedef UICollectionViewFlowLayout *(^cvfMinimumInteritemSpacing)(CGFloat);
typedef UICollectionViewFlowLayout *(^cvfItemSize)(CGSize);
typedef UICollectionViewFlowLayout *(^cvfScrollDirection)(UICollectionViewScrollDirection);
typedef UICollectionViewFlowLayout *(^cvfSectionInset)(UIEdgeInsets);

//-----UICollectionView
typedef UICollectionView *(^cvFrame)(CGRect);
typedef UICollectionView *(^cvBackgroundColor)(UIColor *);
typedef UICollectionView *(^cvAddToView)(UIView *);
typedef UICollectionView *(^cvTag)(NSInteger);
typedef UICollectionView *(^cvCenter)(CGPoint);
typedef UICollectionView *(^cvAlpha)(CGFloat);

typedef UICollectionView *(^cvDelegate)(id<UICollectionViewDelegate>);
typedef UICollectionView *(^cvDataSource)(id<UICollectionViewDataSource>);
typedef UICollectionView *(^cvBackgroundView)(UIView *);
typedef UICollectionView *(^cvShowsHorizontalScrollIndicator)(BOOL);
typedef UICollectionView *(^cvShowsVerticalScrollIndicator)(BOOL);
typedef UICollectionView *(^cvPagingEnabled)(BOOL);

//-----UIPickerView
typedef UIPickerView *(^pvFrame)(CGRect);
typedef UIPickerView *(^pvBackgroundColor)(UIColor *);
typedef UIPickerView *(^pvAddToView)(UIView *);
typedef UIPickerView *(^pvTag)(NSInteger);
typedef UIPickerView *(^pvCenter)(CGPoint);
typedef UIPickerView *(^pvAlpha)(CGFloat);

typedef UIPickerView *(^pvDelegate)(id<UIPickerViewDelegate>);
typedef UIPickerView *(^pvDataSource)(id<UIPickerViewDataSource>);

//-----UISearchBar

//-----UISegmentedControl

//-----UIPageControl

#endif /* BaseHeader_h */
