#!/bin/bash

function muestraayuda() {
  echo -e "\e[1mNOMBRE\e[0m"
  echo -e "\t genera_valores - Genera una serie de valores separados por comas."
  echo ""
  echo -e "\e[1mSINOPSIS\e[0m"
  echo -e "\t generar 5 valores entre 10 y 100:"
  echo -e "\t\t genera_valores.sh 5 10 100 "
  echo ""
  echo -e "\t generar 5 valores entre 10 y 100 con 6 decimales"
  echo -e "\t\t genera_valores.sh -n 5 -min 10 -max 100 -d 6"

  echo ""
  echo -e "\e[1mDESCRIPCIÓN\e[0m"
  echo -e "\t \e[1mgenera_valores\e[0m Genera una serie de valores entre los números indicados."
  echo -e "\t Estos valores los devuelve separados por comas para poder indicar como valor para ImageMagick, ffmpeg, G'MIC o cualquier otro comando que requiera un determinado número de valores."
  echo -e "\t Los valores pueden ser positivos o negativos, con o sin decimales."
  echo -e ""
  echo -e "\e[1mPARÁMETROS\e[0m"
  echo -e "\t [ \e[1m-n\e[0m | \e[1mnumero\e[0m ] Indica el número de valores que se requieren."
  echo -e "\t [ \e[1m-nat\e[0m | \e[1mnatural\e[0m ]Los valores generados no tendrán parte decimal."
  echo -e "\t [ \e[1m-d\e[0m | \e[1mdecimal\e[0m ] Los valores generados tendrán tantos decimales como el valor indicado"
  echo -e "\t [ \e[1m-r\e[0m | \e[1mrango\e[0m ] Tras «-r» hay que indicarle el menor y el mayor valor posible para que genere un valor aleatorio en ese rango."
  echo -e "\t [ \e[1m-min\e[0m | \e[1mminimo\e[0m ] En lugar de con -r de rango, se le puede indicar el valor mínimo con -min."
  echo -e "\t [ \e[1m-max\e[0m | \e[1mmaximo\e[0m ] En lugar de con -r de rango, se le puede indicar el valor máximo con -max."
  echo -e "\t [ \e[1m-a\e[0m | \e[1maproximado\e[0m ] Si en lugar de indicarle un valor máximo y un valor mínimo, se le quiere indicar un valor aproximado."
  echo -e "\t\t genera_valores devolverá valores de entre -20% y +20% del valor indicado."
  echo -e "\t\t Por razones obvias, no generará aleatoriedad con valores menores a 5."


}

function genera_valores() {
  # Genera una serie de valores separados por comas según los parámetros que se le indiquen.

  let pasada=1
  while [[ $# -gt 0 ]]
  do
      case $1 in
          -h|ayuda)
              muestraayuda
              exit 0
              ;;

          -n|n|numero)
              let numero=$2
              shift
              shift
              ;;
          -nat|natural|naturales)
              let natural=1
              shift
              ;;
          -d|decimal|decimales)
              let natural=0
              if [ -z $2 ] || [ $2 -le 0 ]
              then
                let decimales=1

              else
                let decimales=$2
                shift
              fi
              shift
              ;;
          -p|positivo|positivos)
              let entero=1
              shift
              ;;
          -neg|negativo|negativos)
              let entero=-1
              shift
              ;;
          -e|entero|enteros)
              let entero=0
              shift
              ;;
          -r|rango|entre)
              let minimo=$2
              let maximo=$3
              shift
              shift
              shift
              ;;
          -min|minimo)
              let minimo=$2
              shift
              shift
              ;;
          -max|maximo)
              let maximo=$2
              shift
              shift
              ;;
          -a|aproximado|aprox)
              let referencia=$2
              let aproximado=1
              shift
              shift
              let variacion=$referencia*20/100
              let minimo=$referencia-$variacion
              let maximo=$referencia+$variacion
              ;;
          *)

              # Si no tiene letra delante es que el usuario ha dado los parámetros en formato:
              # genera_valores 6 1 100 (seis valores entre uno y cien)
              if [ $numero ] && [ $pasada -le 1 ]
              then
                let pasada=$pasada+1
              fi
              if [ $minimo ] && [ $pasada -le 2 ]
              then
                let pasada=$pasada+1
              fi
              if [ $maximo ] && [ $pasada -le 3 ]
              then
                let pasada=$pasada+1
              fi


              case $pasada in
                  1)
                      let numero=$1
                      shift
                      let pasada=$pasada+1
                      ;;
                  2)
                      let minimo=$1
                      shift
                      let pasada=$pasada+1
                      ;;
                  3)
                      let maximo=$1
                      shift
                      let pasada=$pasada+1
                      ;;
                  *)
                      shift
                      ;;
                  esac
      esac
  done

  if [ ! $numero ]
  then
    echo "Ha de indicar un número de valores que desea."
    echo "Puede hacerlo con un número inmediatamente después del nombre del comando:"
    echo "./genera_valores 6 1 100"
    echo ""
    echo "O con «-n» y el número de valores que desee:"
    echo "./genera_valores -n 6 -r 1 100"

    exit 1
  fi
  if [ ! $minimo ] || [ ! $maximo ]
  then
    echo "Ha de indicar un rango numérico para los de valores."
    echo "Puede hacerlo escribiendo tres números inmediatamente después del nombre del comando:"
    echo "./genera_valores 6 1 100"
    echo "En este caso, el rango sería entre 1 y 100"
    echo ""
    echo "O con «-r» y el rango numérico que desee:"
    echo "./genera_valores -n 6 -r 1 100"

    exit 1
  fi
  if [ ! $natural ]
  then
    let natural=1
  fi
  if [ ! $entero ]
  then
    primercaracter=$(expr substr $minimo 1 1)
    if [ $primercaracter == "-" ]
    then
      primercaracter2=$(expr substr $maximo 1 1)
      if [ $primercaracter2 == "-" ]
      then
        let entero=-1
        maximo=$(echo "$minimo" | cut -c 2-)
        minimo=$(echo "$maximo" | cut -c 2-)
      else
        let entero=0
        minimo=$(echo "$minimo" | cut -c 2-)
      fi
    else
      let entero=0
    fi
  fi

echo "Entero "$entero

  for i in $(seq 1 $numero)
  do
    valor=$(shuf -i $minimo-$maximo -n 1)
    if [ $entero -gt 0 ]
    then
      signo=$(shuf -i 0-1 -n 1)
      if [ $signo -eq 0 ]
      then
        valor="-"$valor
      fi
    fi
    if [ $entero -lt 0 ]
    then
      valor="-"$valor
    fi


    maxdecimales=""
    if [ $natural -eq 0 ]
    then
      for i in $(seq 1 $decimales)
      do
        maxdecimales=$maxdecimales"9"
      done
      partedecimal=$(shuf -i 0-$maxdecimales -n 1)
      valor=$valor"."$partedecimal
    fi

    valores=$valores","$valor
  done
  valores=$(echo "$valores" | cut -c 2-)
  echo $valores
}


genera_valores $*
