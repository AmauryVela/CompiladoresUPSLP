//
//  ViewController.m
//  CompiladoresPrimerParcial
//
//  Created by Mau Vela on 23/02/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SimpleStack.h"
#import "HistorialCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

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
    historial.layer.cornerRadius = 5; // this value vary as per your desire
    historial.clipsToBounds = YES;

    tempArray=[[NSMutableArray alloc] init];
    NSUserDefaults*AppData=[NSUserDefaults standardUserDefaults];
    NSString*cachePortada=[NSString stringWithFormat:@"%@",[AppData objectForKey:@"cacheData"]];
    //NSLog(@"%@",cachePortada);
    if (![cachePortada isEqualToString:@"(null)"]) {
        NSString *string = cachePortada;
        //NSLog(string);
        NSData * jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
        tempArray= [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        [historial reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}
-(NSString*)checkStringAndAdd{
    
    NSArray * tokens = [self tokenize: expresion.text];
    for (NSString *token in tokens){
         if ([token compare: @"("] ==0){
            // push opening brackets on the stack, will be dismissed later
        }
        NSLog(@"Es: %@",token);
    }
    
    
    NSMutableArray *letterArray = [NSMutableArray array];
    NSString *letters = expresion.text;
    [letters enumerateSubstringsInRange:NSMakeRange(0, [letters length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [letterArray addObject:substring];
                             }];
    NSString*test=@"";
   int x=0;
    for (NSString *i in letterArray){
        if (x<letterArray.count-1) {
            NSString*sig=[letterArray objectAtIndex:x+1];
            NSString*ptemp=test;

            
            
            
            
            if (![[letterArray objectAtIndex:x] isEqualToString:@"*"]) {
                if (![[letterArray objectAtIndex:x] isEqualToString:@"?"]) {
                    if (![[letterArray objectAtIndex:x] isEqualToString:@"|"]) {
                        if (![[letterArray objectAtIndex:x] isEqualToString:@"+"]) {
                            test=[NSString stringWithFormat:@"%@%@",ptemp,[letterArray objectAtIndex:x]];
                            NSLog(@"%@ y %d elquesigue %@ cadena %@",i,x,sig,test);
                            if (![sig isEqualToString:@"*"]) {
                                if (![sig isEqualToString:@"?"]) {
                                    if (![sig isEqualToString:@"|"]) {
                                        if (![sig isEqualToString:@"+"]) {
                                            NSString*ptempd=test;
                                            if ([sig isEqualToString:@" "]) {
                                                

                                            }else{
                                                test=[NSString stringWithFormat:@"%@.",ptempd];

                                            }
                                        }
                                    }
                                }
                            }

                        }else{
                            test=[NSString stringWithFormat:@"%@%@",ptemp,[letterArray objectAtIndex:x]];
                        }
                    }
                    else{
                        test=[NSString stringWithFormat:@"%@%@",ptemp,[letterArray objectAtIndex:x]];

                        
                    }
                }else{
                    test=[NSString stringWithFormat:@"%@%@",ptemp,[letterArray objectAtIndex:x]];
                }
            }else{
                test=[NSString stringWithFormat:@"%@%@",ptemp,[letterArray objectAtIndex:x]];
            }
            
            
            
                    }
       
        x++;
    }
    NSLog(@"*********%@*******",test);
    return test;

}
-(IBAction)convertorPun:(id)sender{
    expresion.text=[expresion.text uppercaseString];
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
        NSDictionary*tmp=@{@"Inf":expresion.text,@"pos":resultado.text};
        [self guardarHistorial:tmp];
    }

}
-(IBAction)convertir:(id)sender{
    expresion.text=[expresion.text uppercaseString];
     expresion.text=[self checkStringAndAdd];
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
        NSDictionary*tmp=@{@"Inf":expresion.text,@"pos":resultado.text};
        [self guardarHistorial:tmp];
           }
}
-(void)guardarHistorial:(NSDictionary*)dic{
    NSMutableArray*es=[[NSMutableArray alloc] init];
    
    [es addObject:dic];
    for (int s=0; s<tempArray.count; s++) {
        [es addObject:[tempArray objectAtIndex:s]];
    }
    tempArray=[[NSMutableArray alloc] initWithArray:es];
    [historial reloadData];
    [[self view] endEditing:YES];
    NSError *error;
    
    NSData       *finalData  = [NSJSONSerialization dataWithJSONObject:tempArray options:0 error:&error];
    
    NSLog(@"Error: %@",error);
    NSString *string = [[NSString alloc] initWithData:finalData encoding:NSUTF8StringEncoding];
    NSUserDefaults*AppData=[NSUserDefaults standardUserDefaults];
    [AppData setObject:string forKey:@"cacheData" ];
    [AppData synchronize];

}
- (NSArray*) tokenize: (NSString*) expression {
    NSMutableArray * tokens = [NSMutableArray arrayWithCapacity:[expression length]];
    
    unichar c;
    NSMutableString * numberBuf = [NSMutableString stringWithCapacity: 5];
    int length = [expression length];
    BOOL nextMinusSignIsNegativeOperator = YES;
    
    for (int i = 0; i< length; i++){
        c = [expression characterAtIndex: i];
        NSLog(@"Tiene %c ",c);

        switch (c) {
            case '+':
            case '|':
            case '*':
                case '.':
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
            case 'K':
            case 'L':
            case 'M':
            case 'N':
            case 'O':
            case 'P':
            case 'Q':
            case 'R':
            case '?':

            case 'd':
                nextMinusSignIsNegativeOperator = NO;
                [numberBuf appendString : [NSString stringWithCharacters: &c length:1]];
                break;
            case ' ':
                break;
            default:
                NSLog(@"carcater ignorado %c", c);
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
    if ([operator compare: @"-"] == 0 )
        return 1;
    else if ([operator compare: @"."] == 0 ){
        NSLog(@"Tiene . ");
        return 2;}
    else if ([operator compare: @"?"] == 0 )
       return 2;
    else if ([operator compare: @"|"] == 0 )
        return 1;
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


#pragma  mark tableview
#pragma table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tempArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MaillCellC = @"HistorialCell";
    HistorialCell *cell = (HistorialCell *)[historial dequeueReusableCellWithIdentifier:MaillCellC];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistorialCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.posf.text=[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:indexPath.row]objectForKey:@"pos"]];
    cell.inf.text=[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:indexPath.row]objectForKey:@"Inf"]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    expresion.text=[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:indexPath.row]objectForKey:@"Inf"]];
}

@end
