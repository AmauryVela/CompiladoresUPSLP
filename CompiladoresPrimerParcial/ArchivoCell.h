//
//  ArchivoCell.h
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 2/26/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *exp;
@property (weak, nonatomic) IBOutlet UILabel *posible;
@property (weak, nonatomic) IBOutlet UILabel *respuesta;
@property (weak, nonatomic) IBOutlet UILabel *resultado;
@property (weak, nonatomic) IBOutlet UILabel *detalle;

@end
