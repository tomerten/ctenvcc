#include "Datastructures.cuh"
#include <thrust/host_vector.h>
#include <vector>
#include <iterator>
#include <algorithm>


namespace DATASTRUCTURES {

thrust::host_vector<double6> hostVectorD6FromStdVector(std::vector<std::vector<double>> & orig){
    thrust::host_vector<double6> out;
    std::for_each(orig.begin(),orig.end(),
        [&](std::vector<double> &particle){
            double6 vec;
            vec.x     = particle[0];
            vec.px    = particle[1];
            vec.y     = particle[2];
            vec.py    = particle[3];
            vec.t     = particle[4];
            vec.delta = particle[5];
            
            out.push_back(vec);

        });
            
        return out;
    }

}