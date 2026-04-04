<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
/*
 *	MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

<#assign mobHurt = potioneffects?filter(effect -> hasProcedure(effect.onMobHurt))>
<#assign mobRemoved = potioneffects?filter(effect -> hasProcedure(effect.onMobRemoved))>
@Mod.EventBusSubscriber(modid = "${modid}") public class ${JavaModName}MobEffects {

	private static final List<Potion> REGISTRY = new ArrayList<>();

	<#list potioneffects as effect>
	public static final Potion ${effect.getModElement().getRegistryNameUpper()} =
			register("${effect.getModElement().getRegistryName()}", ${effect.getModElement().getName()}MobEffect::new);
	</#list>

    private static Potion register(String registryname, Supplier<Potion> effect) {
		Potion instance = effect.get().setRegistryName(registryname);
		REGISTRY.add(instance);
		return instance;
    }

	@SubscribeEvent public static void registerMobEffects(RegistryEvent.Register<Potion> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Potion[0]));
	}

	<#if mobHurt?size != 0>
	@SubscribeEvent public static void onMobHurt(LivingHurtEvent event) {
        <@javacompress>
        LivingEntity entity = event.getEntityLiving();
		<#list mobHurt as effect>
		if (entity.isPotionActive(${JavaModName}MobEffects.${effect.getModElement().getRegistryNameUpper()}.get())) {
			<@procedureCode effect.onMobHurt, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "entity.world",
				"entity": "entity",
				"amplifier": "entity.getActivePotionEffect(" + JavaModName + "MobEffects." + effect.getModElement().getRegistryNameUpper() + ".get()).getAmplifier()",
				"damagesource": "event.getSource()",
				"damage": "event.getAmount()"
			}/>
        }<#sep>else
        </#list>
        </@javacompress>
    }
	</#if>

	<#if mobRemoved?size != 0>
	@SubscribeEvent public static void onMobRemoved(LivingDeathEvent event) {
        <@javacompress>
        LivingEntity entity = event.getEntityLiving();
		<#list mobRemoved as effect>
		if (entity.isPotionActive(${JavaModName}MobEffects.${effect.getModElement().getRegistryNameUpper()}.get())) {
	        <@procedureCode effect.onMobRemoved, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "entity.world",
				"entity": "entity",
				"amplifier": "entity.getActivePotionEffect(" + JavaModName + "MobEffects." + effect.getModElement().getRegistryNameUpper() + ".get()).getAmplifier()"
			}/>
        }<#sep>else
        </#list>
        </@javacompress>
    }
	</#if>
}
<#-- @formatter:on -->
