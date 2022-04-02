//
// Autogenerated by gaxb at 05:30:05 PM on 01/17/13
//

#import "Galaxy_Planet.h"

@implementation Galaxy_Planet

- (NSString *) hasRingsAnswerString
{
    NSArray *answers = nil;
    if (hasRings)
    {
        answers = @[@"Yes.", @"Definitely.", @"Totally.", @"At least one.", @"Certainly.", @"Positively.", @"Of course it does.", @"Indeed.", @"You bet.", @"'Tis incontestably ringed.", @"Clearly."];
    }
    else
    {
        answers = @[@"No.", @"Nope.", @"Nah.", @"Absolutely not.", @"No way.", @"Negative.", @"'Tis indubitably ringless."];
    }
    
    return answers[arc4random()%[answers count]];
}

@end