
# vmware-python 1.0

VMware Python container

---
- #### Categories: build, development
- #### Image: gcr.io/direktiv/functions/vmware-python 
- #### License: [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0)
- #### Issue Tracking: https://github.com/direktiv-apps/vmware-python/issues
- #### URL: https://github.com/direktiv-apps/vmware-python
- #### Maintainer: [direktiv.io](https://www.direktiv.io) 
---

## About vmware-python

This function provides a VMware Python environment with Pyenv as welll as pyVmomi installed. Other versions can be installed with `pyenv install 3.x.y`. [pyVmomi](https://pypi.org/project/pyvmomi/) is the Python SDK for the VMware vSphere API that allows you to manage ESX, ESXi, and vCenter.
The following versions are installed:
- Python: 3.10.5, 3.9.13, 3.8.13 - pyVmomi: 8.0.0.1.2 - setuptools: latest - vsphere-automation-sdk-python: vSphere 8.0 & VMware Cloud on AWS 1.20

You can change the python version by running the command `pyenv local 3.x.y` in the working directory. The image also contains pip, pipenv, and poetry.

The environment PYTHONUNBUFFERED is set to `x`

### Example(s)
  #### Function Configuration
```yaml
functions:
- id: vmware-python
  image: gcr.io/direktiv/functions/vmware-python:1.0
  type: knative-workflow
```
   #### Basic
```yaml
- id: python
  type: action
  action:
    function: vmware-python
    input: 
      commands:
      - command: python3 -c 'print("Hello World")'
```
   #### Environment Variables
```yaml
- id: python
  type: action
  action:
    function: vmware-python
    input:
      commands:
      - command: python3 -c 'import os;print(os.environ["hello"])'
        envs: 
        - name: hello
          value: world
```
   #### Switch version
```yaml
- id: python
  type: action
  action:
    function: vmware-python
    input:
      commands:
      - command: pyenv local 3.8.13
      - command: python3 -V
```
   #### Connect to vCenter
```yaml
- id: python
  type: action
  action:
    function: vmware-python
    input:
      files:
      - name: vcenter-connect.py
        data: |
          import requests
          import urllib3
          from vmware.vapi.vsphere.client import create_vsphere_client
          session = requests.session()

          # Disable cert verification for demo purpose. 
          # This is not recommended in a production environment.
          session.verify = False

          # Disable the secure connection warning for demo purpose.
          # This is not recommended in a production environment.
          urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

          # Connect to a vCenter Server using username and password
          vsphere_client = create_vsphere_client(server='<vc_ip>', username='<vc_username>', password='<vc_password>', session=session)

          # List all VMs inside the vCenter Server
          vsphere_client.vcenter.VM.list()               
      commands:
      - command: pyenv local 3.8.13
      - command: python3 vcenter-connect.py
```

   ### Secrets


*No secrets required*







### Request



#### Request Attributes
[PostParamsBody](#post-params-body)

### Response
  List of executed commands.
#### Reponse Types
    
  

[PostOKBody](#post-o-k-body)
#### Example Reponses
    
```json
[
  {
    "result": "Python 3.8.13",
    "success": true
  }
]
```

### Errors
| Type | Description
|------|---------|
| io.direktiv.command.error | Command execution failed |
| io.direktiv.output.error | Template error for output generation of the service |
| io.direktiv.ri.error | Can not create information object from request |


### Types
#### <span id="post-o-k-body"></span> postOKBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| vmware-python | [][PostOKBodyVmwarePythonItems](#post-o-k-body-vmware-python-items)| `[]*PostOKBodyVmwarePythonItems` |  | |  |  |


#### <span id="post-o-k-body-vmware-python-items"></span> postOKBodyVmwarePythonItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| result | [interface{}](#interface)| `interface{}` | ✓ | |  |  |
| success | boolean| `bool` | ✓ | |  |  |


#### <span id="post-params-body"></span> postParamsBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| commands | [][PostParamsBodyCommandsItems](#post-params-body-commands-items)| `[]*PostParamsBodyCommandsItems` |  | | Array of commands. |  |
| files | [][DirektivFile](#direktiv-file)| `[]apps.DirektivFile` |  | | File to create before running commands. |  |


#### <span id="post-params-body-commands-items"></span> postParamsBodyCommandsItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| command | string| `string` |  | | Command to run | `python3 -c 'print(\"jens\")` |
| continue | boolean| `bool` |  | | Stops excecution if command fails, otherwise proceeds with next command |  |
| envs | [][PostParamsBodyCommandsItemsEnvsItems](#post-params-body-commands-items-envs-items)| `[]*PostParamsBodyCommandsItemsEnvsItems` |  | | Environment variables set for each command. | `[{"name":"MYVALUE","value":"hello"}]` |
| print | boolean| `bool` |  | `true`| If set to false the command will not print the full command with arguments to logs. |  |
| silent | boolean| `bool` |  | | If set to false the command will not print output to logs. |  |


#### <span id="post-params-body-commands-items-envs-items"></span> postParamsBodyCommandsItemsEnvsItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| name | string| `string` |  | | Name of the variable. |  |
| value | string| `string` |  | | Value of the variable. |  |

 
