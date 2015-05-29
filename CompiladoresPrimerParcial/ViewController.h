//
//  ViewController.h
//  CompiladoresPrimerParcial
//
//  Created by Mau Vela on 23/02/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleStack.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITextField*expresion;
    IBOutlet UIButton*convertir;
    IBOutlet UILabel*resultado;
    IBOutlet UILabel*bg;
    NSMutableArray*tempArray;
    NSDictionary * operatorPrecedence;

    IBOutlet UITableView*historial;
    
    NSMutableArray*datos;
    IBOutlet UITableView*tabla;
    NSMutableArray*finalData;
    IBOutlet UILabel*expd;
    NSString*dfsString;
    
    IBOutlet UITextField*expresionField;
}


- (NSString*) parseInfix: (NSString*) infixExpression;
@end

