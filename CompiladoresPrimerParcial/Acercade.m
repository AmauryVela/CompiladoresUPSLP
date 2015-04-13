//
//  Acercade.m
//  CompiladoresPrimerParcial
//
//  Created by Amaury Vela on 2/26/15.
//  Copyright (c) 2015 Mau Vela. All rights reserved.
//

#import "Acercade.h"

@interface Acercade ()

@end

@implementation Acercade

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bg.layer.cornerRadius = 5; // this value vary as per your desire
    bg.clipsToBounds = YES;
    acerca.layer.cornerRadius = 5; // this value vary as per your desire
    acerca.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)otro:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
