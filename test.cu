#include "ReadInput.cuh"
#include "ReadInput.cu"
#include "ReadTFS.cuh"
#include "ReadTFS.cu"

int main(){
	
    std::map<std::string, bool> inputMapBool;
    std::map<std::string,int> inputMapInt;
    std::map<std::string,double> inputMapDouble;
    std::map<std::string,std::string> inputMapString;
    std::map<std::string,std::vector<double>> inputMapVector;

    std::string file = "testinput.in";
    std::string twfile = "b2_design_lattice_1996.twiss";


    READINPUT::ReadInputFile(file, inputMapBool, inputMapInt, inputMapDouble, inputMapString, inputMapVector);

    // check input
    READINPUT::PrintInputBoolMap(inputMapBool);
    READINPUT::PrintInputIntMap(inputMapInt);
    READINPUT::PrintInputDoubleMap(inputMapDouble);
    READINPUT::PrintInputVectorMap(inputMapVector);


    std::map<std::string, double> twheader = GetTwissHeader(twfile);
    printTwissHeader(twheader);
    return 0;
}
