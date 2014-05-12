#import "DMPdfDocument.h"
#import "DMPdfPage.h"

@interface DMPdfDocument ()

@property (nonatomic, copy) NSURL* url;

@property (nonatomic) NSUInteger numberOfPages;

@property (nonatomic, strong) NSArray* pages;

@end

@implementation DMPdfDocument

- (instancetype)initWithUrl:(NSURL*)url {
    if(self = [super init]) {
        self.url = url;
        CGPDFDocumentRef reference = self.reference;
        self.numberOfPages = CGPDFDocumentGetNumberOfPages(reference);
        NSMutableArray* pages = [NSMutableArray arrayWithCapacity:self.numberOfPages];
        for (NSUInteger pageNumber = 1; pageNumber <= self.numberOfPages; pageNumber++) {
            [pages addObject:[[DMPdfPage alloc] initWithReference:CGPDFDocumentGetPage(reference, pageNumber) andDocument:self]];
        }
        self.pages = [NSArray arrayWithArray:pages];
        CGPDFDocumentRelease(reference);
    }
    return self;
}

- (CGPDFDocumentRef)reference {
    return CGPDFDocumentCreateWithURL((__bridge CFURLRef) self.url);
}

@end