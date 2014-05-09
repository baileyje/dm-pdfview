#import "DMPDFUtils.h"


@implementation DMPDFUtils


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

+ (void)render:(CGPDFPageRef)page into:(CGContextRef)context withSize:(CGSize)constraint {
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, CGRectMake(0, 0, constraint.width, constraint.height));
    CGContextGetCTM(context);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -constraint.height);
    CGRect mediaRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGContextScaleCTM(context, constraint.width / mediaRect.size.width, constraint.height / mediaRect.size.height);
    CGContextTranslateCTM(context, -mediaRect.origin.x, -mediaRect.origin.y);
    CGContextDrawPDFPage(context, page);
}

+ (UIImage*)renderImage:(CGPDFPageRef)page withSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [self render:page into:UIGraphicsGetCurrentContext() withSize:size];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end