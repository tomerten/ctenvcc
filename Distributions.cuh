#ifndef DISTRIBUTIONS_H
#define DISTRIBUTIONS_H

#include <thrust/host_vector.h>

namespace DISTRIBUTIONS{

    thrust::host_vector<double> BiGaussian4D(
        std::map<std::string, double> &paramMap,
        std::vector<double> &bunchMapRow,
        int seed);
}

#endif