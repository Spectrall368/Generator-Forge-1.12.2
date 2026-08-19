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
<#include "../mcitems.ftl">
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

@Mod.EventBusSubscriber public class ${JavaModName}VillagerProfessions {
    private static final List<VillagerRegistry.VillagerProfession> REGISTRY = new ArrayList<>();

	<#list villagerprofessions as villagerprofession>
		public static final VillagerRegistry.VillagerProfession ${villagerprofession.getModElement().getRegistryNameUpper()} = register(new VillagerRegistry.VillagerProfession(
		    "${modid}:${villagerprofession.getModElement().getRegistryName()}",
		    "${modid}:textures/entities/${villagerprofession.professionTextureFile}",
		    "${modid}:textures/entities/${villagerprofession.zombifiedProfessionTextureFile}"));
		public static final VillagerRegistry.VillagerCareer ${villagerprofession.getModElement().getRegistryNameUpper()}_CAREER = new VillagerRegistry.VillagerCareer(${villagerprofession.getModElement().getRegistryNameUpper()}, "${modid}.${villagerprofession.getModElement().getRegistryName()}");
	</#list>

	private static VillagerRegistry.VillagerProfession register(VillagerRegistry.VillagerProfession profession) {
		REGISTRY.add(profession);
		return profession;
	}

	@SubscribeEvent public static void registerVillagerProfessions(RegistryEvent.Register<VillagerRegistry.VillagerProfession> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new VillagerRegistry.VillagerProfession[0]));
	}
}
<#-- @formatter:on -->
