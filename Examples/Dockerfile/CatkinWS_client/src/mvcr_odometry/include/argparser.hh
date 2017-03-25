#ifndef ARGPARSER_LUZA_2008
  #define ARGPARSER_LUZA_2008
  #include <string>
  #include <map>

  class Arg{
    private:
      std::map<std::string, std::string> data; /**< pole stringu pro data */
    public:
      /** @brief Fce pro inicializaci objetku - zpracovani arg. z prik radky - <b>KONSTRUKTOR</b>
       * Funkce zpracovava argumenty z prikazove radky. Argumenty pro zpracovani touto funkci jsou ve tvaru <i>-parametr</i> <i>hodnota</i>.
       * @param argc - typu int - počet argumentů z CLI
       * @param argv - typu char *[] - argumenty z CLI
       */
      Arg(int argc, char *argv[]);
      /** @brief Získání hotnoty konkretniho argumentu
       * Vrati hodnoty argumentu za parametrem param.
       * @param param - typu std::string - hledany parametr.
       * @return Vrací hodnotu argumentu.
       */
      std::string GetArgVal(std::string param);
      /** @brief Ověření existence konkrétního parametru
       * Vrati informaci o tom, zda hledany argument byl programu zadan
       * @param param - typu std::string - hledany parametr.
       * @return Vrací informaci, zda takovy argument existuje.
       */
      bool ExistsArg(std::string param);
  };
#endif
