//
//  Solver.cpp
//  双摆
//
//  Created by 谢哲 on 2021/3/9.
//

#include <stdio.h>
#include <cmath>

// Hyper Params
const int maxnum = 100;
const int maxnum_ana = 11;
const double pi = 3.1415926536;
const int xhcs = 1000;

class doubleswing_ana
{
public:
    double m1, m2, l1, l2, al, be, w1, w2;
    double a1, a2, deltat = 0.01 / xhcs;
};


// Equation Solver
int equx(double *equ, double *ans)
{
    if (*equ == 1)
    {
        *(ans + int(*equ) - 1) = (*(equ + 2)) / (*(equ + 1));
        return 0;
    }
    else
    {
        double equn[maxnum];  // 新方程
        int ys = *equ;        // 位数

        // 写入开头
        equn[0] = *equ - 1;
        int xieru = 0;

        // 寻找母方程
        int ysm, xy;
        for (ysm = 1; ysm <= ys; ysm++)
        {
            if (*(equ + (ys + 1) * ysm - 1) != 0)
                break;
        }

        // 消元
        for (xy = 1; xy <= ys; xy++)
        {
            if (xy == ysm)  // 跳过母方程
                continue;
            else
            {
                // 约减
                for (int xys = 1; xys <= ys + 1; xys++)
                {
                    double xyhs = 0.0;
                    if (xys == ys)
                        continue;
                    double ms = *(equ + ysm * (ys + 1) - 1);
                    double hs = *(equ + (xy - 1) * (ys + 1) + xys), hm = *(equ + xy * (ys + 1) - 1), xm = *(equ + (ysm - 1) * (ys + 1) + xys);
                    if (hm != 0)
                    {
                        // 除
                        xyhs = xm - hs * ms / hm;
                    }
                    else
                        xyhs = hs;

                    // 写入
                    xieru++;
                    equn[xieru] = xyhs;
                }
            }
        }
        // 递归求解
        equx(equn, ans);

        // 计算答案
        int sd;
        double sum = 0;
        for (sd = 1; sd <= ys - 1; sd++)
        {
            double cs = *(equ + (ysm - 1) * (ys + 1) + sd);
            sum += cs * ans[sd - 1];
        }
        ans[ys - 1] = (equ[ysm * (ys + 1)] - sum) / equ[ysm * (ys + 1) - 1];
        return 0;
    }
}



// Solver (use variational approach)
int caldoubleswing_ana(doubleswing_ana *db)
{
    double swinglab[maxnum_ana], ans[10];
    double g = 9.8;
    // 数据本地化
    double w1 = db->w1, w2 = db->w2, a1, a2, m1 = db->m1, m2 = db->m2, l1 = db->l1, l2 = db->l2, al = db->al, be = db->be, dt = db->deltat;

    for (int i = 0; i < maxnum_ana; i++)
    {
        swinglab[i] = 0.0;
        if (i < 10)
            ans[i] = 0;
    }
    // 输入矩阵数据
    swinglab[0] = 2;
    swinglab[1] = (m1 + m2) * l1 * l1;
    swinglab[2] = m2 * l1 * l2 * cos(al - be);
    swinglab[3] = -m2 * l1 * l2 * sin(al - be) * w2 * w2 - (m1 + m2) * l1 * g * sin(al);

    swinglab[4] = m2 * l1 * l2 * cos(al - be);
    swinglab[5] = m2 * l2 * l2;
    swinglab[6] = m2 * l1 * l2 * sin(al - be) * w1 * w1 - m2 * g * l2 * sin(be);

    // 计算
    equx(swinglab, ans);
    db->a1 = ans[0];
    db->a2 = ans[1];
    a1 = db->a1;
    a2 = db->a2;

    //迭代角度
    db->al += (w1 + 0 * dt * a1) * dt;
    db->be += (w2 + 0 * dt * a2) * dt;

    db->w1 += a1 * dt;
    db->w2 += a2 * dt;

    return 0;
}


class Solver
{
public:
    doubleswing_ana solver_data;

    Solver() {}
    Solver(double alpha, double beta, double m1, double m2, double l1, double l2, double w1, double w2)
    {
        solver_data.a1 = solver_data.a2 = 0.0;
        solver_data.m1 = m1;
        solver_data.m2 = m2;
        solver_data.l1 = l1;
        solver_data.l2 = l2;
        solver_data.al = alpha;
        solver_data.be = beta;
        solver_data.w1 = w1;
        solver_data.w2 = w2;
    }
    
    void set_data(double alpha, double beta, double m1, double m2, double l1, double l2, double w1, double w2, double a1, double a2) {
        solver_data.m1 = m1;
        solver_data.m2 = m2;
        solver_data.l1 = l1;
        solver_data.l2 = l2;
        solver_data.al = alpha;
        solver_data.be = beta;
        solver_data.w1 = w1;
        solver_data.w2 = w2;
        solver_data.a1 = a1;
        solver_data.a2 = a2;
    }

    void step(double delta_t)
    {
        solver_data.deltat = delta_t;
        caldoubleswing_ana(&solver_data);
    }

    double get_x1()
    {
        return sin(solver_data.al) * solver_data.l1;
    }

    double get_y1()
    {
        return cos(solver_data.al) * solver_data.l1;
    }

    double get_x2()
    {
        return get_x1() + sin(solver_data.be) * solver_data.l2;
    }

    double get_y2()
    {
        return get_y1() + cos(solver_data.be) * solver_data.l2;
    }
};

Solver solver;

extern "C"
{
    void init_solver(double alpha, double beta, double m1, double m2, double l1, double l2, double w1, double w2)
    {
        solver = *(new Solver(alpha, beta, m1, m2, l1, l2, w1, w2));
    }

    void solver_step(double delta_t)
    {
        solver.step(delta_t);
    }

    double solver_get_x1()
    {
        return solver.get_x1();
    }

    double solver_get_y1()
    {
        return solver.get_y1();
    }

    double solver_get_x2()
    {
        return solver.get_x2();
    }

    double solver_get_y2()
    {
        return solver.get_y2();
    }

    void solver_close()
    {
        delete &solver;
    }

    void solver_set_data(double alpha, double beta, double m1, double m2, double l1, double l2, double w1, double w2, double a1, double a2)
    {
        solver.set_data(alpha, beta, m1, m2, l1, l2, w1, w2, a1, a2);
    }
}
