// quadratic.c
// ENCM 369 Winter 2023 Lab 11 Exercise G

#include <math.h>
#include <stdio.h>

void quadratic(double a, double b, double c, double *roots);
/* Compute roots for equation a * x**2 + b * x + c,
 * allowing for the possibility of complex roots.
 *
 * roots must point to the beginning of an array of 4 elements.
 *
 * Real and imaginary parts of one root are put in root[0] and root[1],
 * real and imaginary parts of the other are put in root[2] and root[3].
 */

void test_q(double a, double b, double c);
/* Call quadratic with arguments a, b, c, then print results. */

int main(void)
{
  test_q(1.0, 1.5, 2.0);
  test_q(1.1, -3.5, 2.0);
  return 0;
}

double result[4] = {0.0, 0.0, 0.0, 0.0};

void test_q(double a, double b, double c)
{
  quadratic(a, b, c, result);
  printf("\ncoefficient a = %.16f", a);
  printf("\ncoefficient b = %.16f", b);
  printf("\ncoefficient c = %.16f", c);
  printf("\nroot: %.16f + i * (%.16f)\n", result[0], result[1]);
  printf("root: %.16f + i * (%.16f)\n", result[2], result[3]);
}

void quadratic(double a, double b, double c, double *roots)
{
  double discrim, sqrtd, two_a;
  discrim = b * b - 4 * a * c;
  two_a = a + a;
  if (discrim >= 0.0) {
    sqrtd = sqrt(discrim);
    roots[0] = (-b + sqrtd) / two_a;
    roots[1] = 0.0;
    roots[2] = (-b - sqrtd) / two_a;
    roots[3] = 0.0;
  }
  else {
    sqrtd = sqrt(-discrim);
    roots[0] = -b / two_a;
    roots[1] = sqrtd / two_a;
    roots[2] = roots[0];
    roots[3] = -roots[1];
  }
}
