#include "Random.cuh"
#include "Random.cu"
#include <vector>
#include <thrust/host_vector.h>
#include <map>

namespace DISTRIBUTIONS{

  thrust::host_vector<double> BiGaussian4D(
    std::map<std::string, double> &paramMap,
    std::vector<double> &bunchMapRow,
    int seed) {
        thrust::host_vector<double> out;
      
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
    
}