#ifndef DISTRIBUTIONS_H
#define DISTRIBUTIONS_H

#include <thrust/host_vector.h>

namespace DISTRIBUTIONS{

    std::vector<double> BiGaussian4D(
        std::map<std::string, double> &paramMap,
        std::vector<double> &bunchMapRow,
        int seed
    );

    std::vector<double> BiGaussian6DLongMatched(
        std::map<std::string, double> &paramMap,
        std::map<std::string, std::vector<double>> &inputMapVector,
        std::map<std::string, double> &twheader,
        std::vector<double> &bunchMapRow,
        int seed
    );

    std::vector<std::vector<double>> GenerateDistributionMatched(
        std::map<std::string, double> &paramMap,
        std::map<std::string, std::vector<double>> &inputMapVector,
        std::map<std::string, int> &inputMapInt,
        std::map<std::string, double> &twheader,
        std::vector<double> &bunchMapRow
      );
}

#endif