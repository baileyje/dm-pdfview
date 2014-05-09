#import <CoreGraphics/CoreGraphics.h>


@interface DMPDFDocument : NSObject

@property (nonatomic) CGPDFDocumentRef reference;

@property (nonatomic) NSUInteger numberOfPages;

@property (nonatomic, strong) NSArray* pages;


- (instancetype)initWithUrl:(NSURL*)url;

@end