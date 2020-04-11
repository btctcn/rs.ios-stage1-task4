#import "TelephoneFinder.h"

@implementation TelephoneFinder
- (NSArray <NSString*>*)findAllNumbersFromGivenNumber:(NSString*)number {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([number rangeOfCharacterFromSet:notDigits].location != NSNotFound) return nil;
    
    NSDictionary *n = @{
        @1:@[@"2",@"4"],
        @2:@[@"1",@"3",@"5"],
        @3:@[@"2",@"6"],
        @4:@[@"1",@"5",@"7"],
        @5:@[@"2",@"4",@"6",@"8"],
        @6:@[@"3",@"5",@"9"],
        @7:@[@"4",@"8"],
        @8:@[@"5",@"7",@"9",@"0"],
        @9:@[@"6",@"8"],
        @0:@[@"8"]
    };
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [number enumerateSubstringsInRange:NSMakeRange(0, number.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        int cnt =  [[n objectForKey: @(substring.intValue)] count];
        for(int i = 0; i < cnt; i++){
            [result addObject:[number mutableCopy]];
        }
    }];
    
    [self changeSymbol:0 forLines:result andDictionary:n startingFrom:0];
    return result;
}

-(void) changeSymbol:(int)position forLines:(NSMutableArray *)lines andDictionary:(NSDictionary *)dict startingFrom:(int)startFrom{
    __block int startFromBlock = startFrom;
    if(position == ((NSString*)lines[0]).length) return;
    [lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx < startFrom) return;
        NSString *str = (NSString *)obj;
        NSArray *currentNumbers = [dict objectForKey:@([[str substringWithRange:NSMakeRange(position, 1)] intValue])];
        lines[idx] = [str stringByReplacingCharactersInRange:NSMakeRange(position, 1) withString:currentNumbers[idx-startFrom]];
        
        if(idx-startFrom + 1 == currentNumbers.count){
            *stop = YES;
            startFromBlock += [currentNumbers count];
            [self changeSymbol:position+1 forLines:lines andDictionary:dict startingFrom:startFromBlock];
        }
    }];
}
@end
