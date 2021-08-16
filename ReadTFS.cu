#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <list>
#include <map>
#include <sstream>
#include <stdio.h>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

map<string, double> GetTwissHeader(string filename) {
  vector<string> TWISSHEADERKEYS /* */ {
      "MASS",     "CHARGE",  "ENERGY",  "PC",      "GAMMA",   "KBUNCH",
      "BCURRENT", "SIGE",    "SIGT",    "NPART",   "EX",      "EY",
      "ET",       "BV_FLAG", "LENGTH",  "ALFA",    "ORBIT5",  "GAMMATR",
      "Q1",       "Q2",      "DQ1",     "DQ2",     "DXMAX",   "DYMAX",
      "XCOMAX",   "YCOMAX",  "BETXMAX", "BETYMAX", "XCORMS",  "YCORMS",
      "DXRMS",    "DYRMS",   "DELTAP",  "SYNCH_1", "SYNCH_2", "SYNCH_3",
      "SYNCH_4",  "SYNCH_5"};
  map<string, double> out;
  string line;
  ifstream file(filename);

  vector<int> labels;
  map<int, int> colmap;

  getline(file, line);
  // check if file is open
  if (file.is_open()) {
    // printf("File is open. Reading Twiss header.\n");
    // read lines until eof
    int counter = 0;
    string key;
    string at;
    double value;
    while (!file.eof() && counter < 41) {
      counter++;
      getline(file, line);
      istringstream iss(line);
      iss >> at >> key >> at >> value;
      vector<string>::iterator it =
          find(TWISSHEADERKEYS.begin(), TWISSHEADERKEYS.end(), key);
      // cout << key << " " << value << " " << endl;
      if (it != TWISSHEADERKEYS.end()) {
        out[key] = value;
      }
    }
  }
  file.close();
  // printf("File is closed. Done reading Twiss header.\n");
  return out;
}


map<string, vector<double>> GetTwissTableAsMap(string filename) {
  vector<string> TWISSCOLS /* */ {"L",    "BETX",  "ALFX", "BETY", "ALFY",
                                  "DX",   "DPX",   "DY",   "DPY",  "K1L",
                                  "K1SL", "ANGLE", "K2L",  "K2SL"};
  map<string, vector<double>> out;
  map<int, string> columnnames;

  string line;
  ifstream file(filename);

  if (file.is_open()) {
    // printf("File is open\n");

    vector<double> row;
    int rowcounter = 0;
    while (!file.eof()) {
      // update row counter
      rowcounter++;

      // read a line
      getline(file, line);

      // if line is 47 read the column names
      if (rowcounter == 47) {
        // load the current line as stream
        istringstream iss(line);

        // split the line and save in vector
        // vector<string> labels;
        int colcounter = 0;
        // cout << "Col idx: ";
        do {
          string sub;
          iss >> sub;
          vector<string>::iterator it =
              find(TWISSCOLS.begin(), TWISSCOLS.end(), sub);
          if (it != TWISSCOLS.end()) {
            columnnames[colcounter - 1] = sub;
            // cout << colcounter - 1 << " " << sub << endl;
          }
          ++colcounter;
        } while (iss);
      }
      if (rowcounter > 48) {
        istringstream iss(line);
        int colcounter = 0;
        do {
          string sub;
          string key;
          double value;
          iss >> sub;
          if (columnnames.count(colcounter) > 0) {
            key = columnnames[colcounter];
            value = stod(sub);
            // cout << key << " " << value << endl;
            out[key].push_back(value);
          }
          ++colcounter;
        } while (iss);
        // cout << endl;
      }
    }
  }
  file.close();
  return out;
}
