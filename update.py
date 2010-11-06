#!/usr/bin/env python

"""
Ensures bundles specified in ~/.vim/bundles.json are added up to bundle/ directory and are up to date
Requires [Pathogen.vim](https://http://www.vim.org/scripts/script.php?script_id=2332)
Maintainer: Arun <alias@alias.in, s/alias/codito/g>
"""
import json
import os
import subprocess

# List of script objects
scripts = []

class VimScript:
    """
    Concept of a script instance
    """
    def __init__(self, script_dict):
        try:
            self.name = script_dict['name']
            self.repo = script_dict['repo']
            self.desc = script_dict['desc']
        except:
            print("VimScript: Failed to create object!")

    def __str__(self):
        print("name = " + self.name)
        print("repository = " + self.repo)
        print("description = " + self.desc)
        print("----")

    def sync(self):
        dotvim = get_dotvim()
        bundle_name = os.path.join("bundle", self.name)
        pwd = os.getcwd()
        os.chdir(dotvim)

        # Add the submodule if not already added up!
        if os.path.exists(bundle_name):
            print("Script already exists as submodule.")
        else:
            command = "git submodule add " + self.repo + " " + bundle_name
            print("Adding submodule: " + command)
            p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
            p.wait()

        os.chdir(pwd)

def create_script_object(d):
    """
    Deserialize the JSON string into a VimScript object
    """
    scripts.append(VimScript(d))

def get_dotvim():
    vimfiles = ".vim"
    if os.sys.platform == 'win32':
        vimfiles = "vimfiles"
    return os.path.expanduser(os.path.join("~", vimfiles))

if __name__ == "__main__":
    config_file = open(os.path.join(get_dotvim(), "bundles.json"), 'r')
    json.load(config_file, object_hook=create_script_object)

    # sync 'em
    print("-- Init all submodules")
    p = subprocess.Popen("git submodule init", stdout=subprocess.PIPE, shell=True)
    p.wait()
    print("Complete.")

    for script in scripts:
        print("-- Script: '" + script.name + "'")
        script.sync()
        print("Complete.")

    print("-- Update all submodules")
    p = subprocess.Popen("git submodule update", stdout=subprocess.PIPE, shell=True)
    p.wait()
    print("Complete.")

# TODO In case you're bored...
# - Support for other hg,bzr etc., for now use stable releases via github.com/vimscripts
# - Support specific repo related stuff: branch, tag etc.
