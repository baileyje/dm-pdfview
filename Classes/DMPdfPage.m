#import "DMPdfPage.h"
#import "DMPdfDocument.h"

@interface DMPdfDocument (internal)
-(CGPDFDocumentRef)reference;
@end

@interface DMPdfPage ()

@property (nonatomic) CGSize size;

@property (nonatomic) NSUInteger number;

@end

@implementation DMPdfPage

- (instancetype)initWithReference:(CGPDFPageRef)reference andDocument:(DMPdfDocument*)document {
    if(self = [super init]) {
        self.size = [DMPdfPage pageSize:reference];
        self.number = CGPDFPageGetPageNumber(reference);
        self.document = document;
    }
    return self;
}

- (void)renderInto:(CGContextRef)context {
    [self renderInto:context withSize:self.size];
}

- (void)renderInto:(CGContextRef)context withSize:(CGSize)constraint {
    if(self.document == nil) return;
    CGPDFDocumentRef documentReference = self.document.reference;
    CGPDFPageRef pageReference = CGPDFDocumentGetPage(documentReference, self.number);
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, CGRectMake(0, 0, constraint.width, constraint.height));
    CGContextGetCTM(context);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -constraint.height);
    CGRect mediaRect = CGPDFPageGetBoxRect(pageReference, kCGPDFCropBox);
    CGContextScaleCTM(context, constraint.width / mediaRect.size.width, constraint.height / mediaRect.size.height);
    CGContextTranslateCTM(context, -mediaRect.origin.x, -mediaRect.origin.y);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, pageReference);
    CGPDFDocumentRelease(documentReference);
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

@end