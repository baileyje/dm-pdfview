#import "DMPDFDocument.h"
#import "DMPDFPage.h"

@interface DMPDFDocument()

@property (nonatomic, copy) NSURL* url;

@property (nonatomic) CGPDFDocumentRef reference;

@property (nonatomic) NSUInteger numberOfPages;

@property (nonatomic, strong) NSArray* pages;
@end

@implementation DMPDFDocument

- (instancetype)initWithUrl:(NSURL*)url {
    if(self = [super init]) {
        self.url = url;
        self.reference = CGPDFDocumentCreateWithURL((__bridge CFURLRef) url);
        self.numberOfPages = CGPDFDocumentGetNumberOfPages(self.reference);
        NSMutableArray* pages = [NSMutableArray arrayWithCapacity:self.numberOfPages];
        for (NSUInteger pageNumber = 1; pageNumber <= self.numberOfPages; pageNumber++) {
            [pages addObject:[[DMPDFPage alloc] initWithReference:CGPDFDocumentGetPage(self.reference, pageNumber) andDocument:self]];
        }
        self.pages = [NSArray arrayWithArray:pages];
    }
    return self;
}

#pragma mark - NSObject

- (void)dealloc {
    NSLog(@"DEALLOC");
    if(self.reference != NULL) {
        CGPDFDocumentRelease(self.reference);
        self.reference = nil;
    }
}

@end