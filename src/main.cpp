
#include "utils/string-utils.hpp"

#include <iostream>

int main() {
    std::cout << prefix::utils::trim_copy(" Hello World! ") << std::endl;
    
    return 0;
}
