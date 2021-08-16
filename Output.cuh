#ifndef OUTPUT_H
#define OUTPUT_H

#include <thrust/host_vector.h>
#include <thrust/copy.h>

namespace OUTPUT{

    void PrintInputVectorMap(std::map<int, std::vector<double>> inputMapVector);
}

#endif