#include "Constants.cuh"
#include "Numeric.cuh"
#include "Numeric.cu"

namespace RADIATION{
    double RadiationLossesPerTurn( 
        std::map<std::string, double> &twiss,
        std::map<std::string, double> &beamParMap  
        ) {
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

    void RadEquilib(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap) {

        // base quantities
        double gamma   = twheader["GAMMA"];
        double gammatr = twheader["GAMMATR"];
        double p0      = twheader["PC"] * 1.0e9;
        double len     = twheader["LENGTH"] * 1.0;
        double restE   = twheader["MASS"] * 1.0e9;
        double charge  = paramMap["charge"];
        double aatom   = paramMap["aatom"];
        double qs      = paramMap["qs"];
        double omega   = paramMap["omega"];
        double q1      = twheader["Q1"];

        // use madx rad integrals
        double I1  = twheader["SYNCH_1"];
        double I2  = twheader["SYNCH_2"];
        double I3  = twheader["SYNCH_3"];
        double I4x = twheader["SYNCH_4"];
        double I5x = twheader["SYNCH_5"];

        double I4y = 0.0;
        double I5y = 0.0;

        // derived quantities
        double pradius = NUMERIC::ParticleRadius(charge, aatom);
        double CalphaEC = pradius * CONSTANTS::clight / (3.0 * restE * restE * restE) * (p0 * p0 * p0 / len);

        // transverse partition numbers
        double jx = 1.0 - I4x / I2;
        double jy = 1.0 - I4y / I2;
        double alphax = 2.0 * CalphaEC * I2 * jx;
        double alphay = 2.0 * CalphaEC * I2 * jy;
        double alphas = 2.0 * CalphaEC * I2 * (jx + jy);

        // mc**2 expressed in Joule to match units of cq
        double mass    = restE * CONSTANTS::electron_volt_joule_relationship;
        double cq      = 55.0 / (32.0 * sqrt(3.0)) * (CONSTANTS::hbarsu * CONSTANTS::clight) / mass;
        double sigE0E2 = cq * gamma * gamma * I3 / (2.0 * I2 + I4x + I4y);

        // ! = deltaE/E_0 see wiedemann p. 302,
        // and Wolski: E/(p0*c) - 1/beta0 = (E - E0)/(p0*c) = \Delta E/E0*beta0 with
        // E0 = p0*c/beta0 therefore:
        double betar = NUMERIC::BetaR(gamma);
        double dpop  = NUMERIC::dee_to_dpp(sqrt(sigE0E2), betar);
        double sigs  = dpop * len * NUMERIC::eta(gamma, gammatr) / (2 * CONSTANTS::pi * qs);
        double exinf = cq * gamma * gamma * I5x / (jx * I2);
        double eyinf = cq * gamma * gamma * I5y / (jy * I2);
        
        double betaAvg = paramMap["betxavg"];

        eyinf = (eyinf == 0.0) ? cq * betaAvg * I3 / (2.0 * jy * I2) : eyinf;

        paramMap["taux"] = 1.0 / alphax;
        paramMap["tauy"] = 1.0 / alphay;
        paramMap["taus"] = 1.0 / alphas;
        paramMap["exinf"] = exinf;
        paramMap["eyinf"] = eyinf;
        paramMap["sigeoe2"] = sigE0E2;
        paramMap["sigsinf"] = sigs;
        paramMap["jx"] = jx;
        paramMap["jy"] = jy;
    }


    void RadDecayExcitationCoeff(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap) {

        double gamma     = twheader["GAMMA"];
        double trev      = paramMap["trev"];
        double timeratio = paramMap["timeratio"];
        double taus      = paramMap["taus"];
        double taux      = paramMap["taux"];
        double tauy      = paramMap["tauy"];
        double sigsinf   = paramMap["sigsinf"];
        double tt        = trev * timeratio;

        double sigx = sqrt(paramMap["exinf"] * paramMap["betxavg"]);
        double sigy = sqrt(paramMap["eyinf"] * paramMap["betyavg"]);

        // timeratio is real machine turns over per simulation turn
        paramMap["coeffdecaylong"] = exp(-tt / taus);

        // excitation uses a uniform distibution on [-1:1]
        // sqrt(3) * sigma => +/-3 sigma**2
        // see also lecture 2 Wolski on linear dynamics and radiation damping
        // not sure about the sqrt3
        paramMap["coeffexcitelong"] = (paramMap["sigeoe2"] * gamma) / sqrt(3) *
                    sqrt(3.) * sqrt(1.0 * tt / taus);

        // the damping time is for EMITTANCE, therefore need to multiply by 2
        paramMap["coeffdecayx"] = exp(-(tt / (2 * taux)));
        paramMap["coeffdecayy"] = exp(-(tt / (2 * tauy)));

        // exact:
        // coeffgrow= sigperp*sqrt(3.)*sqrt(1-coeffdecay**2)
        // squared because sigma and not emit
        paramMap["coeffgrowx"] = sigx * sqrt(3.) * sqrt(1.0 - pow(paramMap["coeffdecayx"], 2));
        paramMap["coeffgrowy"] = sigy * sqrt(3.) * sqrt(1.0 - pow(paramMap["coeffdecayy"], 2));
    }
}