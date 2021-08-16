#ifndef COMMON_H
#define COMMON_H

namespace COMMON {
    void setBasic(std::map<std::string, double> &twheader, std::map<std::string, double> &paramMap);
    void setLongParam(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap,
        std::map<std::string, double> &inputMapDouble,
        std::map<std::string, std::vector<double>> &inputMapVector,
        std::map<int, std::vector<double>> &bunchMap
    );
}

#endif