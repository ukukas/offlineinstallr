# OfflineInstallR - Offline Installer for Pre-Downloaded R Packages


## CONSTANTS

# library directory into which to install packages
LIBRARY_DIR <- normalizePath(.Library)

# type of package to install (see install.packages for details)
# one of "source", "win.binary", "mac.binary", or "mac.binary.el-capitan"
# WARN: does not support "both" or "binary", must select from list above
TYPE = 'win.binary'

# set to TRUE to omit output
QUIET = TRUE

# set to TRUE to recursively search for packages in subdirectories
RECURSIVE = TRUE


## COMMAND-LINE ARGS

# read downloaded packages directory from command-line arguments

args <- commandArgs(trailingOnly = TRUE)

infomsg <- paste('specify full path of directory containing',
                 'downloaded packages as sole argument')

if (length(args) != 1) {
    stop(infomsg, call. = FALSE)
}

PACKAGES_DIR <- normalizePath(gsub('\"$', '', args[1]), mustWork = FALSE)

if (!dir.exists(PACKAGES_DIR)) {
    stop(paste0('directory "', PACKAGES_DIR, '" does not exist'), call. = FALSE)
}


## SETUP

# set filter pattern depending on selected package type

if (TYPE == 'win.binary') {
    PATTERN <- '\\.zip$'
} else if (TYPE == 'source') {
    PATTERN <- '\\.tar.gz$'
} else if (TYPE == 'mac.binary' || TYPE == 'mac.binary.el-capitan') {
    PATTERN = '.\\.tgz$'
} else {
    stop('invalid type', call. = FALSE)
}


## MAIN

# get list of downloaded package files to install
packages <- list.files(PACKAGES_DIR, pattern = PATTERN, full.names = TRUE,
                       recursive = RECURSIVE)

# ensure directory contains packages of specified type
if (length(packages) == 0) {
    stop(paste0('directory "', PACKAGES_DIR, '" does not contain any packages ',
                'of type "', TYPE, '"'), call. = TRUE)
}

# install all detected packages
install.packages(packages, LIBRARY_DIR, repos = NULL, type = TYPE,
                 quiet = QUIET)
