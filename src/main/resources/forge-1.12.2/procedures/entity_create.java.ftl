<#assign entity = generator.map(field$entity, "entities", 0)!"null">
(<#if entity != "null">new ${generator.map(field$entity, "entities", 0)}(world)<#else>null</#if>)