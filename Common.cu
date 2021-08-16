#include "Numeric.cuh"
//#include "Numeric.cu"
#include "Constants.cuh"

namespace COMMON {

    void setBasic(std::map<std::string, double> &twheader, std::map<std::string, double> &paramMap){
        double gamma   = twheader["GAMMA"];
        double gammatr = twheader["GAMMATR"];
        double p0      = twheader["PC"];
        double len     = twheader["LENGTH"];
        double mass    = twheader["MASS"];

        paramMap["betar"]   = NUMERIC::BetaR( gamma );
        paramMap["trev"]    = len / ( paramMap["betar"] * CONSTANTS::clight );
        paramMap["frev"]    = 1.0 / paramMap["trev"];
        paramMap["omega"]   = 2.0 * CONSTANTS::pi * paramMap["frev"];
        paramMap["eta"]     = NUMERIC::eta(gamma, gammatr);
        paramMap["betxavg"] = twheader["LENGTH"] / (twheader["Q1"] * 2.0 * CONSTANTS::pi);
        paramMap["betyavg"] = twheader["LENGTH"] / (twheader["Q2"] * 2.0 * CONSTANTS::pi);
       
    }

    void setLongParam(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap,
        std::map<std::string, double> &inputMapDouble,
        std::map<std::string, std::vector<double>> &inputMapVector,
        std::map<int, std::vector<double>> &bunchMap
    ){
        double gamma    = twheader["GAMMA"];
        double gammatr  = twheader["GAMMATR"];
        double h0       = inputMapVector["HarmonicNumbers"][0];
        double U0       = paramMap["U0"];
        double charge   = paramMap["charge"];
        double omega    = paramMap["omega"];
        double betar    = paramMap["betar"];
        double angularf = 2.0 * CONSTANTS::pi * h0;
        std::vector<double> h = inputMapVector["HarmonicNumbers"];
        std::vector<double> v = inputMapVector["Voltages"];

        std::for_each( bunchMap.begin(), bunchMap.end(),
            [&](std::pair<const int, std::vector<double>> &p){
                // defining phis search parameters
                double search = (double)p.first * 2.0 * CONSTANTS::pi + angularf /
                    ( 8.0 * *std::max_element(h.begin(), h.end()) );
                double searchWidth =  angularf / (2.0 * *std::max_element(h.begin(), h.end()));

                double eps = 1e-6;
                double phis     = NUMERIC::SynchronuousPhase( 0.0, search, U0, charge, v, h, eps  );
                double phisNext = NUMERIC::SynchronuousPhase( 0.0, search + CONSTANTS::pi, U0, charge, v, h, eps  );
                double qs       = NUMERIC::SynchrotronTune( phis, twheader, paramMap, v, h);
                double tauhat   = fabs( phisNext - phis ) / ( h0 * omega );
                double sigs     = p.second[3];
                double sige     = NUMERIC::sigefromsigs( omega, sigs, qs, gamma, gammatr ) ;
                double dpop     = NUMERIC::dee_to_dpp( sige, betar );

                p.second.push_back(phis);
                p.second.push_back(phisNext);
                p.second.push_back(qs);
                p.second.push_back(tauhat);
                p.second.push_back(sige);
                p.second.push_back(dpop);
            }
    );
        
    

    }
}