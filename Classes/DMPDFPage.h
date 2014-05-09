#import <CoreGraphics/CoreGraphics.h>

@class DMPDFDocument;


@interface DMPDFPage : NSObject

@property (nonatomic, assign) DMPDFDocument* document;

@property (nonatomic) CGPDFPageRef reference;

@property (nonatomic) CGSize size;

- (instancetype)initWithReference:(CGPDFPageRef)reference andDocument:(DMPDFDocument*)document;

@end