#import <UIKit/UIKit.h>

@class DMPDFDocument;

@protocol DMPDFIndexViewDelegate
- (void)indexPageSelected:(NSUInteger)page;
@end


@interface DMPDFIndexView : UIView

@property (nonatomic, assign) id<DMPDFIndexViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andDocument:(DMPDFDocument*)document;

- (void)highlight:(NSUInteger)page;

@end