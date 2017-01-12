Import-Module ActiveDirectory

<#
.SYNOPSIS
    Function to set User Location by OU
.PARAMETER Domain
	Specifies the Domain that will be processed
.PARAMETER resolver
    Specifies the DNS resolver to perform the lookup
.EXAMPLE
    Validate-SPF -domain "google.com"
.EXAMPLE
    Validate-SPF -domain "google.com" -resolver "8.8.8.8"

#>