#import <Foundation/Foundation.h>
#import "FullBinaryTrees.h"


@interface NSPointerArray (QueueAdditions)
- (id) dequeue;
- (void)enqueue:(id)obj;
@end

@implementation NSPointerArray (QueueAdditions)
- (id) dequeue {
    
    id headObject = [self pointerAtIndex:0];
    [self removePointerAtIndex:0];
    return headObject;
}

- (void) enqueue:(id)anObject {
    [self addPointer:anObject];
}
@end

@interface Node : NSObject

@property (nonatomic, retain) Node *left;
@property (nonatomic, retain) Node *right;
+(void) levelOrderTraversal:(Node*) root;

@end

@implementation Node

- (NSString *)description{
    NSMutableString *str = [NSMutableString stringWithString:@"["];
    NSPointerArray *array = [NSPointerArray new];
    [array enqueue:self];
    Node* curr = nil;
    
    while (array.count)
    {
        curr = [array dequeue];
        if(str.length > 1){
            [str appendString:@","];
        }
        [str appendString:(curr) ? @"0" : @"null" ];
        
        if(curr){
            [array enqueue:curr.left];
        }
        
        if(curr){
            [array enqueue:curr.right];
        }
    }
    NSRange lastNodeRange = [str rangeOfString:@"0" options:NSBackwardsSearch];
    str = [[str substringToIndex:lastNodeRange.location+1] mutableCopy];
    [str appendString:@"]"];
    return str;
}
@end

@implementation FullBinaryTrees

- (NSString *)stringForNodeCount:(NSInteger)count {
    if(count % 2 == 0) return @"[]";
    
    NSArray<Node *> *trees = [self buildTrees:count];
    NSMutableString *result = [NSMutableString stringWithString:@"["];
    for(Node *tree in trees){
        [result appendString:tree.description];
    }
    [result appendString:@"]"];
    return result;
}

-(NSArray<Node *>*)buildTrees:(NSInteger)count{
    NSMutableDictionary *treeCache = [NSMutableDictionary new];
    if(![treeCache objectForKey:@(count)]){
        NSMutableArray *trees = [NSMutableArray new];
        if(count == 1){
            [trees addObject:[Node new]];
        } else if(count % 2 == 1){
            for(int i = 0; i < count; i++){
                int j = count - 1 - i;
                for(Node *left in [self buildTrees:i]){
                    for(Node *right in [self buildTrees:j]){
                        Node *node = [Node new];
                        node.left = left;
                        node.right = right;
                        [trees addObject:node];
                    }
                }
            }
        }
        treeCache[@(count)] = trees;
    }
    return [[treeCache objectForKey:@(count)] copy];
}

@end
