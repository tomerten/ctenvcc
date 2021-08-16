#include <map>
#include <string>
#include <vector>

namespace OUTPUT{

    void PrintIntVectorMap(std::map<int, std::vector<double>> inputMapVector){
        for(std::map<int, std::vector<double>>::iterator it=inputMapVector.begin();
            it!=inputMapVector.end();it++){
                std::cout << std::setw(6) << std::left << it->first;
                std::cout << it->second;
                std::cout << std::endl;
        };
    }
}