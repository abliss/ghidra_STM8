int test_function(void) {
  return 123;
}

int main(void) {
  volatile int(*function)(void) = test_function;
  function();
  return function();
}
