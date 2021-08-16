namespace HAMILTONIAN {

    double tcoeff(
        std::map<std::string, double> &paramMap, 
        double h0) {
        
            return paramMap["omega"] * paramMap["eta"] * h0;
        }

    double pcoeff(
        std::map<std::string, double> &paramMap, 
        std::map<std::string, double> &twheader, 
        double voltage) {
            // factor 1.0e9 -> pc is in GeV
            return paramMap["omega"] * voltage * paramMap["charge"] /
                   (2.0 * CONSTANTS::pi * twheader["PC"] * 1.0e9 * paramMap["betar"]);
        }


    double Hamiltonian(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap,
        std::map<std::string, std::vector<double>> &inputMapVector,
        double phis,
        double tcoeff, 
        double t, 
        double delta) {
            double kinetic, potential;
            std::vector<double> h = inputMapVector["HarmonicNumbers"];
            std::vector<double> v = inputMapVector["Voltages"];

            // kinetic contribution
            // We assume initial bunch length is given
            kinetic = 0.5 * tcoeff * delta * delta;

            std::vector<double> pcoeffs, hRatios, hRatiosInv, phases;

            // calculate coefficients for the determining the potential
            for (int i = 0; i < h.size(); i++) {
                pcoeffs.push_back( pcoeff( paramMap, twheader, v[i] ) );
                phases.push_back( h[i] * paramMap["omega"] * t );
                hRatios.push_back( h[0] / h[i] );
                hRatiosInv.push_back( h[i] / h[0] );
            }

            // calc the potential
            potential = pcoeffs[0] * (cos(phases[0]) - cos(phis) +
                 (phases[0] - phis) * sin(phis));

            for (int i = 1; i < h.size(); i++) {
                potential += pcoeffs[i] * hRatios[i] *
                    (cos(phases[i]) - cos(hRatiosInv[i] * phis) +
                    (phases[i] - hRatiosInv[i] * phis) * sin(hRatiosInv[i] * phis));
            }

            return kinetic + potential;
        }




}