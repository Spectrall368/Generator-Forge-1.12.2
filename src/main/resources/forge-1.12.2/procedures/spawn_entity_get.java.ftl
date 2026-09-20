<@addTemplate file="utils/entity/spawn_entity_get.java.ftl"/>
<#include "mcelements.ftl">
<#assign entity = generator.map(field$entity, "entities")!"null">
<#if entity != "null" && entity != "EntityLightningBolt">
(world instanceof WorldServer ? spawnEntity(new ${entity}(world), ${toBlockPos(input$x,input$y,input$z)}, world) : null)
<#else>
null
</#if>