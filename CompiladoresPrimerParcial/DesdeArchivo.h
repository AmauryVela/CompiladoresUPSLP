//
//  DesdeArchivo.h
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 2/26/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesdeArchivo : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*datos;
    IBOutlet UITableView*tabla;
    IBOutlet UILabel*bg;

}
@end
