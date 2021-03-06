/*
Copyright (C) 2013 Bruno Golosio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
//////////////////////////////////////////////////
//               loadparams.cpp                 //
//                06/02/2013                    //
//         author: Bruno Golosio                //
//////////////////////////////////////////////////
// xrmc method for loading simulation parameters
//

#include <time.h>
#include <iostream>
#include <string>
#include "xrmc.h"
#include "xrmc_algo.h"
#include "xrmc_gettoken.h"
#include "xrmc_exception.h"
#ifdef _OPENMP
#include <omp.h>
#endif

using namespace std;
using namespace gettoken;
using namespace xrmc_algo;

//////////////////////////////////////////////////////////////////////
// method for loading simulation parameters
// fp is a pointer to the main input file
//////////////////////////////////////////////////////////////////////
int xrmc::LoadParams(istream &fs)
{
  string file_name, comm="";
  time_t t1;
  long seed;

  GetToken(fs, file_name); // read the name of the parameter file
  cout << "Parameters file: " << file_name << "\n";
  ifstream par_fs(file_name.c_str());
  if (!par_fs)
    throw xrmc_exception("Parameters file not found.\n");

  GetToken(par_fs, comm); // get a command/variable name from input file
  if(comm!="Seed")
    throw xrmc_exception("syntax error in parameter file. "
			 "Seed command expected"); 
  else {
    GetLongToken(par_fs, &seed); // read the starting seed for random numbers
    cout << "The Seed argument in the parameters file is now ignored. Use the detector input-file instead" << endl;
  }

  par_fs.close();

  return 0;
}
