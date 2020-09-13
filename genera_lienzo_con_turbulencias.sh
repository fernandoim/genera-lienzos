#!/bin/bash

function muestraayuda() {
  echo -e "\e[1mNOMBRE\e[0m"
  echo -e "\t genera_lienzo_con_turbulencias - Genera un lienzo con turbulencias."
  echo ""
  echo -e "\e[1mSINOPSIS\e[0m"
  echo -e "\t genera_lienzo_con_turbulencias.sh "
  echo -e "\t genera_lienzo_con_turbulencias.sh -an 1920 -al 1080 nombredelfichero.png"

  echo ""
  echo -e "\e[1mDESCRIPCIÓN\e[0m"
  echo -e "\t \e[1mgenera_lienzo_con_turbulencias\e[0m Genera un lienzo con triángulos de Sierpinski dibujados."
  echo -e "\t Se le puede indicar la altura con «-al» o «altura» y el número de píxeles que se desea para la altura del lienzo."
  echo -e "\t Para indicarle la anchura, acepta los parámetros «-an» o «anchura»."
  echo -e "\t En caso de que no se le indique anchura o altura, se usará 1920 y 1080 como respectivos valores por defecto."
  echo -e "\t Se puede elegir el color de fondo con «-b» o «blanco» para que el fondo sea blando y «-n» o «negro» para un fondo negro."
  echo -e "\t Si no se le indica color de fondo, será blano o negro aleatoriamente."
  echo -e "\t Escribiendo un nombre de fichero, se utilizará éste como nombre del fichero a generar."
  echo -e "\e[1mPARÁMETROS\e[0m"
  echo -e "\t [ ]\e[1m-bn\e[0m | \e[1mblancoynegro\e[0m ] Genera un lienzo en blanco y negro un dibujo de turbulencias."
  echo -e "\t [ \e[1m-c\e[0m | \e[1mcolor\e[0m ]Genera un lienzo en color con un dibujo de turbulencias."
  echo -e "\t [ \e[1m-an\e[0m | \e[1manchura\e[0m ] Genera un lienzo de la anchura indicada. Si no se le indica anchura, el valor por defecto es 1920"
  echo -e "\t [ \e[1m-al\e[0m | \e[1maltura\e[0m ] Genera un lienzo de la altura indicada. Si no se le indica altura, el valor por defecto es 1080"
  echo -e "\t \e[1mnombredelfichero.png\e[0m Indica el nombre del fichero que se generará con el lienzo. Si no se le indica un nombre de fichero, el valor por defecto es «lienzo_con_turbulencias.png»."

}

function genera_lienzo_con_turbulencias() {
  # Genera un lienzo con el dibujo de un con_turbulencias.

while [[ $# -gt 0 ]]
do
    case $1 in
        -h|ayuda)
            muestraayuda
            exit 0
            ;;
        -bn|blancoynegro)
            let color=0
            shift
            ;;
        -c|color)
            let color=1
            shift
            ;;
        -al|altura)
            let altura=$2
            shift
            shift
            ;;
        -an|anchura)
            let anchura=$2
            shift
            shift
            ;;
        *)

            # Si tiene un punto «puede» que sea el nombre de un fichero.

            if [[ "$1" == *"."* ]]
            then
              ficherosalida=$1
            fi
            shift
            ;;
    esac
done


if [[ ! $anchura ]]
then
  let anchura=1920
fi
if [[ ! $altura ]]
then
  let altura=1080
fi
if [[ ! $color ]]
then
  color=1
fi
if [[ ! $ficherosalida ]]
then
  numeroficheros=$(ls lienzo_con_turbulencias* | wc -l)
  if [[ $numeroficheros = "0" ]]
  then
    ficherosalida="lienzo_con_turbulencias.png"
  else
    let numeral=$numeroficheros+1
    ficherosalida="lienzo_con_turbulencias_"$numeral".png"
  fi
fi

valor=$(shuf -i 1-100 -n 1)


  if [[ $color -eq 1 ]]
  then
    gmic $anchura","$altura",1,3" turbulence $valor -output $ficherosalida
  else
    gmic $anchura","$altura turbulence $valor normalize 0,255 -output $ficherosalida
  fi

  # Comprueba que se ha generado con éxito.
  if [[ -f $ficherosalida ]]
  then
    # Devuelve el nombre del fichero generado por si se quiere almacenar en una variable
    echo $ficherosalida
  else
    exit -1
  fi
}


genera_lienzo_con_turbulencias $*
