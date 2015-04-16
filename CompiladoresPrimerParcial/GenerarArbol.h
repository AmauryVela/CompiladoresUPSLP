//
//  GenerarArbol.h
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 4/16/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenerarArbol : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*datos;
    IBOutlet UITableView*tabla;
    IBOutlet UILabel*bg;
    NSMutableArray*finalData;
    IBOutlet UILabel*expd;
}

@end
