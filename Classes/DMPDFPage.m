#import <UIKit/UIKit.h>
#import "DMPDFPage.h"
#import "DMPDFDocument.h"

@interface DMPDFPage()
@property (nonatomic) CGPDFPageRef reference;

@property (nonatomic) CGSize size;

@property (nonatomic) NSUInteger number;
@end

@implementation DMPDFPage

- (instancetype)initWithReference:(CGPDFPageRef)reference andDocument:(DMPDFDocument*)document {
    if(self = [super init]) {
        self.reference = reference;
        CGPDFPageRetain(self.reference);
        self.size = [DMPDFPage pageSize:self.reference];
        self.number = CGPDFPageGetPageNumber(reference);
        self.document = document;
    }
    return self;
}

- (void)renderInto:(CGContextRef)context {
    [self renderInto:context withSize:self.size];
}

- (void)renderInto:(CGContextRef)context withSize:(CGSize)constraint {
    if(self.reference == NULL) return;
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, CGRectMake(0, 0, constraint.width, constraint.height));
    CGContextGetCTM(context);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -constraint.height);
    CGRect mediaRect = CGPDFPageGetBoxRect(self.reference, kCGPDFCropBox);
    CGContextScaleCTM(context, constraint.width / mediaRect.size.width, constraint.height / mediaRect.size.height);
    CGContextTranslateCTM(context, -mediaRect.origin.x, -mediaRect.origin.y);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, self.reference);
}

- (UIImage*)asImage {
    return [self asImageWithSize:self.size];
}

- (UIImage*)asImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [self renderInto:UIGraphicsGetCurrentContext() withSize:size];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGSize)pageSize:(CGPDFPageRef)page {
    CGRect cropBox = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGRect mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGRect effectiveRect = CGRectIntersection(cropBox, mediaBox);
    NSInteger pageRotate = CGPDFPageGetRotationAngle(page);
    switch (pageRotate) {
        default:
        case 0:
        case 180: {
            return CGSizeMake(effectiveRect.size.width, effectiveRect.size.height);
        }
        case 90:
        case 270: {
            return CGSizeMake(effectiveRect.size.height, effectiveRect.size.width);
        }
    }
}

- (void)dealloc {
    NSLog(@"Page DEALLOC");
    if(self.reference != NULL) {
        CGPDFPageRelease(self.reference);
    }
    self.reference = NULL;
}


@end