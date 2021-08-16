#include "Random.cuh"
#include "Random.cu"
#include "Hamiltonian.cuh"
#include "Hamiltonian.cu"
#include <vector>
#include <thrust/host_vector.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/replace.h>
#include <thrust/functional.h>
#include <map>

namespace DISTRIBUTIONS{

  std::vector<double> BiGaussian4D(
    std::map<std::string, double> &paramMap,
    std::vector<double> &bunchMapRow,
    int seed) {
        std::vector<double> out;
      
        static double ampx, ampy, amp, r1, r2, facc;
        static double x, px, y, py;
        double betax = paramMap["betxavg"] ;
        double betay = paramMap["betyavg"];
        double ex    = bunchMapRow[1];
        double ey    = bunchMapRow[2];
        // 1 sigma rms beam sizes using average ring betas
        ampx = sqrt(betax * ex);
        ampy = sqrt(betay * ey);

        // generate bi-gaussian distribution in the x-px phase-space
        do {
            r1 = 2 * RANDOM::ran3(&seed) - 1;
            r2 = 2 * RANDOM::ran3(&seed) - 1;
            amp = r1 * r1 + r2 * r2;
        } while (amp >= 1);

        facc =
            sqrt(-2 * log(amp) /
                amp); // transforming [-1,1] uniform to gaussian - inverse transform

        x = ampx * r1 * facc;  // scaling the gaussian
        px = ampx * r2 * facc; // scaling the gaussian

        // generate bi-gaussian distribution in the y-py phase-space
        do {
            r1 = 2 * RANDOM::ran3(&seed) - 1;
            r2 = 2 * RANDOM::ran3(&seed) - 1;
            amp = r1 * r1 + r2 * r2;
        } while (amp >= 1);

        // transforming [-1,1] uniform to gaussian - inverse transform
        facc = sqrt(-2 * log(amp) /amp); 

        y  = ampy * r1 * facc; // scaling the gaussian
        py = ampy * r2 * facc; // scaling the gaussian

        out.push_back(x);
        out.push_back(px);
        out.push_back(y);
        out.push_back(py);

        return out;
    }
  
    std::vector<double> BiGaussian6DLongMatched(
        std::map<std::string, double> &paramMap,
        std::map<std::string, std::vector<double>> &inputMapVector,
        std::map<std::string, double> &twheader,
        std::vector<double> &bunchMapRow,
        int seed) {

            std::vector<double> h = inputMapVector["HarmonicNumbers"];

            double h0      = h[0];
            double tauhat  = bunchMapRow[7];
            double omega   = paramMap["omega"];
            double ampt    = bunchMapRow[3] / CONSTANTS::clight;
            double neta    = paramMap["eta"];
            double charge  = paramMap["charge"];
            double betar   = paramMap["betar"];
            double p0      = twheader["PC"];

            // Max value Hamiltonian that is stable
            // is, with the sign convention used, left of the ham contour
            // at 180-phis (The Ham rises lin to the right.)
            double hom     = (h0 * omega);
            double ts      = bunchMapRow[4] / hom;
            // int npi        = int(longparam["phis"] / (2.0 * pi));
            // double tperiod = 2.0 * pi / hom;
            // double ts2 = longparam["phisNext"] / hom + double(npi) * tperiod;
            double ts2     = bunchMapRow[5] / hom ;// + double(npi) * tperiod;
            double delta   = bunchMapRow[9];

            std::vector<double> out;
            out = BiGaussian4D(paramMap, bunchMapRow, seed);

            // adding two zeros
            out.push_back(0.0);
            out.push_back(0.0);

            double r1, r2, amp, facc, tc, ham, hammin;
            tc = (omega * neta * h0);
            //pc = (omega * charge ) / (2.0 * CONSTANTS::pi * p0 * 1.0e9 * betar);

            // max Hamiltonian (phis is the unstable point here - bunchMapRow[4])
            // as we want the max value for the Hamiltonian -> stable is around
            // the minimum.
            double hammax = HAMILTONIAN::Hamiltonian(
                twheader, 
                paramMap, 
                inputMapVector,
                bunchMapRow[4],
                tc, ts, 0.0);
  
                // select valid t values
                do {
                    r1 = 2.0 * RANDOM::ran3(&seed) - 1.0;
                    r2 = 2.0 * RANDOM::ran3(&seed) - 1.0;
                    amp = r1 * r1 + r2 * r2;
                    if (amp >= 1)
                        continue;

                    facc = sqrt(-2 * log(amp) / amp);
                    out[4] = ts2 + ampt * r1 * facc;
    
                    if (abs(out[4] - ts2) >= abs(ts - ts2))
                        continue;

                    // min Hamiltonian
                    hammin = HAMILTONIAN::Hamiltonian(
                        twheader, 
                        paramMap, 
                        inputMapVector,
                        bunchMapRow[4],
                        tc, out[4], 0.0);

                } while ((hammin > hammax) || (abs(out[4] - ts2) >= abs(ts - ts2)));

                // select matched deltas
                do {
                    r1 = 2.0 * RANDOM::ran3(&seed) - 1;
                    r2 = 2.0 * RANDOM::ran3(&seed) - 1;
                    amp = r1 * r1 + r2 * r2;

                    if (amp >= 1)
                    continue;

                    facc = sqrt(-2.0 * log(amp) / amp);
                    out[5] = bunchMapRow[9] * r2 * facc;

                    ham = HAMILTONIAN::Hamiltonian(
                        twheader, 
                        paramMap, 
                        inputMapVector,
                        bunchMapRow[4],
                        tc, out[4],out[5]);
                } while ((ham < hammin) || (ham > hammax));

            return out;
    }
    
    std::vector<std::vector<double>> GenerateDistributionMatched(
        std::map<std::string, double> &paramMap,
        std::map<std::string, std::vector<double>> &inputMapVector,
        std::map<std::string, int> &inputMapInt,
        std::map<std::string, double> &twheader,
        std::vector<double> &bunchMapRow
       ) {
      std::vector<std::vector<double>> out;
      int nMacro = inputMapInt["nMacro"];
      int seed = inputMapInt["seed"];
      for (int i = 0; i < nMacro; i++) {
        out.push_back(BiGaussian6DLongMatched(paramMap, inputMapVector, twheader, bunchMapRow, seed));
      }
      return out;
    }
    

}