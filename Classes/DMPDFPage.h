#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class DMPdfDocument;

@interface DMPdfPage : NSObject

@property (nonatomic, assign) DMPdfDocument* document;

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, readonly) NSUInteger number;

- (instancetype)initWithReference:(CGPDFPageRef)reference andDocument:(DMPdfDocument*)document;

- (void)renderInto:(CGContextRef)context;

- (void)renderInto:(CGContextRef)context withSize:(CGSize)constraint;

- (UIImage*)asImage;

- (UIImage*)asImageWithSize:(CGSize)size;

@end