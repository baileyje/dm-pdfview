#import <CoreGraphics/CoreGraphics.h>


@interface DMPdfDocument : NSObject

@property (nonatomic, readonly) NSUInteger numberOfPages;

@property (nonatomic, readonly) NSArray* pages;

- (instancetype)initWithUrl:(NSURL*)url;

@end