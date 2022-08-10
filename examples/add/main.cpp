#include <mylib/mylib.h>

#include <iostream>

int main(int, char*[])
{
    auto sum = mylib::add(1, 1);
    std::cout << sum << std::endl;
    return 0;
}
