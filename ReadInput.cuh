// include guard
#ifndef READINPUT_H_INCLUDED
#define READINPUT_H_INCLUDED

// included dependencies
#include <map>
#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <math.h>
#include <string>
#include <vector>

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
  for (int i = 0; i < v.size(); i++) {
    os << std::scientific << std::setw(15) << v[i];
  }
  // os << std::endl;
  // std::copy(v.begin(), v.end(), ostream_iterator<T>(os, "\t"));
  return os;
}

std::vector<std::string> boolKeys = {"WriteDistribution","BetaTronFlag","RFFlag","RadFlag","IBSFlag","BlowupFlag","CollisionFlag","CollimatorFlag"};
std::vector<std::string> stringKeys = {"TwissFileNameBeam1","TwissFileNameBeam2","BunchFileNameBeam1", "BunchFileNameBeam2"};
std::vector<std::string> intKeys = {"seed","nMacro","nTurns","TimeRatio","nWrite","IBSModel","nBins"};
std::vector<std::string> doubleKeys = {"atomNumber1","atomNumber2","charge1","charge2","Coupling","IBSCoupling"};
std::vector<std::string> vectorKeys = {"HarmonicNumbers","Voltages"};

namespace READINPUT {
void ReadInputFile(std::string FileName, 
    std::map<std::string, bool> &inputMapBool,
    std::map<std::string,int> &inputMapInt,
    std::map<std::string,double> &inputMapDouble,
    std::map<std::string,std::string> &inputMapString,
    std::map<std::string,std::vector<double>> &inputMapVector
);
void readBunchFile(std::string filename, std::map<int, std::vector<double>> &bunchMap);

void PrintInputBoolMap(std::map<std::string, bool> inputMapBool);
void PrintInputIntMap(std::map<std::string, int> inputMapInt);
void PrintInputDoubleMap(std::map<std::string, double> inputMapDouble);
void PrintInputStringMap(std::map<std::string, double> inputMapString);
void PrintInputVectorMap(std::map<std::string, std::vector<double>> inputMapVector);
void PrintInputBunch(std::map<int, std::vector<double>> bunchMap);
}
#endif
