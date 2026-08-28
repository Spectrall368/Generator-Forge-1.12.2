<#if input$shooter == "null">
new ${generator.map(field$projectile, "projectiles", 0)}(projectileLevel)
<#else>
<@addTemplate file="utils/projectiles/projectile_potion.java.ftl"/>
initPotionProperties(new ${generator.map(field$projectile, "projectiles", 0)}(projectileLevel), ${input$shooter}, Vec3d.ZERO)
</#if>