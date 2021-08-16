#ifndef CONSTANTS_H
#define CONSTANTS_H

namespace CONSTANTS{
/// Speed of light
const double clight = 299792458.0;
/// Reduced Planck constant  [GeV]
const double hbar = 6.582119569e-25;
/// Electron mass [GeV]
const double emass = 0.51099895000e-3;
/// Proton mass [GeV]
const double pmass = 0.93827208816;
/// Neutron mass [Gev]
const double nmass = 0.93956542052; // GeV CODATA 2018
/// Muon mass [GeV]
const double mumass = 0.1056583755; // GeV CODATA 2018
/// Atomic mass unit  [GeV]
const double atomicmassunit = 0.93149410242; // GeV scipy constants
/// Pi
const double pi = 3.141592653589793;
/// Electric Charge unit [Coulomb]
const double ec = 1.602176634e-19;
/// Euler constant
const double euler = 0.577215664901533;
/// Classical radius [m]
const double erad = 2.8179403262e-15;
/// Classical proton radius [m]
const double prad = erad * emass / pmass;
}
#endif