//
//  DFS.m
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 4/30/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "DFS.h"
#import "SimpleStack.h"
@interface DFS ()

@end

@implementation DFS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   /* NSString* path = [[NSBundle mainBundle] pathForResource:@"archivo"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSLog(@"cont: %@",content);
    NSData * jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    datos= [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSLog(@"Datos: %lu",(unsigned long)datos.count);
    NSLog(@"JSON: %@",datos);
    dfsString=@"";*/
   // [self getNode:[datos objectAtIndex:0]];
}

-(void)generarArbol: (NSString*)expre{
   // NSString*expre=@"B*C?.A+B.|#.";
    NSMutableArray *letterArray = [NSMutableArray array];
    NSString *letters = expre;
    [letters enumerateSubstringsInRange:NSMakeRange(0, [letters length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [letterArray addObject:substring];
                             }];
    int apuntador=0;
    NSDictionary*nodoIzqTmp;
    NSMutableArray*nodos=[[NSMutableArray alloc] init];
    for (int i=0; i<letterArray.count; i++) {
        NSString*caracter=[letterArray objectAtIndex:i];
        NSLog(@"Ingresa caracter: %@ ",caracter);
        if ([caracter isEqualToString:@"+"]||[caracter isEqualToString:@"*"]||[caracter isEqualToString:@"?"]) {
            //Tiene un hijo que es el hijo izq
           NSDictionary* nodoTmp=@{@"Nodo":caracter,@"Izq":[nodos objectAtIndex:nodos.count-1]};
           // NSLog(@"Crea un nodo con hijo Izquierdo: %@",nodoTmp);
            [nodos removeObjectAtIndex:nodos.count-1];
            [nodos addObject:nodoTmp];
        }else if ([caracter isEqualToString:@"."]||[caracter isEqualToString:@"|"]){
            //Es padre con 2 hijos
            NSDictionary*nodoTmp=@{@"Nodo":caracter,@"Izq":[nodos objectAtIndex:nodos.count-2],@"Der":[nodos objectAtIndex:nodos.count-1]};
            NSLog(@"Crea un Padre: %@",nodoTmp);
            [nodos removeObjectAtIndex:nodos.count-1];
            if (nodos.count>=2) {
                [nodos removeObjectAtIndex:nodos.count-1];
                //NSLog(@"********");
            }
            [nodos addObject:nodoTmp];
        }else{
                nodoIzqTmp=@{@"Nodo":caracter};
                [nodos addObject:nodoIzqTmp];
                apuntador=1;
        }
    }
   // NSLog(@"Al final: %@",[nodos objectAtIndex:1]);
    NSError *error;
    NSMutableArray*ObjetoFinal=[[NSMutableArray alloc]init];
    [ObjetoFinal addObject:[nodos lastObject]];
    NSData       *finalDataz  = [NSJSONSerialization dataWithJSONObject:ObjetoFinal options:0 error:&error];
    
    NSLog(@"Error: %@",error);
    NSString *string = [[NSString alloc] initWithData:finalDataz encoding:NSUTF8StringEncoding];
    NSData * jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    datos= [NSJSONSerialization JSONObjectWithData:finalDataz options:0 error:&error];
    NSLog(@"Datos: %lu",(unsigned long)datos.count);
    NSLog(@"JSON: %@",datos);
    dfsString=@"";
    [self getNode:[datos objectAtIndex:0]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNode:(NSMutableDictionary*)objeto{
    NSString*Nodo=[objeto objectForKey:@"Nodo"];
    dfsString=[NSString stringWithFormat:@"%@%@",dfsString,Nodo];
    NSDictionary*izqNodo=[objeto objectForKey:@"Izq"];
    NSDictionary*derNodo=[objeto objectForKey:@"Der"];
    if (izqNodo !=nil) {
        //tiene Hijo Izquierdo
        [self getNode:[objeto objectForKey:@"Izq"]];
    }
    if (derNodo!=nil) {
        //tiene Hijo Derecho
        [self getNode:[objeto objectForKey:@"Der"]];
    }
    NSLog(@"%@",dfsString);
    resultado.text=dfsString;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}
#pragma mark conversorPolaka
-(IBAction)convertorPun:(id)sender{
    expresionField.text=[expresionField.text uppercaseString];
    if ( ! [self esExpBalanceada:expresionField.text]){
        NSLog(@"Expresion no balanceada, revice sus ""("" y "")""");
        resultado.text=@"Expresion no balanceada, revice sus (  )";
    }else{
        
        SimpleStack * opStack = [[SimpleStack alloc] init];
        NSMutableString * output = [NSMutableString stringWithCapacity:[expresionField.text length]];
        
        [opStack print];
        
        NSArray * tokens = [self tokenize: expresionField.text];
        for (NSString *token in tokens){
            if ([self precedenceOf:token] != 0){
                // token is an operator, pop all operators of higher or equal precedence off the stack, and append them to the output
                NSString *op = [opStack peek];
                while (op && [self precedenceOf:op] != 0 &&
                       [self precedenceOf: op isHigherOrEqualThan: token]) {
                    [output appendString: [NSString stringWithFormat: @"%@", [opStack pop]]];
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
                    [output appendString: [NSString stringWithFormat: @"%@", op]];
                    op = [opStack pop];
                }
                if ( ! op || ([op compare: @"("]  != 0)){
                    NSLog(@"Error : unbalanced brackets in expression");
                }
            } else {
                //token is an operand, append it to the output
                [output appendString: [NSString stringWithFormat: @"%@", token]];
            }
            
            [opStack print];
            
        }
        
        //pop remaining operators off the stack, and append them to the output
        while (! [opStack empty]) {
            [output appendString: [NSString stringWithFormat: @"%@", [opStack pop]]];
        }
        
        
        resultado.text=[NSString stringWithFormat:@"%@", [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString *trimmed = [[NSString stringWithFormat:@"%@", output] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSLog(@"****: %@",[NSString stringWithFormat:@"%@", trimmed]);

        [self generarArbol: [NSString stringWithFormat:@"%@",trimmed]];
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
            case '#':
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


@end
