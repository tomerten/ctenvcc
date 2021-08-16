#ifndef NUMERIC_H
#define NUMERIC_H

namespace NUMERIC{
    double BetaR( double gamma );
    double ParticleRadius( double charge, double aatom );
    double eta( double gamma, double gammatr ); 

    double VoltageRfeV( 
        double phi, 
        std::vector<double> &volts, 
        std::vector<double> &hs, 
        double charge 
    );

    double VoltageRfeVPrime( 
        double phi, 
        std::vector<double> &volts,
        std::vector<double> &hs, 
        double charge 
    );

    double SynchronuousPhase(
        double target, 
        double init_phi, 
        double U0,
        double charge, 
        std::vector<double> &volts,
        std::vector<double> &hs, 
        double epsilon
    );

    double SynchrotronTune(
            double phis,
            std::map<std::string, double> &twheader,
            std::map<std::string, double> &paramMap,
            std::vector<double> &volts, 
            std::vector<double> &hs
        );

    double sigefromsigs(
        double omega0, 
        double sigs, 
        double qs, 
        double gamma, 
        double gammatr
    );

    double dee_to_dpp(double dee, double beta0);
}
#endif