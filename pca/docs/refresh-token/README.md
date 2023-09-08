# Get Your Refresh Token for the Aria Automation API

Before making a call to Aria Automation, you request an API token that authenticates you for authorized API connections. The API token is also known as a "refresh token".

The Terraform provider for VMware Aria Automation accepts either a `refresh_token` or an `access_token`, but not both at the same time. 

* Refresh token are valid for **90 days**, when using the API.
* Access tokens are valid for **8 hours**, but times out after **25 minutes** of inactivity.

  For more information on obtaining an `access_token`, see [Get Your Access Token for the Aria Automation API](https://code.vmware.com/docs/14701/vrealize-automation-8-6-api-programming-guide/GUID-AC1E4407-6139-412A-B4AA-1F102942EA94.html) on VMware {code}.

## Procedures

### PowerShell Procedure

If you want to use the Terraform procedures that use the Terraform provider for Aria Automation, you must obtain an API refresh token from Aria Automation. You can a cmdlet included in the PowerValidatedSolutions Module.

1. Start Windows PowerShell.

1. Replace the values in the sample code with values from your *VMware Cloud Foundation Planning and Preparation Workbook* and run the commands in the PowerShell console.

    ```powershell
    $vraFqdn = "cloud.rainpole.io"
    $vraUser = "john.doe"
    $vraPass = "VMw@re1!"
    $vra = "rainpole.io"
    ```

1. Perform the configuration by running the command in the PowerShell console.

    ```powershell
    Request-vRAToken -fqdn $vraFqdn -username $vraUser -password $vraPass -displayToken
    ```

    The command output contains the refresh token.

    ```powershell
    ----------Refresh Token---------
    mx7w9**********************zB3UC
    --------------------------------
    ```

3. Use the `refresh_token` in the Terraform provider configuration. For example:

    ```hcl
    provider "vra" {
        url           = "https://api.mgmt.cloud.vmware.com"
        refresh_token = "mx7w9**********************zB3UC"
        insecure      = false
    }
    ```

### API Procedure

To request a `refresh_token` using the API, you will need your user credentials:

  * username
  * password
  * domain (optional)

In addition, you will need the fully qualified domain name (FQDN) of the endpoint associated with the identity access service. For Aria Automation 8, this will be the fully qualified domain name of the Aria Automation cluster VIP or appliance. For example, `cloud.rainpole.io`.

You then pass a JSON body containing the credentials to the API.

  **Example**: JSON body with domain.
  ```json
  {
    "username":"john.doe",
    "password":"VMw@re1!",
    "domain":"rainpole.io"
  }
  ```
  **Example**: JSON body without domain.
  ```json
  {
    "username":"john.doe",
    "password":"VMw@re1!"
  }
  ```

If successful, a JSON response will be returned with the value for the `refresh_token`.

#### API Using PowerShell Example

1. Set the variables:

    ```powershell

    $vraFqdn="cloud.rainpole.io"

    $vraUsername="john.doe"

    $vraPassword="VMw@re1!"

    $vraDomain="rainpole.io"

    $vraUrl="https://$vraFqdn/csp/gateway/am/api/login?access_token"

    $vraBody="{""username"":""$vraUsername"",""password"":""$vraPassword"",""domain"":""$vraDomain""}"
    ```
    
2. `POST` request to the API:

    ```powershell
    $vraResponse = Invoke-RestMethod -Method POST -ContentType "application/json" -URI $vraUrl -Body $vraBody
    ```

3. Get the `refresh_token`:

    ```powershell
    $vraResponse.refresh_token
    ```
    The `refresh_token` is returned.

    ```powershell
    mx7w9**********************zB3UC
    ```

4. Use the `refresh_token` in the Terraform provider configuration. For example:

    ```hcl
    provider "vra" {
      url           = "https://api.mgmt.cloud.vmware.com"
      refresh_token = "mx7w9**********************zB3UC"
      insecure      = false
    }
    ```

#### API Using Bash Example

1. Set the variables:

    ```bash
    vraFqdn=cloud@rainpole.io

    vraUsername=john.doe
    
    vraPassword=VMw@re1!
    
    vraDomain=rainpole.io
  
    vraUrl="https://"$vraFqdn"/csp/gateway/am/api/login?access_token"
    
    vraBody="{\"username\":\"$vraUsername\",\"password\":\"$vraPassword\",\"domain\":\"$vraDomain\"}"
    ```

2. `POST` request to the API:

    ```shell
    curl -k -X POST $vraUrl -H "Accept: application/json" -H "Content-Type: application/json" -s -d $vraBody
    ```
    The `refresh_token` is returned.

    ```shell
    {"refresh_token":"mx7w9**********************zB3UC"}
    ```

3. Use the `refresh_token` in the Terraform provider configuration. For example:

    ```hcl
    provider "vra" {
      url           = "https://cloud.rainpole.io"
      refresh_token = "mx7w9**********************zB3UC"
      insecure      = false
    }
    ```

### Scripts

Scripts for both PowerShell and Bash are included in the project repository in the `scripts` directory. These scripts will prompt you for the values and return the `refresh_token`.  

* PowerShell Script: [`get_token.ps1`](../../scripts/get_token.ps1)
* Bash Script: [`get_token.sh`](../../scripts/get_token.sh)

#### PowerShell Script on Windows: `get_token.ps1`

```powershell
> ./get_token.ps1

Enter the FQDN for the Aria Automation services: cloud.rainpole.io

Enter the username to authenticate with Aria Automation: john.doe

Enter the password to authenticate with Aria Automation: ********

Enter the domain or press enter to skip: rainpole.io

Successfully connected to the endpoint for Aria Automation services: cloud.rainpole.io

Generating Refresh Token...

----------Refresh Token---------
mx7w9**********************zB3UC
--------------------------------

Saving environmental variables...

VRA_URL = https://cloud.rainpole.io
VRA_REFRESH_TOKEN = mx7w9**********************zB3UC
```

#### Bash Script on Linux or macOS: `get_token.sh`

```bash
$ ./get_token.sh

Enter the FQDN for the Aria Automation services:
cloud.rainpole.io

Enter the username to authenticate with Aria Automation:
john.doe

Enter the password to authenticate with Aria Automation:
********

Enter the domain or press enter to skip:
rainpole.io

Generating Refresh Token...

----------Refresh Token---------
mx7w9**********************zB3UC
--------------------------------

Environmental variables...

VRA_URL = https://cloud.rainpole.io
VRA_REFRESH_TOKEN = mx7w9**********************zB3UC
```
