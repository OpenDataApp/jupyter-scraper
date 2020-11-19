# base image
FROM jupyter/base-notebook:latest
LABEL maintainer="Pablo Sierra <pavelsjo@gmail.com>"
LABEL description = "Data enviroment ready to scrape web using jupyter notebooks"

# install Oracle Instant Client 
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends firefox git
    
# install python modules
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
WORKDIR /home/jovyan/work
