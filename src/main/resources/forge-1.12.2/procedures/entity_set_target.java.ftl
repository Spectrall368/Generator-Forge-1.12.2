<#if input$sourceentity == "null">
if (${input$entity} instanceof EntityMob) ((EntityMob) ${input$entity}).setAttackTarget(null);
<#else>
if (${input$entity} instanceof EntityMob && ${input$sourceentity} instanceof EntityLivingBase) ((EntityMob) ${input$entity}).setAttackTarget((EntityLivingBase) ${input$sourceentity});
</#if>