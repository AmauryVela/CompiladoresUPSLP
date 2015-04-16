//
//  GenerarArbol.m
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 4/16/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "GenerarArbol.h"
#import "NodoHijo.h"
#import "NodoPadreCell.h"
@interface GenerarArbol ()

@end

@implementation GenerarArbol

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bg.layer.cornerRadius = 5; // this value vary as per your desire
    bg.clipsToBounds = YES;
    tabla.layer.cornerRadius = 5; // this value vary as per your desire
    tabla.clipsToBounds = YES;
    
    
    // Do any additional setup after loading the view.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"archivo2"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSLog(@"cont: %@",content);
    NSData * jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    datos= [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSLog(@"Datos: %lu",(unsigned long)datos.count);
    finalData=[[NSMutableArray alloc] init];
    expd.text=[[datos objectAtIndex:0] objectForKey:@"Exp"] ;
    NSArray* foo = [[[datos objectAtIndex:0] objectForKey:@"Exp"] componentsSeparatedByString: @"<"];
    for (int t=0; t<foo.count; t++) {
        NSString*arg=[foo objectAtIndex:t];
        if (![arg isEqualToString:@""]) {
            NSArray* food = [[foo objectAtIndex:t] componentsSeparatedByString: @">"];
            
            NSArray* foodd=[[NSArray alloc] init] ;
            for (int r=0; r<food.count-1; r++) {
                foodd= [[food objectAtIndex:r+1] componentsSeparatedByString: @";"];
                NSDictionary*tmp=@{@"Nodo":[food objectAtIndex:0]};
                [finalData addObject:tmp];
                for (int g=0; g<foodd.count; g++) {
                    if (![[foodd objectAtIndex:g] isEqualToString:@""]) {
                        NSDictionary*tmp=@{@"Arg":[foodd objectAtIndex:g]};
                        [finalData addObject:tmp];

                    }
                    
                }
            }
            
        }
    }
    NSArray* food = [[foo objectAtIndex:1] componentsSeparatedByString: @">"];

    NSLog(@"Final: %@",finalData);
   // NSLog(@"Food: %@",food);
    [tabla reloadData];

}
-(int)getNumerOfRows:(NSMutableArray*)data{
    int suma=0;
    suma=suma+data.count;
    for (int y=0; y<data.count; y++) {
        NSArray*h=[[data objectAtIndex:y] objectForKey:@"Arg"];
        suma=suma+h.count;

    }
    return suma;
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
    return finalData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*esArg=[NSString stringWithFormat:@"%@",[[finalData objectAtIndex:indexPath.row] objectForKey:@"Nodo"]];
    if (![esArg isEqualToString:@"(null)"]) {
        static NSString *MaillCellC = @"ArchivoCell";
        NodoPadreCell *cell = (NodoPadreCell *)[tabla dequeueReusableCellWithIdentifier:MaillCellC];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NodoPadreCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.arg.text=esArg;
        return cell;
    }else{
        static NSString *MaillCellC = @"ArchivoCell";
        NodoHijo *cell = (NodoHijo *)[tabla dequeueReusableCellWithIdentifier:MaillCellC];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NodoHijo" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString*esArgd=[NSString stringWithFormat:@"%@",[[finalData objectAtIndex:indexPath.row] objectForKey:@"Arg"]];
        cell.arg.text=esArgd;

        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
