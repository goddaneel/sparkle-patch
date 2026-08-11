### FROM
FROM registry.fedoraproject.org/fedora-minimal:latest



### USER
USER root



### RUN
## dnf
# update
RUN dnf upgrade --refresh -y

# install
RUN dnf install -y git
RUN dnf install -y just
RUN dnf install -y flatpak-builder
RUN dnf install -y shasum
RUN dnf install -y xmlstarlet

# clean
RUN dnf autoremove -y
RUN dnf clean all -y


## flatpak
# remote
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# update
RUN flatpak update -y

# install
RUN flatpak install -y "org.gnome.Sdk//50"
RUN flatpak install -y "org.gnome.Platform//50"

# clean
RUN flatpak uninstall --system --unused --delete-data -y