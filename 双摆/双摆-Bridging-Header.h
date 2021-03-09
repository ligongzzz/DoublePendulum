//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//


void init_solver(double alpha, double beta, double m1, double m2, double l1, double l2, double w1, double w2);
void solver_set_data(double alpha, double beta, double m1, double m2, double l1, double l2, double w1, double w2, double a1, double a2);
void solver_step(double delta_t);
double solver_get_x1();
double solver_get_y1();
double solver_get_x2();
double solver_get_y2();
double solver_close();
