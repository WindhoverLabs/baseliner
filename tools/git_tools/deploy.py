"""
 
    Copyright (c) 2021 Windhover Labs, L.L.C. All rights reserved.
 
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
 
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.
  3. Neither the name Windhover Labs nor the names of its contributors 
     may be used to endorse or promote products derived from this software
     without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.

"""

__author__ = 'Mathew Benson'

""" 
Usage:
python deploy.py [path to yaml file]
"""

import sys
import os
import yaml
import subprocess
import time


def add_module(module_name, prefix, config):
    max_retry = 3
    
    if not module_name in config:
        print("" + module_name + " module not found.")
        print('')
        print('*****************************************')
        return -1

    module = config[module_name]

    if not 'url' in module:
        print("" + module_name + " URL not defined.")
        print('')
        print('*****************************************')
        return -1
    url = module['url']

    if not 'branch' in module:
        print("" + module_name + " branch not defined.")
        print('')
        print('*****************************************')
        return -1
    branch = module['branch']

    if not 'path' in module:
        print("" + module_name + " path not defined.")
        print('')
        print('*****************************************')
        return -1
    path = module['path']

    if not 'strategy' in module:
        print("" + module_name + " strategy not defined.")
        print('')
        print('*****************************************')
        return -1
    strategy = module['strategy']

    # Add the module repo
    if strategy == 'subtree':
        remote_name = prefix + module_name
        print("git", "remote", "add", "-f", remote_name, url)
        
        return_code = subprocess.call(["git", "remote", "add", "-f", remote_name, url])
        if return_code != 0:
            print('')
            print('error:  rc =',return_code)
            print('*****************************************')
            return -1;
        attempt = 0
        while attempt < max_retry:
            print("git", "subtree", "add", "--prefix", path, remote_name, branch)
            return_code = subprocess.call(["git", "subtree", "add", "--prefix", path, remote_name, branch])
            if return_code != 0:
                print('')
                print('error:  rc =',return_code)
                attempt = attempt + 1
                print('Retry attempt',attempt)
            else:
                break
        if attempt >= max_retry
            print('*****************************************')
            return -1;
    elif strategy == 'submodule':
        attempt = 0
        while attempt < max_retry:
            print("git", "submodule", "add", "-f", url, path)
            return_code = subprocess.call(["git", "submodule", "add", "-f", url, path])
            if return_code != 0:
                print('')
                print('error:  rc =',return_code)
                attempt = attempt + 1
                print('Retry attempt',attempt)
            else:
                break
        if attempt >= max_retry
            print('*****************************************')
            return -1;
            
        attempt = 0
        while attempt < max_retry:
            print("git", "submodule", "init")
            return_code = subprocess.call(["git", "submodule", "init"])
            if return_code != 0:
                print('')
                print('error:  rc =',return_code)
                attempt = attempt + 1
                print('Retry attempt',attempt)
            else:
                break
        if attempt >= max_retry
            print('*****************************************')
            return -1;
            
        attempt = 0
        while attempt < max_retry:
            print("git", "checkout", branch)
            return_code = subprocess.call(["git", "checkout", branch], cwd=path)
            if return_code != 0:
                print('')
                print('error:  rc =',return_code)
                attempt = attempt + 1
                print('Retry attempt',attempt)
            else:
                break
        if attempt >= max_retry
            print('*****************************************')
            return -1;
            
        attempt = 0
        while attempt < max_retry:
            print("git", "add", path)
            return_code = subprocess.call(["git", "add", path])
            if return_code != 0:
                print('')
                print('error:  rc =',return_code)
                attempt = attempt + 1
                print('Retry attempt',attempt)
            else:
                break
        if attempt >= max_retry
            print('*****************************************')
            return -1;
            
        attempt = 0
        while attempt < max_retry:
            print("git", "commit", "-m", "Added submodule '" + path + "'")
            return_code = subprocess.call(["git", "commit", "-m", "Added submodule '" + path + "'"])
            if return_code != 0:
                print('')
                print('error:  rc =',return_code)
                attempt = attempt + 1
                print('Retry attempt',attempt)
            else:
                break
        if attempt >= max_retry
            print('*****************************************')
            return -1;
    else:
        print('Undefined strategy of ' + strategy)
        return -1

    print('')
    print('*****************************************')
            
    return 0



def main():   
    """"
    """
    # Load the configuration file
    if len(sys.argv) == 2 :
        config_file_name = sys.argv[1]
                    
        with open(config_file_name, 'r') as inFile:   
            config = yaml.load(inFile, Loader=yaml.FullLoader)
            
            result = add_module('core', '', config)
            if result != 0:
                print('Failed to add core module')
                return result
            
            core = config['core']

            if not 'osal' in core:
                print('OSAL module not found')
                return -1
            for osal_name in config['core']['osal']:
                result = add_module(osal_name, 'core-osal-', config['core']['osal'])
                if result != 0:
                    print('Failed to add osal module "' + osal_name + '"')
                    return result

            if not 'psp' in core:
                print('PSP module not found')
                return -1
            for psp_name in config['core']['psp']:
                result = add_module(psp_name, 'core-psp-', config['core']['psp'])
                if result != 0:
                    print('Failed to add psp module "' + psp_name + '"')
                    return result

            if 'tools' in config:
                for tool_name in config['tools']:
                    result = add_module(tool_name, 'tool-', config['tools'])
                    if result != 0:
                        print('Failed to add tools module "' + tool_name + '"')
                        return result

            if 'apps' in config:
                for app_name in config['apps']:
                    result = add_module(app_name, 'app-', config['apps'])
                    if result != 0:
                        print('Failed to add app module "' + app_name + '"')
                        return result

            subprocess.call(["git", "submodule", "update", "--init", "--recursive"])

    else:
        print("Incorrect parameters.")
        return -1

if __name__ == '__main__':
    main()
