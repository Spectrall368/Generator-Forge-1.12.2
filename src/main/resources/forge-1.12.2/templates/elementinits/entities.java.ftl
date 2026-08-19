<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign hasLivingEntities = w.hasElementsOfType("livingentity")>

@Mod.EventBusSubscriber(modid = "${modid}")
public class ${JavaModName}Entities {
	private static final List<EntityEntry> REGISTRY = new ArrayList<>();

	<#list entities as entity>
		<#if entity.getModElement().getTypeString() == "projectile">
			public static final EntityEntry ${entity.getModElement().getRegistryNameUpper()} =
				register("${entity.getModElement().getRegistryName()}", EntityEntryBuilder.
						create().entity(${entity.getModElement().getName()}Entity.class).factory(${entity.getModElement().getName()}Entity::new)
						.tracker(64, 1, true));
		<#elseif entity.getModElement().getTypeString() == "livingentity">
			public static final EntityEntry ${entity.getModElement().getRegistryNameUpper()} =
				register("${entity.getModElement().getRegistryName()}", EntityEntryBuilder.
						create().entity(${entity.getModElement().getName()}Entity.class)
							.tracker(${entity.trackingRange}, 3, true)
							.factory(${entity.getModElement().getName()}Entity::new)
							<#if entity.hasSpawnEgg>.egg(${entity.spawnEggBaseColor.getRGB()}, ${entity.spawnEggDotColor.getRGB()})</#if>
						);
			<#if entity.hasCustomProjectile()>
			public static final EntityEntry ${entity.getModElement().getRegistryNameUpper()}_PROJECTILE =
				register("projectile_${entity.getModElement().getRegistryName()}", EntityEntryBuilder.
					create().entity(${entity.getModElement().getName()}EntityProjectile.class).tracker(64, 1, true)
						.factory(${entity.getModElement().getName()}EntityProjectile::new));
			</#if>
		</#if>
	</#list>

	// Start of user code block custom entities
	// End of user code block custom entities

	private static <T extends Entity> EntityEntry register(String registryname, EntityEntryBuilder<T> entityTypeBuilder) {
	    EntityEntry entry = entityTypeBuilder.build().setRegistryName(registryname);
		REGISTRY.add(entry);
    	return entry;
    }

	@SubscribeEvent public static void registerEntities(RegistryEvent.Register<EntityEntry> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new EntityEntry[0]));
	}

	<#if hasLivingEntities>
	public static void init() {
		<#list entities as entity>
			<#if entity.getModElement().getTypeString() == "livingentity">
				${entity.getModElement().getName()}Entity.init();
			</#if>
		</#list>
	}
	</#if>
}
<#-- @formatter:on -->