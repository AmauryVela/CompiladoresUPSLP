//
//  DFS.h
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 4/30/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFS : UIViewController
{
    NSMutableArray*datos;
    IBOutlet UITableView*tabla;
    IBOutlet UILabel*bg;
    NSMutableArray*finalData;
    IBOutlet UILabel*expd;
    NSString*dfsString;
    
    IBOutlet UITextField*expresionField;
}
@end
