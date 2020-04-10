#import "SquareDecomposer.h"

@interface NSArray (AggregationExtensions)

-(long long)squaredSum;

@end

@implementation NSArray (AggregationExtensions)

- (long long)squaredSum{
    __block long long result = 0;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        result += pow([obj longLongValue], 2);
    }];
    return result;
}

@end

@implementation SquareDecomposer
- (NSArray <NSNumber*>*)decomposeNumber:(NSNumber*)number {
    long num = [number longLongValue];
    long squaredNum = pow(num, 2);
    if(num < 5) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray new];
    [result addObject:@(num-1)];
    [self getCurrentSum: result onLevel:1 forNum:squaredNum andReminder:squaredNum - pow(num-1,2)];
    return [result sortedArrayUsingSelector:@selector(compare:)];
}

-(void)getCurrentSum:(NSMutableArray *)resultArray onLevel:(int)level forNum:(long long)num andReminder:(long long)reminder{
    long numSqrt = floor(sqrt(reminder));
    if(numSqrt == 0) return;
    if([resultArray containsObject:@(numSqrt)]) return;
    if([resultArray count] >= level + 1){
        resultArray[level] = @(numSqrt);
    } else {
        [resultArray addObject:@(numSqrt)];
    }
    
    while (1) {
        reminder = num - [resultArray squaredSum];
        if(reminder == 1) return;
        [self getCurrentSum:resultArray onLevel:level+1 forNum:num andReminder:reminder];
        if([resultArray squaredSum] == num) return;
        if(numSqrt == 1) return;
        numSqrt--;
        if([resultArray containsObject:@(numSqrt)]) return;
        resultArray[level] = @(numSqrt);
        [resultArray removeObjectsInRange:NSMakeRange(level+1, [resultArray count] - (level + 1))];
    }
}
@end
