#include "Constants.cuh"
#include "Numeric.cuh"
#include "Numeric.cu"

namespace RADIATION{
    double RadiationLossesPerTurn( std::map<std::string, double> &twiss,std::map<std::string, double> &beamParMap  ) {
        double gamma  = twiss["GAMMA"];
        double p0     = twiss["PC"];
        double len    = twiss["LENGTH"];
        double mass   = twiss["MASS"];
        double I2     = twiss["SYNCH_2"];
      
        // beam dependent vars - there can be different particles in the different beams
        double aatom  = beamParMap["aatom"];
        double trev   = beamParMap["trev"];
        double charge = beamParMap["charge"];

        // REF: Handbook for accelerator physicists and engineers - sec edition
        double particle_radius = NUMERIC::ParticleRadius( charge, aatom );
        double cgamma = (4.0 * CONSTANTS::pi / 3.0) * ( particle_radius / ( mass * mass * mass ) );
      
        return (CONSTANTS::clight * cgamma) / (2.0 * CONSTANTS::pi * len) * p0 * p0 * p0 * p0 * I2 * 1.0e9 *
               trev;
      }
}