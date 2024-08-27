[{
  "modid": "${settings.getModID()}",
  "name": "${settings.getModName()}",
<#if settings.getDescription()?has_content>
  "description": "${settings.getDescription()}",
</#if>
  "version": "${settings.getCleanVersion()}",
  "mcversion": "1.12.2",
<#if settings.getWebsiteURL()?has_content>
  "url": "${settings.getWebsiteURL()}",
</#if>
<#if settings.getUpdateURL()?has_content>
  "updateJSON": "${settings.getUpdateURL()}",
</#if>
<#if settings.getAuthor()?has_content>
  "authorList": ["${settings.getAuthor()}"],
</#if>
<#if settings.getCredits()?has_content>
  "credits": "${settings.getCredits()}",
</#if>
<#if settings.getModPicture()?has_content>
  "logoFile": "/logo.png",
</#if>

# Start of user code block mod configuration
# End of user code block mod configuration

  "requiredMods": [
<#list settings.getRequiredMods() as e>
      "${e}"<#if e?has_next>,</#if>
</#list>
  ],
  "dependencies": [
<#list settings.getDependencies() as e>
      "${e}",
</#list>
      "minecraft"
  ],
  "dependants": [
<#list settings.getDependants() as e>
      "${e}"<#if e?has_next>,</#if>
</#list>
  ],
  "useDependencyInformation": "true"

# Start of user code block dependencies configuration
# End of user code block dependencies configuration
}]
