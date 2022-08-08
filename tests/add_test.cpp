#include <mylib/mylib.h>

#include <gtest/gtest.h>

TEST(add_test, add_1_1)
{
    EXPECT_EQ(mylib::add(1, 1), 2);
}
