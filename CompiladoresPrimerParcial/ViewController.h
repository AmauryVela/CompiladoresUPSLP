//
//  ViewController.h
//  CompiladoresPrimerParcial
//
//  Created by Mau Vela on 23/02/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleStack.h"
@interface ViewController : UIViewController
{
    IBOutlet UITextField*expresion;
    IBOutlet UIButton*convertir;
    IBOutlet UILabel*resultado;
    IBOutlet UILabel*bg;
    NSMutableArray*tempArray;
    NSDictionary * operatorPrecedence;

}


- (NSString*) parseInfix: (NSString*) infixExpression;
@end

