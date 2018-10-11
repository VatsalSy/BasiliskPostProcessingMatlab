/* Title: Janus Drops
# Author: Vatsal Sanjay
# vatsalsanjay@gmail.com
# Physics of Fluids
*/
#include "fractions.h"
#include "navier-stokes/centered.h"
scalar f1[];
scalar f2[];
scalar f3[];
char filename[80];

int main(int a, char const *arguments[])
{
  sprintf (filename, "%s", arguments[1]);
  int CASE = atoi(arguments[2]);
  restore (file = filename);
  FILE * fp = ferr;
  if (CASE == 1){
    output_facets(f1,fp);
  } else if (CASE == 2){
    output_facets(f2,fp);
  } else {
    output_facets(f3,fp);
  }
  fclose (fp);
}
