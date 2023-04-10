#include <stdint.h>

uint32_t SystemCoreClock = 16000000;

class A
{
private:
  /* data */
  int b;

public:
  A(/* args */) {}
  int add(int a, int b) { return a + b; }
  ~A() {}
};

int main()
{
  A a;
  a.add(1, 2);
  return 0;
}