<#if input$sourceentity == "null">
if (${input$entity} instanceof EntityLiving) ((EntityLiving) ${input$entity}).setAttackTarget(null);
<#else>
if (${input$entity} instanceof EntityLiving && ${input$sourceentity} instanceof EntityLivingBase) ((EntityLiving) ${input$entity}).setAttackTarget((EntityLivingBase) ${input$sourceentity});
</#if>