#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Tela
COLOR_VARIANTS=('' '-red' '-pink' '-purple' '-blue' '-green' '-yellow' '-orange' '-brown' '-grey' '-black')
BRIGHT_VARIANTS=('' '-Dark')

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-c, --color VARIANTS..." "Specify theme color variant(s) [standard|red|pink|purple|blue|green|yellow|orange|brown|grey|black] (Default: All variants)"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local dest=${1}
  local name=${2}
  local color=${3}
  local bright=${4}

  local THEME_DIR=${dest}/${name}${color}${bright}

  [[ -d ${THEME_DIR} ]] && rm -rf ${THEME_DIR}

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                             ${THEME_DIR}
  cp -ur ${SRC_DIR}/COPYING                                                            ${THEME_DIR}
  cp -ur ${SRC_DIR}/AUTHORS                                                            ${THEME_DIR}
  cp -ur ${SRC_DIR}/src/index.theme                                                    ${THEME_DIR}

  cd ${THEME_DIR}
  sed -i "s/Tela/Tela${color}${bright}/g" index.theme

  if [[ ${bright} != '-Dark' ]]; then
    cp -ur ${SRC_DIR}/src/{16,22,24,32,scalable,symbolic}                              ${THEME_DIR}
    cp -r ${SRC_DIR}/links/{16,22,24,32,scalable,symbolic}                             ${THEME_DIR}
    [[ ${color} != '' ]] && \
    cp -r ${SRC_DIR}/src/colors/color${color}/scalable/*.svg                           ${THEME_DIR}/scalable/places
  fi

  if [[ ${bright} == '-Dark' ]]; then
    mkdir -p                                                                           ${THEME_DIR}/16
    mkdir -p                                                                           ${THEME_DIR}/22
    mkdir -p                                                                           ${THEME_DIR}/24
    mkdir -p                                                                           ${THEME_DIR}/32

    cp -ur ${SRC_DIR}/src/16/{actions,devices,places}                                  ${THEME_DIR}/16
    cp -ur ${SRC_DIR}/src/22/actions                                                   ${THEME_DIR}/22
    cp -ur ${SRC_DIR}/src/24/actions                                                   ${THEME_DIR}/24

    cd ${THEME_DIR}/16/actions && sed -i "s/565656/aaaaaa/g" `ls`
    cd ${THEME_DIR}/16/devices && sed -i "s/565656/aaaaaa/g" `ls`
    cd ${THEME_DIR}/16/places && sed -i "s/727272/aaaaaa/g" `ls`
    cd ${THEME_DIR}/22/actions && sed -i "s/565656/aaaaaa/g" `ls`
    cd ${THEME_DIR}/24/actions && sed -i "s/565656/aaaaaa/g" `ls`

    cp -r ${SRC_DIR}/links/16/actions                                                  ${THEME_DIR}/16
    cp -r ${SRC_DIR}/links/16/devices                                                  ${THEME_DIR}/16
    cp -r ${SRC_DIR}/links/16/places                                                   ${THEME_DIR}/16
    cp -r ${SRC_DIR}/links/22/actions                                                  ${THEME_DIR}/22
    cp -r ${SRC_DIR}/links/24/actions                                                  ${THEME_DIR}/24

    cd ${dest}
    ln -s ../${name}${color}/scalable ${name}${color}-Dark/scalable
    ln -s ../${name}${color}/symbolic ${name}${color}-Dark/symbolic
    ln -s ../../${name}${color}/16/apps ${name}${color}-Dark/16/apps
    ln -s ../../${name}${color}/16/mimetypes ${name}${color}-Dark/16/mimetypes
    ln -s ../../${name}${color}/16/panel ${name}${color}-Dark/16/panel
    ln -s ../../${name}${color}/16/status ${name}${color}-Dark/16/status
    ln -s ../../${name}${color}/22/emblems ${name}${color}-Dark/22/emblems
    ln -s ../../${name}${color}/22/panel ${name}${color}-Dark/22/panel
    ln -s ../../${name}${color}/24/animations ${name}${color}-Dark/24/animations
    ln -s ../../${name}${color}/24/panel ${name}${color}-Dark/24/panel
    ln -s ../../${name}${color}/32/devices ${name}${color}-Dark/32/devices
  fi

  [[ ${color} != '' ]] && \
  cp -r ${SRC_DIR}/src/colors/color${color}/16/*.svg                                 ${THEME_DIR}/16/places/

  cd ${dest}
  gtk-update-icon-cache ${name}${color}${bright}
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -c|--color)
      shift
      for color in "${@}"; do
        case "${color}" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift 1
            ;;
          red)
            colors+=("${COLOR_VARIANTS[1]}")
            shift 1
            ;;
          pink)
            colors+=("${COLOR_VARIANTS[2]}")
            shift 1
            ;;
          purple)
            colors+=("${COLOR_VARIANTS[3]}")
            shift 1
            ;;
          blue)
            colors+=("${COLOR_VARIANTS[4]}")
            shift 1
            ;;
          green)
            colors+=("${COLOR_VARIANTS[5]}")
            shift 1
            ;;
          yellow)
            colors+=("${COLOR_VARIANTS[6]}")
            shift 1
            ;;
          orange)
            colors+=("${COLOR_VARIANTS[7]}")
            shift 1
            ;;
          brown)
            colors+=("${COLOR_VARIANTS[8]}")
            shift 1
            ;;
          grey)
            colors+=("${COLOR_VARIANTS[9]}")
            shift 1
            ;;
          pink)
            colors+=("${COLOR_VARIANTS[10]}")
            shift 1
            ;;
          black)
            colors+=("${COLOR_VARIANTS[11]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

for color in "${colors[@]-${COLOR_VARIANTS[@]}}"; do
  for bright in "${brights[@]-${BRIGHT_VARIANTS[@]}}"; do
    install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}" "${bright}"
  done
done

