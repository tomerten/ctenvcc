#ifndef RADIATION_H
#define RADIATION_H

namespace RADIATION{
    double RadiationLossesPerTurn( 
        std::map<std::string, double> &twiss,
        std::map<std::string, double> &beamParMap  
    );
} 
#endif