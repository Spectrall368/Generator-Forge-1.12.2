<@addTemplate file="utils/projectiles/arrow.java.ftl"/>
<#if (input$knockback == "/*@int*/0") && (input$piercing == "/*@int*/0")>
	initArrowProjectile(new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, projectileLevel),
		${input$shooter}, ${opt.toFloat(input$damage)}, ${field$projectile?starts_with("CUSTOM:")}, ${field$fire == "TRUE"}, ${field$particles == "TRUE"},
		EntityArrow.PickupStatus.${field$pickup})
<#elseif field$projectile?starts_with("CUSTOM:")>
	<@addTemplate file="utils/projectiles/arrow_weapon.java.ftl"/>
	initArrowProjectile(createArrowWeaponItemStack(new ${generator.map(field$projectile, "projectiles", 0)}(${generator.map(field$projectile, "projectiles", 1)}, 0, 0, 0, projectileLevel),
		${opt.toInt(input$knockback)}, (byte) ${input$piercing}), ${input$shooter}, ${opt.toFloat(input$damage)},
		true, ${field$fire == "TRUE"}, ${field$particles == "TRUE"}, EntityArrow.PickupStatus.${field$pickup})
<#else>
	<@addTemplate file="utils/projectiles/arrow_weapon.java.ftl"/>
	initArrowProjectile(createArrowWeaponItemStack(new ${generator.map(field$projectile, "projectiles", 0)}(projectileLevel, 0, 0, 0),
		${opt.toInt(input$knockback)}, (byte) ${input$piercing}), ${input$shooter}, ${opt.toFloat(input$damage)},
		false, ${field$fire == "TRUE"}, ${field$particles == "TRUE"}, EntityArrow.PickupStatus.${field$pickup})
</#if>