#import "DMPDFPage.h"
#import "DMPDFDocument.h"
#import "DMPDFUtils.h"


@implementation DMPDFPage

- (instancetype)initWithReference:(CGPDFPageRef)reference andDocument:(DMPDFDocument*)document {
    if(self = [super init]) {
        self.reference = reference;
        self.size = [DMPDFUtils pageSize:self.reference];
        self.document = document;
    }
    return self;
}

@end