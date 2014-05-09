#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface DMPDFUtils : NSObject

+ (CGSize)pageSize:(CGPDFPageRef)page;

+ (void)render:(CGPDFPageRef)page into:(CGContextRef)context withSize:(CGSize)constraint;

+ (UIImage*)renderImage:(CGPDFPageRef)page withSize:(CGSize)size;

+ (BOOL)isRetina;

@end