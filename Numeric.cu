#include <math.h>
#include "Constants.cuh"

namespace NUMERIC{
    double BetaR( double gamma ){
        return sqrt( 1.0 - ( 1.0 / ( gamma * gamma )) );
    }

    double ParticleRadius( double charge, double aatom ){
        return charge * charge * CONSTANTS::prad / aatom; 
    }

    double eta( double gamma, double gammatr ) {
        return 1.0 / ( gammatr * gammatr - 1.0 / ( gamma * gamma ) );
      }

    double VoltageRfeV( double phi, std::vector<double> &volts, std::vector<double> &hs, double charge ) {
        double vrf = volts[0] * sin(phi);

        for (int i = 1; i < hs.size(); i++) {
            vrf += volts[i] * sin((hs[i] / hs[0]) * phi);
        }
        
        // V -> eV
        vrf *= charge;

        return vrf;
    }

    double VoltageRfeVPrime( double phi, std::vector<double> &volts,std::vector<double> &hs, double charge ) {
        // init - phi is in rad
        double vrf = volts[0] * cos(phi);

        // add other rfs
        for (int i = 1; i < volts.size(); i++) {
        vrf += volts[i] * (hs[i] / hs[0]) * cos((hs[i] / hs[0]) * phi);
        }

        // V -> eV
        vrf *= charge;

        return vrf;
    }

    double SynchronuousPhase(
        double target, double init_phi, double U0,double charge, 
        std::vector<double> &volts,
        std::vector<double> &hs, 
        double epsilon) {

        // Set the initial option prices and volatility
        double y = VoltageRfeV(init_phi, volts, hs, charge) - U0;
        double x = init_phi;

        // Newton Raphson
        // REF: https://www.boost.org/doc/libs/1_62_0/libs/math/doc/html/math_toolkit/roots/roots_deriv.html#math_toolkit.roots.roots_deriv.newton
        // x_{n+1}= x_n - \frac{f(x)}{f'(x)}
        while (fabs(y - target) > epsilon) {
            double d_x = VoltageRfeVPrime(x, volts, hs, charge);
            x += (target - y) / d_x;
            y = VoltageRfeV(x, volts, hs, charge) - U0;
        }

        return x;
    }

    double SynchrotronTune(
        double phis,
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap,
        std::vector<double> &volts, 
        std::vector<double> &hs) {

            double charge = paramMap["charge"];
            double pc     = twheader["PC"];
            double n      = paramMap["eta"];

            return sqrt(hs[0] * n *
                fabs( charge * VoltageRfeVPrime(phis, volts, hs, charge) ) / ( 2.0 * CONSTANTS::pi * pc * 1.0e9 ) );
    }

    double sigefromsigs(double omega0, double sigs, double qs, double gamma, double gammatr) {
        // dE/E = Beta**2 dp/p
        double beta2 = BetaR(gamma);
        beta2 *= beta2;
        return beta2 * qs * omega0 * (sigs / (fabs(eta(gamma, gammatr)) * CONSTANTS::clight));
    }

    double dee_to_dpp(double dee, double beta0) {
        return sqrt(((dee + 1.0) * (dee + 1.0) - 1.0) / (beta0 * beta0) + 1.0) - 1.0;
    }

}