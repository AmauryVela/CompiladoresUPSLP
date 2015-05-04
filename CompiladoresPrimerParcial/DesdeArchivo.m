//
//  DesdeArchivo.m
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 2/26/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "DesdeArchivo.h"
#import "ArchivoCell.h"
#import "SimpleStack.h"

@interface DesdeArchivo ()

@end

@implementation DesdeArchivo

- (void)viewDidLoad {
    [super viewDidLoad];
    bg.layer.cornerRadius = 5; // this value vary as per your desire
    bg.clipsToBounds = YES;
    tabla.layer.cornerRadius = 5; // this value vary as per your desire
    tabla.clipsToBounds = YES;

    
    // Do any additional setup after loading the view.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"archivo3"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSLog(@"cont: %@",content);
    NSData * jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    datos= [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSLog(@"Datos: %lu",(unsigned long)datos.count);
    [tabla reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark tableview
#pragma table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MaillCellC = @"ArchivoCell";
    ArchivoCell *cell = (ArchivoCell *)[tabla dequeueReusableCellWithIdentifier:MaillCellC];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ArchivoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.exp.text=[[datos objectAtIndex:indexPath.row] objectForKey:@"Exp"];
     cell.posible.text=[[datos objectAtIndex:indexPath.row] objectForKey:@"Pos"];
    NSString*resp=[self getRespuesta:[[datos objectAtIndex:indexPath.row]objectForKey:@"Exp"]];
    cell.respuesta.text=[resp stringByReplacingOccurrencesOfString:@" " withString:@""] ;
   

    if ([ [resp stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[[datos objectAtIndex:indexPath.row] objectForKey:@"Pos"]]) {
        cell.resultado.text=@"Correcto";
        cell.resultado.textColor=[UIColor colorWithRed:37.0/255.0 green:162.0/255.0 blue:78.0/255.0 alpha:1.0];
        cell.detalle.backgroundColor=[UIColor colorWithRed:37.0/255.0 green:162.0/255.0 blue:78.0/255.0 alpha:1.0];
    }else{
            cell.resultado.text=@"Incorrecto";
            cell.resultado.textColor=[UIColor redColor];
        cell.detalle.backgroundColor=[UIColor redColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSString*)getRespuesta:(NSString*)exp{
    if ( ! [self esExpBalanceada:exp]){
        NSLog(@"Expresion no balanceada, revice sus ""("" y "")""");
        return @"Expresion no balanceada, revice sus (  )";
    }else{
        
        SimpleStack * opStack = [[SimpleStack alloc] init];
        NSMutableString * output = [NSMutableString stringWithCapacity:[exp length]];
        
        [opStack print];
        
        NSArray * tokens = [self tokenize: exp];
        for (NSString *token in tokens){
            if ([self precedenceOf:token] != 0){
                NSString *op = [opStack peek];
                while (op && [self precedenceOf:op] != 0 &&
                       [self precedenceOf: op isHigherOrEqualThan: token]) {
                    [output appendString: [NSString stringWithFormat: @"%@ ", [opStack pop]]];
                    op = [opStack peek];
                }
                [opStack push:token];
                [opStack print];
                
            } else if ([token compare: @"("] ==0){
                [opStack push:token];
            } else if ([token compare: @")"] ==0) {
                NSString  * op = [opStack pop];
                while ( op  && ([op compare: @"("] != 0)){
                    [output appendString: [NSString stringWithFormat: @"%@ ", op]];
                    op = [opStack pop];
                }
                if ( ! op || ([op compare: @"("]  != 0)){
                    NSLog(@"Expresion desbalanseada");
                }
            } else {
                [output appendString: [NSString stringWithFormat: @"%@ ", token]];
            }
            [opStack print];
        }
        while (! [opStack empty]) {
            [output appendString: [NSString stringWithFormat: @"%@ ", [opStack pop]]];
        }
        return [NSString stringWithFormat:@"%@", [output stringByTrimmingCharactersInSet:
                                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
}

- (NSArray*) tokenize: (NSString*) expression {
    NSMutableArray * tokens = [NSMutableArray arrayWithCapacity:[expression length]];
    unichar c;
    NSMutableString * numberBuf = [NSMutableString stringWithCapacity: 5];
    int length = [expression length];
    BOOL operador = YES;
    
    for (int i = 0; i< length; i++){
        c = [expression characterAtIndex: i];
        switch (c) {
            case '+':
            case '|':
            case '*':
            case '^':
                operador = YES;
                [self addNumber: numberBuf andToken: c toTokens:tokens];
                break;
            case '(':
            case ')':
                operador = NO;
                [self addNumber: numberBuf andToken: c toTokens:tokens];
                break;
            case '-':
                if (operador){
                    operador = NO;
                    [numberBuf appendString : [NSString stringWithCharacters: &c length:1]];
                } else {
                    operador = YES;
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
            case '.':
                operador = NO;
                [numberBuf appendString : [NSString stringWithCharacters: &c length:1]];
                break;
            case ' ':
                break;
            default:
               
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
    else if ([operator compare: @"-"] == 0 )
        return 1;
    else if ([operator compare: @"?"] == 0 )
        return 2;
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
-(IBAction)otro:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
