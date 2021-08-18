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
#include "Datastructures.cuh"
#include "Datastructures.cu"

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
    /*                 Add parameters                                                 */
    /*                                                                                */
    /* ****************************************************************************** */ 

    // define variable and add param
    // in principle one needs to do this for both beams in a collider setting
    std::map<std::string, double> b1Param;
    b1Param["aatom"]     = inputMapDouble["atomNumber1"];
    b1Param["charge"]    = inputMapDouble["charge1"];
    b1Param["timeratio"] = (double)inputMapInt["TimeRatio"];

    // set basic params like omega, frev, etc..
    COMMON::setBasic(twheader, b1Param);
    // READINPUT::PrintInputDoubleMap(b1Param);

    // add radiation loss per turn - NECESSARY TO DO IN THIS ORDER
    b1Param["U0"] = RADIATION::RadiationLossesPerTurn(twheader, b1Param);
    READINPUT::PrintInputDoubleMap(b1Param);

    // add longitudinal parameters, phis, synch tune, etc...
    COMMON::setLongParam(twheader, b1Param, inputMapDouble, inputMapVector, bmap1);
    //OUTPUT::PrintIntVectorMap(bmap1);
    READINPUT::PrintInputBunch(bmap1);

    // add radiation equilib values, decay and quant excitation coefficients
    COMMON::setRadParam(twheader, b1Param);
    READINPUT::PrintInputDoubleMap(b1Param);


    /* ****************************************************************************** */ 
    /*                                                                                */
    /*                 Generate distributions                                         */
    /*                                                                                */
    /* ****************************************************************************** */ 

    // distribution map bucket -> dist
    std::map<int, std::vector<std::vector<double>>> b1dist;

    // loop over the bunches and add dist
    for (std::map<int, std::vector<double>>::iterator it = bmap1.begin(); it!=bmap1.end(); ++it){
        b1dist[it->first] = DISTRIBUTIONS::GenerateDistributionMatched(b1Param,inputMapVector,inputMapInt, twheader,  it->second ); 
    }

    // print out the dist for bucket == 0
    std::cout << b1dist[0];
    std::cout<<std::endl;

    thrust::host_vector<DATASTRUCTURES::double6> test = DATASTRUCTURES::hostVectorD6FromStdVector(b1dist[0]);
    thrust::for_each(test.begin(),test.end(),[&](DATASTRUCTURES::double6 &particle){
        std::cout << std::setw(16) << particle.x;
        std::cout << std::setw(16) << particle.px;
        std::cout << std::setw(16) << particle.y;
        std::cout << std::setw(16) << particle.py;
        std::cout << std::setw(16) << particle.t;
        std::cout << std::setw(16) << particle.delta;
        std::cout << std::endl;
    });
    return 0;
}
