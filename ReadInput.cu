// included dependencies
#include <map>
#include <fstream>
#include <sstream>
//#include <boost/lexical_cast.hpp>
#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <exception>
#include <iterator>
#include <vector>
#include "ReadInput.cuh"
#include <math.h>
#include <numeric>
#include <algorithm>

namespace READINPUT {
void ReadInputFile(std::string FileName, 
    std::map<std::string, bool> &inputMapBool,
    std::map<std::string,int> &inputMapInt,
	std::map<std::string,double> &inputMapDouble,
	std::map<std::string,std::string> &inputMapString,
    std::map<std::string,std::vector<double>> &inputMapVector
){
    // file reading variables
    std::string line;
	std::ifstream inputFile;
	std::string key;

    // value variables
    bool valueBool;
	int valueInt;
	double valueDouble;
	std::string valueString;
    std::vector<double> valueVector;

    // open file stream
    try{
        inputFile.open(FileName.c_str());
    }
    // print error if necessary
    catch(std::exception const& e) {
		std::cout << FileName << ": " << e.what() << "\n";
	};
   
    // start of reading file
	if (inputFile.is_open())
	{
        while (!inputFile.eof()){ 
		// read number of macro particles
	    std::getline(inputFile, line);
		std::stringstream iss(line);

        iss >> key;
	    // std::printf("Key %s\n",key.c_str());
        // add to bool map if key in bool keys (see header)
        std::vector<std::string>::iterator it = find(boolKeys.begin(), boolKeys.end(), key);
        if (it != boolKeys.end()){
            iss >> valueBool;
            inputMapBool[key] = valueBool;

        }

        // add to int map if key in int keys (see header)
        it = find(intKeys.begin(), intKeys.end(), key);
        if (it != intKeys.end()){
            iss >> valueInt;
	        //std::printf("%12i\n",valueInt);
            inputMapInt[key] = valueInt;
        }

        // add to double map if key in double keys (see header)
        it = find(doubleKeys.begin(), doubleKeys.end(), key);
        if (it != doubleKeys.end()){
            iss >> valueDouble;
	        //std::printf("%12.8f\n",valueDouble);
            inputMapDouble[key] = valueDouble;
        }

        // add to double map if key in double keys (see header)
        it = find(vectorKeys.begin(), vectorKeys.end(), key);
        if (it != vectorKeys.end()){
            while (iss>>valueDouble){
            //iss >> valueDouble;
            inputMapVector[key].push_back(valueDouble);
            }
        }  
        
        // add to string map if key in string keys (see header)
        it = find(stringKeys.begin(), stringKeys.end(), key);
        if (it != stringKeys.end()){
            iss >> valueString;
            inputMapString[key] = valueString;

        }
    }
}
}

void readBunchFile(std::string filename, std::map<int, std::vector<double>> &bunchMap){
    // file reading vars
    std::string line;
    std::ifstream inputfile;
    int bucket;
    double realnumberparticles;
	double emitx;
	double emity;
	double sigs;

    // open file stream
	try {
		inputfile.open(filename.c_str());
	}
	catch(std::exception const& e) {
		std::cout << filename << ": " << e.what() << "\n";
	};

    // start of reading file
    if (inputfile.is_open()){
        // read header line and skip it (only there for user readability)
        std::getline(inputfile, line);
        while(std::getline(inputfile, line)){
            std::stringstream iss(line);
            if ( iss >> bucket >> realnumberparticles >> emitx >> emity >> sigs ){
                std::vector<double> bunchRow;
                bunchRow.push_back(realnumberparticles);
                bunchRow.push_back(emitx);
                bunchRow.push_back(emity);
                bunchRow.push_back(sigs);
                bunchMap[bucket]=bunchRow;
            }
        }
    }
    inputfile.close();
}

void PrintInputBoolMap(std::map<std::string, bool> inputMapBool){
    for(std::map<std::string, bool>::iterator it=inputMapBool.begin();it!=inputMapBool.end();it++){
        std::printf("%-30s %i\n", it->first.c_str(), it->second);
    }
}

void PrintInputIntMap(std::map<std::string, int> inputMapInt){
    for(std::map<std::string, int>::iterator it=inputMapInt.begin();it!=inputMapInt.end();it++){
        std::printf("%-30s %i\n", it->first.c_str(), it->second);
    }
}

void PrintInputStringMap(std::map<std::string, std::string> inputMapString){
    for(std::map<std::string, std::string>::iterator it=inputMapString.begin();it!=inputMapString.end();it++){
        std::printf("%-30s %s\n", it->first.c_str(), it->second.c_str());
    }
}
void PrintInputDoubleMap(std::map<std::string, double> inputMapDouble){
    for(std::map<std::string, double>::iterator it=inputMapDouble.begin();it!=inputMapDouble.end();it++){
        std::printf("%-30s %12.8e\n", it->first.c_str(), it->second);
    }
}
void PrintInputVectorMap(std::map<std::string, std::vector<double>> inputMapVector){
    for(std::map<std::string, std::vector<double>>::iterator it=inputMapVector.begin();
    it!=inputMapVector.end();it++){
        std::cout << std::setw(31) << std::left << it->first;
        std::cout << it->second;
        std::cout << std::endl;
    }
}

void PrintInputBunch(std::map<int, std::vector<double>> bunchMap){
    std::cout << std::setw(8) << std::left << "Bucket";
    std::cout << std::setw(12) << std::right << "nReal";
    std::cout << std::setw(15) << std::right << "ex";
    std::cout << std::setw(15) << "ey";
    std::cout << std::setw(15) << "sigs[m]" << std::endl;
    for(std::map<int, std::vector<double>>::iterator it=bunchMap.begin();
    it!=bunchMap.end();it++){

        std::cout << std::setw(8) << std::left << it->first;
        std::cout << it->second;
        std::cout << std::endl;
    }
}
}
