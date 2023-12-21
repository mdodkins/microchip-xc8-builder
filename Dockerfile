# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install any dependencies here
RUN apt-get update && apt-get install -y \
    sudo \
    libusb-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy MPLAB X and XC Compiler installers into the image
COPY MPLABX-v6.15-linux-installer.tar /tmp/MPLABXInstaller.tar
COPY xc8-v2.36-full-install-linux-x64-installer.run /tmp/XCCompilerInstaller.run

# Install MPLAB X
# on ./mplabx line... ${MPLABX_ARG}
RUN cd /tmp && \
  tar -xf MPLABXInstaller.tar && \
  rm MPLABXInstaller.tar && \
  mv "MPLABX-v6.15-linux-installer.sh" mplabx && \
  sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --collectInfo 0 --installdir /opt/mplabx  && \
  rm mplabx

ARG COMPILER_NAME=xc8
ARG COMPILER_VERSION=2.36

# Download and install Compiler
RUN chmod +x /tmp/XCCompilerInstaller.run && \
  /tmp/XCCompilerInstaller.run --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix "/opt/microchip/xc8/v2.36" && \
  rm /tmp/XCCompilerInstaller.run


COPY build.sh /build.sh
RUN ["chmod", "+x", "/build.sh"]
ENTRYPOINT [ "/build.sh" ]
