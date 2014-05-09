#import <CoreGraphics/CoreGraphics.h>


@interface DMPDFDocument : NSObject

@property (nonatomic, readonly) CGPDFDocumentRef reference;

@property (nonatomic, readonly) NSUInteger numberOfPages;

@property (nonatomic, readonly) NSArray* pages;

- (instancetype)initWithUrl:(NSURL*)url;

@end