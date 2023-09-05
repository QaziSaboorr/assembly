// sort.c
// ENCM 369 Winter 2023 Lab 11 Exercise H


#include <stdio.h>


void sort(double *a, int n);
/* Sort array elements a[0], ... a[n - 1] in increasing order. */

double x[8] = { -6.015625, -2.25, -3.125, -5.03125, 
                -8.00390625, -4.0625, -1.5, -7.0078125 };

int main(void)
{
  int i;
  printf("before sorting ...\n");
  for (i = 0; i < 8; i++)
    printf("    %.8f\n", x[i]);
  sort(x, 8);
  printf("after sorting ...\n");
  for (i = 0; i < 8; i++)
    printf("    %.8f\n", x[i]);
  return 0;
}

void sort(double *a, int n)
{
  int outer, inner;
  double inserted;
  for (outer = 1; outer < n; outer++) {
    inserted = a[outer];
    inner = outer;
    while (inner > 0 && inserted < a[inner-1]) {
      a[inner] = a[inner-1];
      inner--;
    }
    a[inner] = inserted;
  }
}
