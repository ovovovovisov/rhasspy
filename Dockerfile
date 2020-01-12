ARG BUILD_ARCH=amd64
FROM ${BUILD_ARCH}/debian:buster-slim

RUN apt-get update
RUN apt-get install --no-install-recommends --yes \
        python3 python3-dev python3-setuptools python3-pip python3-venv

RUN apt-get install --no-install-recommends --yes \
        build-essential swig libatlas-base-dev portaudio19-dev \
        supervisor mosquitto sox alsa-tools 

ENV RHASSPY_DIR=/usr/lib/rhasspy-voltron
ENV RHASSPY_VENV=${RHASSPY_DIR}/.venv
ENV RHASSPY_PIP=${RHASSPY_VENV}/bin/pip3

COPY requirements.txt ${RHASSPY_DIR}/
RUN python3 -m venv ${RHASSPY_VENV}
RUN ${RHASSPY_PIP} install wheel setuptools
RUN ${RHASSPY_PIP} install https://github.com/synesthesiam/pocketsphinx-python/releases/download/v1.0/pocketsphinx-python.tar.gz
RUN ${RHASSPY_PIP} install -r ${RHASSPY_DIR}/requirements.txt
RUN ${RHASSPY_PIP} install https://github.com/Kitt-AI/snowboy/archive/v1.3.0.tar.gz

COPY bin/ ${RHASSPY_DIR}/bin/
COPY etc/ ${RHASSPY_DIR}/etc/
COPY web/ ${RHASSPY_DIR}/web/
COPY RHASSPY_DIRS ${RHASSPY_DIR}/
COPY VERSION ${RHASSPY_DIR}/

COPY rhasspy-asr/ ${RHASSPY_DIR}/rhasspy-asr/
COPY rhasspy-asr-pocketsphinx/ ${RHASSPY_DIR}/rhasspy-asr-pocketsphinx/
COPY rhasspy-asr-pocketsphinx-hermes/ ${RHASSPY_DIR}/rhasspy-asr-pocketsphinx-hermes/
COPY rhasspy-asr-kaldi/ ${RHASSPY_DIR}/rhasspy-asr-kaldi/
COPY rhasspy-asr-kaldi-hermes/ ${RHASSPY_DIR}/rhasspy-asr-kaldi-hermes/
COPY rhasspy-dialogue-hermes/ ${RHASSPY_DIR}/rhasspy-dialogue-hermes/
COPY rhasspy-hermes/ ${RHASSPY_DIR}/rhasspy-hermes/
COPY rhasspy-microphone-cli-hermes/ ${RHASSPY_DIR}/rhasspy-microphone-cli-hermes/
COPY rhasspy-microphone-pyaudio-hermes/ ${RHASSPY_DIR}/rhasspy-microphone-pyaudio-hermes/
COPY rhasspy-nlu/ ${RHASSPY_DIR}/rhasspy-nlu/
COPY rhasspy-nlu-hermes/ ${RHASSPY_DIR}/rhasspy-nlu-hermes/
COPY rhasspy-profile/ ${RHASSPY_DIR}/rhasspy-profile/
COPY rhasspy-server-hermes/ ${RHASSPY_DIR}/rhasspy-server-hermes/
COPY rhasspy-silence/ ${RHASSPY_DIR}/rhasspy-silence/
COPY rhasspy-speakers-cli-hermes/ ${RHASSPY_DIR}/rhasspy-speakers-cli-hermes/
COPY rhasspy-supervisor/ ${RHASSPY_DIR}/rhasspy-supervisor/
COPY rhasspy-tts-cli-hermes/ ${RHASSPY_DIR}/rhasspy-tts-cli-hermes/
COPY rhasspy-wake-porcupine-hermes/ ${RHASSPY_DIR}/rhasspy-wake-porcupine-hermes/
COPY rhasspy-wake-snowboy-hermes/ ${RHASSPY_DIR}/rhasspy-wake-snowboy-hermes/

WORKDIR ${RHASSPY_DIR}

ENTRYPOINT ["bin/rhasspy-voltron"]
