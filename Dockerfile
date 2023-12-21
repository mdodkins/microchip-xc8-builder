# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install any dependencies here
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Copy MPLAB X and XC Compiler installers into the image
COPY MPLABX-v6.15-linux-installer.tar /tmp/MPLABXInstaller.tar
COPY xc8-v2.36-full-install-linux-x64-installer.run /tmp/XCCompilerInstaller.run

# Install MPLAB X
RUN cd /tmp && \
  tar -xf MPLABXInstaller.tar && \
  rm MPLABXInstaller.tar && \
  mv "MPLABX-v6.15-linux-installer.sh" mplabx && \
  sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe ${INSTALL_IPE} --collectInfo 0 --installdir /opt/mplabx ${MPLABX_ARG} && \
  rm mplabx

ARG COMPILER_NAME=xc8
ARG COMPILER_VERSION=2.36

# Download and install Compiler
RUN chmod +x /tmp/XCCompilerInstaller.run && \
  /tmp/XCCompilerInstaller.run --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix "/opt/microchip/${COMPILER_NAME}/v${COMPILER_VERSION}" && \
  rm /tmp/XCCompilerInstaller.run

# Set up environment variables, paths, etc.
#ENV [VARIABLE_NAME]=[VALUE]

# Set the default command for the container
#CMD ["/path/to/your/build/script.sh"]
