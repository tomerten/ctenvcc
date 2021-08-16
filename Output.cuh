#ifndef OUTPUT_H
#define OUTPUT_H

#include <thrust/host_vector.h>
#include <thrust/copy.h>

/*
template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &v) {
  for (int i = 0; i < v.size(); i++) {
    os << std::scientific << std::setw(15) << v[i];
  }
  // os << std::endl;
  // std::copy(v.begin(), v.end(), ostream_iterator<T>(os, "\t"));
  return os;
}
*/
template <typename T>
std::ostream &operator<<(std::ostream &os,
                         const std::vector<std::vector<T>> &v) {
  using namespace std;

  // NOTE: for some reason std::copy doesn't work here, so I use manual loop
  // copy(v.begin(), v.end(), ostream_iterator<std::vector<T>>(os, "\n"));

  for (size_t i = 0; i < v.size(); ++i)
    os << std::setw(6) << i+1 << v[i] << "\n";
  return os;
}

namespace OUTPUT{

    void PrintInputVectorMap(std::map<int, std::vector<double>> inputMapVector);
}

#endif