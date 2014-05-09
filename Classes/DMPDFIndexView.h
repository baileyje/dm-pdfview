#import <UIKit/UIKit.h>

@protocol DMPDFIndexViewDelegate
- (void)indexPageSelected:(NSUInteger)page;
@end


@interface DMPDFIndexView : UIView

@property (nonatomic, assign) id<DMPDFIndexViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andDocument:(CGPDFDocumentRef)document;

- (void)highlight:(NSUInteger)page;

@end