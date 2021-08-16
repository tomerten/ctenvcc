#ifndef HAMILTONIAN_H
#define HAMILTONIAN_H

namespace HAMILTONIAN {

    double tcoeff(
        std::map<std::string, double> &paramMap, 
        double h0
    );

    double pcoeff(
        std::map<std::string, double> &paramMap, 
        std::map<std::string, double> &twheader, 
        double voltage
    );

    double Hamiltonian(
        std::map<std::string, double> &twheader,
        std::map<std::string, double> &paramMap,
        std::map<std::string, std::vector<double>> &inputMapVector,
        double phis,
        double tcoeff, 
        double t, 
        double delta
    );


}

#endif