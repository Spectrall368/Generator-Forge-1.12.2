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
<#assign spawn_overworld = biomes?filter(biome -> biome.spawnBiome)>
@Mod.EventBusSubscriber(modid = "${modid}") public class ${JavaModName}Biomes {
    private static final List<Biome> REGISTRY = new ArrayList<>();

    <#list biomes as biome>
    public static final Biome ${biome.getModElement().getRegistryNameUpper()}
        = register("${biome.getModElement().getRegistryName()}", ${biome.getModElement().getName()}Biome::new);
    </#list>

    private static Biome register(String registryname, Supplier<Biome> biome) {
		Biome instance = biome.get().setRegistryName(registryname);
		REGISTRY.add(instance);
		return instance;
    }

	@SubscribeEvent public static void registerBiomes(RegistryEvent.Register<Biome> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Biome[0]));
	}

    <#if spawn_overworld?has_content>
    public static void load() {
    	<#list spawn_overworld as biome>
    		${biome.getModElement().getName()}Biome.init();
    	</#list>
    }
    </#if>
}
<#-- @formatter:on -->