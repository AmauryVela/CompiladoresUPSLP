//
//  DFS.m
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 4/30/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "DFS.h"

@interface DFS ()

@end

@implementation DFS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"archivo"
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
    dfsString=@"";
    [self getNode:[datos objectAtIndex:0]];
}

-(IBAction)generarArbol:(id)sender{
    NSString*expre=@"B*C?.A+B.|";
    NSMutableArray *letterArray = [NSMutableArray array];
    NSString *letters = expre;
    [letters enumerateSubstringsInRange:NSMakeRange(0, [letters length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [letterArray addObject:substring];
                             }];
    NSDictionary*nodoIzqTmp;
    NSMutableArray*nodos=[[NSMutableArray alloc] init];
    for (int i=0; i<letterArray.count; i++) {
        NSString*caracter=[letterArray objectAtIndex:i];
        if ([caracter isEqualToString:@"+"]||[caracter isEqualToString:@"*"]||[caracter isEqualToString:@"?"]) {
            //Tiene un hijo que es el hijo izq
           NSDictionary* nodoTmp=@{@"Nodo":caracter,@"Izq":nodoIzqTmp};
            [nodos addObject:nodoTmp];
        }else if ([caracter isEqualToString:@"."]||[caracter isEqualToString:@"|"]){
            //Es padre con 2 hijos
            NSDictionary*nodoTmp=@{@"Nodo":caracter,@"Izq":[nodos objectAtIndex:0],@"Der":[nodos objectAtIndex:1]};
            nodos=[[NSMutableArray alloc] init];
            [nodos addObject:nodoTmp];
        }else{
            nodoIzqTmp=@{@"Nodo":caracter};

        }
    }

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
}

@end
