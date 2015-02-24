//
//  ViewController.m
//  CompiladoresPrimerParcial
//
//  Created by Mau Vela on 23/02/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SimpleStack.h";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    

    // Do any additional setup after loading the view, typically from a nib.
    convertir.layer.cornerRadius = 5; // this value vary as per your desire
    convertir.clipsToBounds = YES;
    expresion.layer.cornerRadius = 5; // this value vary as per your desire
    expresion.clipsToBounds = YES;
    resultado.layer.cornerRadius = 5; // this value vary as per your desire
    resultado.clipsToBounds = YES;
    bg.layer.cornerRadius = 5; // this value vary as per your desire
    bg.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(IBAction)convertir:(id)sender{
  
    
    if ( ! [self esExpBalanceada:expresion.text]){
        NSLog(@"Expresion no balanceada, revice sus ""("" y "")""");
        resultado.text=@"Expresion no balanceada, revice sus (  )";
    }else{
        /*unichar c;

        NSMutableArray * caracteres = [NSMutableArray arrayWithCapacity:[expresion.text length]];
        for (int i=0; i<caracteres.count; i++) {
            c = [expresion.text characterAtIndex: i];

            switch (c) {
                case <#constant#>:
                    <#statements#>
                    break;
                    
                default:
                    break;
            }
        }*/
        SimpleStack * opStack = [[SimpleStack alloc] init];
        NSMutableString * output = [NSMutableString stringWithCapacity:[expresion.text length]];
        
        [opStack print];
        
        NSArray * tokens = [self tokenize: expresion.text];
        for (NSString *token in tokens){
            if ([self precedenceOf:token] != 0){
                // token is an operator, pop all operators of higher or equal precedence off the stack, and append them to the output
                NSString *op = [opStack peek];
                while (op && [self precedenceOf:op] != 0 &&
                       [self precedenceOf: op isHigherOrEqualThan: token]) {
                    [output appendString: [NSString stringWithFormat: @"%@ ", [opStack pop]]];
                    op = [opStack peek];
                }
                // then push the operator on the stack
                [opStack push:token];
                
                [opStack print];
                
            } else if ([token compare: @"("] ==0){
                // push opening brackets on the stack, will be dismissed later
                [opStack push:token];
            } else if ([token compare: @")"] ==0) {
                // closing bracket :
                // pop operators off the stack and append them to the output while the popped element is not the opening bracket
                NSString  * op = [opStack pop];
                while ( op  && ([op compare: @"("] != 0)){
                    [output appendString: [NSString stringWithFormat: @"%@ ", op]];
                    op = [opStack pop];
                }
                if ( ! op || ([op compare: @"("]  != 0)){
                    NSLog(@"Error : unbalanced brackets in expression");
                }
            } else {
                //token is an operand, append it to the output
                [output appendString: [NSString stringWithFormat: @"%@ ", token]];
            }
            
            [opStack print];
            
        }
        
        //pop remaining operators off the stack, and append them to the output
        while (! [opStack empty]) {
            [output appendString: [NSString stringWithFormat: @"%@ ", [opStack pop]]];
        }
        
        
        resultado.text=[NSString stringWithFormat:@"%@", [output stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
    }
}
- (NSArray*) tokenize: (NSString*) expression {
    NSMutableArray * tokens = [NSMutableArray arrayWithCapacity:[expression length]];
    
    unichar c;
    NSMutableString * numberBuf = [NSMutableString stringWithCapacity: 5];
    int length = [expression length];
    BOOL nextMinusSignIsNegativeOperator = YES;
    
    for (int i = 0; i< length; i++){
        c = [expression characterAtIndex: i];
        switch (c) {
            case '+':
            case '|':
            case '*':
            case '^':
                nextMinusSignIsNegativeOperator = YES;
                [self addNumber: numberBuf andToken: c toTokens:tokens];
                break;
            case '(':
            case ')':
                nextMinusSignIsNegativeOperator = NO;
                [self addNumber: numberBuf andToken: c toTokens:tokens];
                break;
            case '-':
                if (nextMinusSignIsNegativeOperator){
                    nextMinusSignIsNegativeOperator = NO;
                    [numberBuf appendString : [NSString stringWithCharacters: &c length:1]];
                } else {
                    nextMinusSignIsNegativeOperator = YES;
                    [self addNumber: numberBuf andToken: c toTokens:tokens];
                }
                
                break;
            case 'A':
            case 'B':
            case 'C':
            case 'D':
            case 'E':
            case 'F':
            case 'G':
            case 'H':
            case 'I':
            case 'J':
            case '.':
                nextMinusSignIsNegativeOperator = NO;
                [numberBuf appendString : [NSString stringWithCharacters: &c length:1]];
                break;
            case ' ':
                break;
            default:
                NSLog(@"Unsupported character in input expression : %c, discarding.", c);
                break;
        }
    }
    if ([numberBuf length] > 0)
        [tokens addObject:  [NSString stringWithString: numberBuf]];
    
    return tokens;
}
- (void) addNumber:(NSMutableString*) numberBuf andToken:(unichar) token toTokens : (NSMutableArray*) tokens{
    if ([numberBuf length] > 0){
        [tokens addObject:  [NSString stringWithString: numberBuf]];
        [numberBuf setString:@""];
    }
    [tokens addObject: [NSString stringWithCharacters: &token length:1]];
}


- (BOOL) precedenceOf: (NSString*) operator isHigherOrEqualThan: (NSString*) otherOperator{
    return  [self precedenceOf: operator]  >=  [self precedenceOf: otherOperator];
}

- (NSUInteger) precedenceOf: (NSString*) operator{
    if ([operator compare: @"+"] == 0 )
        return 1;
    else if ([operator compare: @"-"] == 0 )
        return 1;
   // else if ([operator compare: @""] == 0 )
     //   return 2;
    else if ([operator compare: @"|"] == 0 )
        return 2;
    else if ([operator compare: @"^"] == 0 )
        return 3;
    else //invalid operator
        return 0;
}

-(BOOL)esExpBalanceada:(NSString*)expresionS{
    BOOL balanceado;
    unichar c;
    int opened = 0, closed = 0;
    
    for (int i = 0; i< [expresionS length] ; i++){
        c = [expresionS characterAtIndex: i];
        if (c == '(') opened++;
        else if (c == ')') closed++;
    }
    
    
    balanceado= opened == closed;
    
    return  balanceado;
}
@end
