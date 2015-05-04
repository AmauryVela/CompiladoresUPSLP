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
    NSString*expre=@"B*C?.A+B.|#.";
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
}



#pragma mark conversorPolaka
@end
