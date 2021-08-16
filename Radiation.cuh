#ifndef RADIATION_H
#define RADIATION_H

namespace RADIATION{
    double RadiationLossesPerTurn( 
        std::map<std::string, double> &twiss,
        std::map<std::string, double> &beamParMap  
    );

    void RadEquilib(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap
    );

    void RadDecayExcitationCoeff(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap
    );
} 
#endif