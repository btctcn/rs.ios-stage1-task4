#import "ArrayCalculator.h"

@implementation ArrayCalculator
+ (NSInteger)maxProductOf:(NSInteger)numberOfItems itemsFromArray:(NSArray *)array {
    NSMutableArray *numArray = [[[NSMutableArray alloc]init] autorelease];
    NSMutableArray *negativeArray = [[[NSMutableArray alloc]init] autorelease];
    NSMutableArray *positiveArray = [[[NSMutableArray alloc]init] autorelease];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSNumber class]]){
            [numArray addObject:obj];
            int val = [obj intValue];
            NSMutableArray *arrayToAdd = nil;
            if(val > 0){
                arrayToAdd = positiveArray;
            } else if (val < 0){
                arrayToAdd = negativeArray;
            }
            if(arrayToAdd) {
                [arrayToAdd addObject:@(val)];
            }
        }
    }];
    
    if(!numArray.count) {
        return 0;
    }
    
    if(numberOfItems >= numArray.count){
        __block int result = 1;
        [numArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            result *= [(NSNumber*)obj intValue];
        }];
        return  result;
    }
    BOOL canUseNegative = numberOfItems % 2 == 0 && negativeArray.count >= 2;
    NSArray *sortedArray;
    if(!canUseNegative){
        sortedArray = [positiveArray sortedArrayUsingSelector:@selector(compare:)];
    } else {
        sortedArray = [numArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            int v1 = abs([obj1 intValue]);
            int v2 = abs([obj2 intValue]);
            if(v1 < abs(v2))
                return NSOrderedAscending;
            if(v1 > v2)
                return NSOrderedDescending;
            return NSOrderedSame;
        }];
    }
    
    NSEnumerator *enumerator = [sortedArray reverseObjectEnumerator];
    int result = 1;
    while (numberOfItems > 0) {
        result *= [[enumerator nextObject] intValue];
        numberOfItems--;
    }
    return result;
}
@end
