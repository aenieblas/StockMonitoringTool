FROM rocker/r-ver:4

MAINTAINER Enrico Anello "enrico.anello@fao.org"


# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-openssl-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libjpeg-dev \
    default-jre \
    default-jdk \
    libxml2-dev \
    libudunits2-dev \
    libproj-dev \
    libgeos-dev \
    libgdal-dev \
    git \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-formats-extra \
    libv8-dev \
	libsodium-dev \
    libsecret-1-dev
	


RUN apt-get update && apt-get upgrade -y

# install dependencies of the Stock monitoring tool app
RUN R -e "install.packages(c('devtools','XML', 'xml2','shiny','rmarkdown','shinyjs','shinythemes','shinydashboard','shinyWidgets','RCurl','ggplot2','rfishbase','shinyBS','lubridate','waiter','pracma','googleVis','stringr','R.utils','fishmethods','V8','DT','futile.logger','TropFishR','nloptr','R6','sodium','keyring'), repos='https://cran.r-project.org/')"
RUN R -e "devtools::install_github('eblondel/d4storagehub4R')"
RUN R -e "devtools::install_github('eblondel/ows4R')"
RUN R -e "devtools::install_github('AnalytixWare/ShinySky')"

#Development
RUN git -C /root/ clone https://github.com/abennici/StockMonitoringTool.git && echo "OK!"
#Deployment
#RUN git -C /root/ clone https://github.com/pink-sh/StockMonitoringTool.git && echo "OK!"
RUN mkdir -p /srv/shiny/
RUN ln -s /root/StockMonitoringTool /srv/shiny/stockMonitoringTools
 
EXPOSE 3838

ENV SMT_LOG=session.log

RUN apt-get install -y curl
#Development
CMD ["R", "-e shiny::runApp('/srv/shiny/stockMonitoringTools',port=3838,host='0.0.0.0')"]
#Deployment
#CMD ["R", "-e shiny::runApp('/srv/shiny/stockMonitoringTools')"]
