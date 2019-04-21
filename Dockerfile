# Dockerfile :
#     nanoserver.c

Arg imageVersion="latest"

Arg installer=servercore.c:${imageVersion}

# For the image nanoserver.c :
# nanoserver.c

# Building image..

From ${installer} as servercore

From nanoserver:${imageVersion}

Label maintainer="Autumn Chiang <autumn.snoopy@hotmail.com>"
Label package.ca.version="20190228"
Label package.ca.pkg.digests="11A8614AFC86"
Label package.ca.pkg.description="Certificate Authority"
Label package.PowerShell.version="6.2.0"
Label package.PowerShell.pkg.digests="C02AF438D3BC"
Label package.PowerShell.pkg.description="PowerShell core is a cross-platfrom command line shell and scripting language."

User ContainerAdministrator

# installing..
# installing package ca..
#Arg package_ca_name="CA"
#Arg package_ca_version="Latest"
Arg package_ca_installdir="C:/Certs"
    # get archive..
    Copy --from=servercore C:/Windows/System32/certoc.exe C:/Windows/System32/
    Copy --from=servercore ${package_ca_installdir} ${package_ca_installdir}/
Run certoc.exe -addstore Root %package_ca_installdir%/CA.cer

# installing package PowerShell..
#Arg package_PowerShell_name="PowerShell"
#Arg package_PowerShell_version="6.2.0"
Arg package_PowerShell_installdir="C:/Program Files/PowerShell"
    # get archive..
    Copy --from=servercore ${package_PowerShell_installdir} ${package_PowerShell_installdir}/

# post-install..*
# configuring env..
Run setx.exe /m PATH "%PATH%;%package_PowerShell_installdir%"

# Configuring image..

#Shell ["pwsh.exe","-Command"]

Entrypoint ["pwsh.exe","-Command"]