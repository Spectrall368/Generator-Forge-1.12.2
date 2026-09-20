<#assign entity = generator.map(field$entity, "entities")!"null">
(<#if entity != "null" && entity != "EntityLightningBolt">new ${entity}(world)<#else>null</#if>)