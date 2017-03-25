#include "argparser.hh"

Arg::Arg(int argc, char *argv[])
{
  for (int i = 0; i < argc; i++) /* posledni parametr musi byt hodnota - alespon tak to v zaklade funguje */
  {
    if ((i < (argc-1)) &&  (argv[i][0] == '-' ) && (argv[i+1][0] != '-') ) /* zkratove vyhodnoceni */
    {
      data[std::string(argv[i])]=std::string(argv[i+1]);
    }
    else if (argv[i][0] == '-')
    {
      data[std::string(argv[i])]=std::string("-");
    }
  }
}

std::string Arg::GetArgVal(std::string param)
{
  if (data[param] != "-") return data[param];

  return "";
}


///tak tohle zatim nechodi - jeste nevim, jak to presne udelam
bool Arg::ExistsArg(std::string param)
{
  if (data[param] != "") return true;
  return false;
}
