#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class DMPDFDocument;

@interface DMPDFPage : NSObject

@property (nonatomic, assign) DMPDFDocument* document;

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, readonly) NSUInteger number;

- (instancetype)initWithReference:(CGPDFPageRef)reference andDocument:(DMPDFDocument*)document;

- (void)renderInto:(CGContextRef)context;

- (void)renderInto:(CGContextRef)context withSize:(CGSize)constraint;

- (UIImage*)asImage;

- (UIImage*)asImageWithSize:(CGSize)size;

@end