# PRRI-laGGer2023

Game development platforms course at the Faculty of Organization and Informatics, University of Zagreb, Croatia, Group 3 - laGGer platform


laGGer - lags but Good Game
---------------------------

laGGer is an open-source game streaming system implemented at the Artificial Intelligence Laboratory of the Faculty of Organization and Informatics, University of Zagreb, Croatia. It is a proof-of-concept system, not developed enough for a production environment.

laGGer allows for streaming Linux games from a X11Docker environment to a web application based on noVNC. It has a video/audio streaming functionality that allows real time sharing of gameplay, camera and microphone input.

Installation
------------

To install it quite a number of packages have to be installed and cofigured. It assumes a Debian Bullseye server machine. An installation script is provided:


```
cd laGGer
./install.sh
```

The installation script assumes that you will use self-signed SSL certificates. In case you want to use your own, edit the script.

In case you want to test and try it out, here you can find an installed [VirtualBox disk image](https://www.dropbox.com/sh/eu619xsmlpmyx5e/AAD3mqXy_BdZqRkS6v9P9ApAa?dl=1)



Configuration
-------------

For laGGer to run properly you have to edit the /config/organization.json file. The default values have been provided which should run fine. In case you want to use different certificates change the "cert" and "key" values in the config file. Also, in case you change the ports, make sure to allow them using ufw.

If you are using laGGer from VirtualBox using the image above, make sure to setup port forwarding. The following two scripts can automate that.

Linux:

```
#!/usr/bin/env bash

VBoxManage modifyvm "laGGer" --natpf1 "janus1,tcp,,8088,,8088";
VBoxManage modifyvm "laGGer" --natpf1 "janus2,tcp,,8089,,8089";
VBoxManage modifyvm "laGGer" --natpf1 "janus3,tcp,,8188,,8188";

for i in {49997..50100}; do
    echo "Opening port $i"
    VBoxManage modifyvm "laGGer" --natpf1 "tcp-port$i,tcp,,$i,,$i";
    VBoxManage modifyvm "laGGer" --natpf1 "udp-port$i,udp,,$i,,$i";
done

echo "Done!"
```
If it throws errors, try chmod 777, if it still doesn't work, tough luck.

Or on Windoze:

```
@echo off
SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox 
setlocal enabledelayedexpansion

VBoxManage modifyvm "laGGer" --natpf1 "janus1,tcp,,8088,,8088"
VBoxManage modifyvm "laGGer" --natpf1 "janus2,tcp,,8089,,8089"
VBoxManage modifyvm "laGGer" --natpf1 "janus3,tcp,,8188,,8188"

for /L %%i in (49997,1,50100) do (
    echo Opening port %%i
    VBoxManage modifyvm "laGGer" --natpf1 "tcp-port%%i,tcp,,%%i,,%%i"
    VBoxManage modifyvm "laGGer" --natpf1 "udp-port%%i,udp,,%%i,,%%i"
)

PAUSE
echo Done!
```

Running
-------

To run laGGer first run:

```
sudo ./start_root_first.sh
```

And then as a normal user:

```
./start.sh
```

If everything work and no errors happen, you should be able to open the interface at:

```
localhost:49998/list_catridges?player_id=player2
```


localhost:49998/list_catridges?player_id=ivek


Self signed certificates
------------------------

If you are using the built-in self signed certificates, you need to instruct your browser to trust all ports from your local domain. While there is no built-in option in Firefox or Chrome to accept self-signed certificates for all ports on a single IP address or domain, you can work around this by importing the self-signed certificate into your browser's trusted certificate store. By doing this, the browser will trust the certificate regardless of which port it is used on.

Here's how to import a self-signed certificate in Firefox and Chrome:

- Firefox:

  1.  Open Firefox and click on the menu button (three horizontal lines) in the top-right corner.
  2.  Click on "Options" or "Preferences" (depending on your Firefox version).
  3.  Scroll down to the "Privacy & Security" section.
  4.  In the "Certificates" section, click on "View Certificates."
  5.  In the "Certificate Manager" window, go to the "Authorities" tab.
  6.  Click on "Import" and navigate to the location where your self-signed certificate file is stored (usually in .crt, .cer, or .pem format). Select the certificate and click "Open."
  7.  Check the "Trust this CA to identify websites" box and click "OK."
  8.  Close the "Certificate Manager" window and restart Firefox.

Now, Firefox should trust your self-signed certificate for any port on the specified IP address or domain.

- Chrome:

  1.  Open Chrome and click on the menu button (three vertical dots) in the top-right corner.
  2.  Click on "Settings."
  3.  Scroll down and click on "Privacy and security."
  4.  Click on "Security."
  5.  Scroll down to the "Advanced" section and click on "Manage certificates."
  6.  In the "Certificate Manager" window, go to the "Authorities" tab.
  7.  Click on "Import" and navigate to the location where your self-signed certificate file is stored (usually in .crt, .cer, or .pem format). Select the certificate and click "Open."
  8.  Check the "Trust this certificate for identifying websites" box and click "OK."
  9.  Close the "Certificate Manager" window and restart Chrome.

Now, Chrome should trust your self-signed certificate for any port on the specified IP address or domain.

Setting up the VM
-----------------------
1. Copy the .vdi file somewhere on your device
2. Launch your virtualbox software(in our case Oracle VM VirtualBox)
3. 'New' button
    - Name: laGGer
    - Type: Linux
    - Version: Debian(64-bit), next
    - Memory & CPU whatever(reccomend 4096MB & min 2CPU), next
    - Use an Existing Virtual Hard Disk File -> Choose -> Add -> Find the .vdi and choose it
    - Finish
4. Start the VM & login
5. `cd src`
6. `./install.sh`
7. Shut down VM and run one of the scripts above to forward your ports.
8. Run the `start_root_first.sh` & `start.sh`
9. Visit `http://localhost:49998/list_catridges?player_id=player2`
10. You should be able to see the list of available games


Setting up Development environment
---------------------------------
After setting up your VM, we will now setup the development environment for it.  
Prerequisites: ran `install.sh`, `start_root_first.sh`, `start.sh` & port forwarded without errors, aka did the instructions above successfully.

1. Go into your favourite IDE or just use git to clone this repo into a folder. (If in VSCode, don't forget to change branches)
2. Launch your VM and log in.
3. Go to devices -> Shared folders -> Shared folder settings -> Click the small icon on the right with the plus sign to add a folder
    - Folder path: Other -> navigate to where you cloned the repo
    - Folder name: laGGer-dev
    - Auto-mount & Make Permanent is checked
    - Ok & apply
4. In the VM `cd /media` & then `ls`
5. If you see the folder `sf_laGGer-dev` you're almost there
6. In the VM `sudo adduser $USER vboxsf`
7. Reboot VM
8. In the VM `cd /media` & `cd sf_laGGer-dev` & `ls`
9. If all files are visible, `sudo ./start_root_first.sh` & `./start.sh`

**You should now be able to run and test laGGer directly from the shared folder.** 

Setting up Development environment (Windoze Edition)
---------------------------------
Cloning the repository via Windows will break most of the scripts due to CRLF and LF shenanigans, so in order to avoid this the repository should be cloned in the virtual machine itself.

Prerequisites: Same as above

1. Create an empty folder to store your repository in. 
2. Launch the VM and log in.
3. Add the **empty** folder to your VM shared folders (Step 3. in the instructions above)
4. Navigate to the media folder by typing 'cd /media/'
5. Type `sudo adduser $USER vboxsf` in the VM
6. Reboot the VM
7. Enter the shared folder (`cd /media/sf_name-of-the-folder`)
8. Type `git clone https://github.com/AILab-FOI/PRRI-laGGer2023.git`
9. You should now see the repo folder by typing `ls` (PRRI-laGGer2023), enter it with `cd PRRI-laGGer2023`
10. To change branch, first type `git config --global --add safe.directory '*'`
11. Switch to the laGGer-dev branch with `git checkout origin/laGGer-dev`

All the scripts should now be working correctly, and you should be able to launch laGGer via the repo folder.
