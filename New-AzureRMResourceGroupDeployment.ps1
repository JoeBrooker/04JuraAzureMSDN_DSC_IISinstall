

Param(
$DeploymentName = '04 JuraAzureMSDN_DSC_IISinstall',
$AzureUserName = "john.smith@juralab.club",
$AzurePassword = "Password01",
$VMAdminUsername = "norma.finch",
$VMAdminPassword = "Password01",
$resourcegroupname = 'juracorporation',
$JSONTemplate = "D:\Box Sync\Technical Skills\Products\Azure (PAYG)\Azure IAAS - Azure VMs (PAYG)\Automation\ARM Templates\04 JuraAzureMSDN_DSC_IISinstall\azureVMdeploy.json",
$JSONparamtemplate = "D:\Box Sync\Technical Skills\Products\Azure (PAYG)\Azure IAAS - Azure VMs (PAYG)\Automation\ARM Templates\04 JuraAzureMSDN_DSC_IISinstall\azureVMdeploy.parameters.json"
)




#New-AzureRmResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $resourcegroup -TemplateUri D:\ARMTemplates\JuraStandardAzureVM.json


Write-verbose "Logging into Azure"
#Create a Credential block and connect to to Azure
#$cred = [System.Management.Automation.PSCredential]::new($AzureUserName,($AzurePassword | ConvertTo-SecureString -AsPlainText -Force))
#import-module Azurerm
Login-AzureRmAccount | Out-Null

Write-verbose "Storing paths for JSON files"
#Path to JSON Files
$templatefile = "$JSONTemplate"
$templateparamfile = "$JSONParamTemplate"

$deployparams = @{
Name = "ArmDeploy-$(get-date -Format ddMMyyyy_HH-mm-ss)"
ResourceGroupName = $resourcegroupname
TemplateFile = $templatefile
Verbose = $true
}

Write-verbose "Calling ARM to deploy VM"
$VMpass = $VMAdminPassword | ConvertTo-SecureString -AsPlainText -Force
#$DJPass = $DomainJoinPass | ConvertTo-SecureString -AsPlainText -Force
if($templateparamfile)
{
    Try
    {
        Write-Verbose "Deploying Resources with parameters file $templateparamfile"
        $arm = New-AzureRmResourceGroupDeployment @deployparams -TemplateParameterFile $templateparamfile -Mode Incremental -ErrorAction Stop
        $status = $arm.ProvisioningState
    }
    Catch
    {
        $status = "Failed"
    }
  
}
Else
{ 
    Try
    {
        $arm = New-AzureRmResourceGroupDeployment @deployparams -adminpassword $pass -Mode Incremental -ErrorAction Stop
        $status = $arm.ProvisioningState
        
    }
    Catch
    {
        $status = "Failed"
    }
}

Return $status


