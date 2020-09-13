#!/bin/bash

function muestraayuda_genera_lienzo_tubos_de_neon() {
  echo -e "\e[1mNOMBRE\e[0m"
  echo -e "\t genera_lienzo_tubos_de_neon - Genera un lienzo con formas aleatorias de colores con transparencia y líneas curvas aleatorias."
  echo ""
  echo -e "\e[1mSINOPSIS\e[0m"
  echo -e "\t genera_lienzo_tubos_de_neon.sh "
  echo -e "\t genera_lienzo_tubos_de_neon.sh -an 1920 -al 1080 nombredelfichero.png"

  echo ""
  echo -e "\e[1mDESCRIPCIÓN\e[0m"
  echo -e "\t \e[1mgenera_lienzo_tubos_de_neon\e[0m Genera un lienzo con formas aleatorias de colores con transparencia y líneas curvas aleatorias."
  echo -e "\t Se le puede indicar la altura con «-al» o «altura» y el número de píxeles que se desea para la altura del lienzo."
  echo -e "\t Para indicarle la anchura, acepta los parámetros «-an» o «anchura»."
  echo -e "\t En caso de que no se le indique anchura o altura, se usará 1920 y 1080 como respectivos valores por defecto."
  echo -e "\t Escribiendo un nombre de fichero, se utilizará éste como nombre del fichero a generar."
  echo ""
  echo -e "\e[1mPARÁMETROS\e[0m"
  echo -e "\t [ \e[1m-an\e[0m | \e[1manchura\e[0m ] Genera un lienzo de la anchura indicada. Si no se le indica anchura, el valor por defecto es 1920"
  echo -e "\t [ \e[1m-al\e[0m | \e[1maltura\e[0m ] Genera un lienzo de la altura indicada. Si no se le indica altura, el valor por defecto es 1080"
  echo -e "\t \e[1mnombredelfichero.png\e[0m Indica el nombre del fichero que se generará con el lienzo. Si no se le indica un nombre de fichero, el valor por defecto es «lienzo_laberinto.png»."

}

function genera_lienzo_tubos_de_neon() {

while [[ $# -gt 0 ]]
do
    case $1 in
        -h|ayuda)
            muestraayuda_genera_lienzo_tubos_de_neon
            exit 0
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
if [[ ! $ficherosalida ]]
then
  numeroficheros=$(ls lienzo_tubos_de_neon* | wc -l)
  if [[ $numeroficheros = "0" ]]
  then
    ficherosalida="lienzo_tubos_de_neon.png"
  else
    let numeral=$numeroficheros+1
    ficherosalida="lienzo_tubos_de_neon_"$numeral".png"
  fi
fi

# Asignar valores aleatorios.

. genera_valores.sh

valores15=$(genera_valores 5 0 50)
valores68=$(genera_valores 3 50 100)
valor8=$(genera_valores 1 0 1 -d 1)
valores912=$(genera_valores 4 50 150)
valores1314=$(genera_valores 2 0 1 -d 2)

valores=$valores15","$valores68","$valor8","$valores912","$valores1314

echo $valores
# valores="50,50,0,50,50,100,50,0.7,3,130,80,50,0.25,0"

instruccion="gmic "$anchura","$altura",1,3 fx_neon_lightning "$valores" -output "$ficherosalida
eval $instruccion
echo $valores

# Comprueba que se ha generado con éxito.
if [[ -f $ficherosalida ]]
then
  # Devuelve el nombre del fichero generado por si se quiere almacenar en una variable
  echo $ficherosalida
else
  exit -1
fi
}


genera_lienzo_tubos_de_neon $*
