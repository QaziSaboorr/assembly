//  11F prog.c
//  ENCM 369 Winter 2023 Lab 11 Exercise F

#include <stdio.h>

void proc1(double *a, int n);

double proc2(double x);

int main(void)
{
  int k;
  double y[5];
  proc1(y, 5);
  for (k = 0; k < 5; k++)
    printf("%.20g\n", y[k]); 
  return 0;
}

void proc1(double *a, int n)
{
  double pi_over_2;
  int i;

  pi_over_2 = 1.57079632679489661923;
  for (i = 0; i < n; i++)
    a[i] = proc2(i * pi_over_2);
}

double proc2(double x)
{
  return 0.5 * x;
}
