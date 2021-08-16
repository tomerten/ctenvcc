#include "ReadInput.cuh"
#include "ReadInput.cu"
#include "ReadTFS.cuh"
#include "ReadTFS.cu"
#include "Common.cuh"
#include "Common.cu"
#include "Constants.cuh"
#include "Radiation.cuh"
#include "Radiation.cu"
#include "Output.cuh"
#include "Output.cu"
#include "Distributions.cuh"
#include "Distributions.cu"

int main(){
	
    std::map<std::string, bool> inputMapBool;
    std::map<std::string,int> inputMapInt;
    std::map<std::string,double> inputMapDouble;
    std::map<std::string,std::string> inputMapString;
    std::map<std::string,std::vector<double>> inputMapVector;

    std::string file = "testinput.in";
    
    /* ****************************************************************************** */ 
    /*                                                                                */
    /*                 Read Sim Settings                                              */
    /*                                                                                */
    /* ****************************************************************************** */ 
    READINPUT::ReadInputFile(file, inputMapBool, inputMapInt, inputMapDouble, inputMapString, inputMapVector);
    
    // check input
    READINPUT::PrintInputBoolMap(inputMapBool);
    READINPUT::PrintInputIntMap(inputMapInt);
    READINPUT::PrintInputDoubleMap(inputMapDouble);
    READINPUT::PrintInputStringMap(inputMapString);
    READINPUT::PrintInputVectorMap(inputMapVector);
    
    /* ****************************************************************************** */ 
    /*                                                                                */
    /*                 Read Twiss                                                     */
    /*                                                                                */
    /* ****************************************************************************** */ 
    std::string twfile = inputMapString["TwissFileNameBeam1"];
    std::map<std::string, double> twheader = GetTwissHeader(twfile);
    printTwissHeader(twheader);
    
    std::map<std::string, std::vector<double>> tw = GetTwissTableAsMap(twfile);
   
    /* ****************************************************************************** */ 
    /*                                                                                */
    /*                 Read Bunch Files                                               */
    /*                                                                                */
    /* ****************************************************************************** */ 
    std::string bfile1 = inputMapString["BunchFileNameBeam1"];
    std::map<int,std::vector<double>> bmap1;
    READINPUT::readBunchFile(bfile1, bmap1);
    READINPUT::PrintInputBunch(bmap1);


    /* ****************************************************************************** */ 
    /*                                                                                */
    /*                 Add basic param inputMaps                                      */
    /*                                                                                */
    /* ****************************************************************************** */ 
    std::map<std::string, double> b1Param;
    b1Param["aatom"] = inputMapDouble["atomNumber1"];
    b1Param["charge"] = inputMapDouble["charge1"];
    b1Param["timeratio"] = (double)inputMapInt["TimeRatio"];
    COMMON::setBasic(twheader, b1Param);
    // READINPUT::PrintInputDoubleMap(b1Param);

    b1Param["U0"] = RADIATION::RadiationLossesPerTurn(twheader, b1Param);
    READINPUT::PrintInputDoubleMap(b1Param);

    COMMON::setLongParam(twheader, b1Param, inputMapDouble, inputMapVector, bmap1);
    //OUTPUT::PrintIntVectorMap(bmap1);
    READINPUT::PrintInputBunch(bmap1);

    COMMON::setRadParam(twheader, b1Param);
    READINPUT::PrintInputDoubleMap(b1Param);

    thrust::host_vector<double> test = DISTRIBUTIONS::BiGaussian4D(b1Param,bmap1[0], 123456);
    thrust::copy(test.begin(),test.end(), std::ostream_iterator<double>(std::cout, "\t"));
    std::cout<<std::endl;
    return 0;
}
