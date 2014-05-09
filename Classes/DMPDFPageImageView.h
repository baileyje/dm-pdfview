#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DMPDFPageImageView : UIView

@property (nonatomic) CGSize pageSize;

- (instancetype)initWithFrame:(CGRect)frame page:(CGPDFPageRef)page;

@end