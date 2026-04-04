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
<#include "../mcitems.ftl">
package ${package}.world.biome;
<#assign isInline = (data.vanillaTreeType != "Big trees") && (data.vanillaTreeType != "Default" && data.treeType != data.TREES_CUSTOM)>

public class ${name}Biome extends Biome {
	<#if (data.treesPerChunk > 0) && (isInline || data.treeType == data.TREES_CUSTOM)>
	private static final WorldGenAbstractTree TREE = new
	    <#if data.treeType == data.TREES_CUSTOM>
	        ${name}TreeFeature(
	    <#elseif data.vanillaTreeType == "Savanna trees">
	        WorldGenSavannaTree(false
	    <#elseif data.vanillaTreeType == "Mega pine trees">
	        WorldGenMegaPineTree(false, false
	    <#elseif data.vanillaTreeType == "Mega spruce trees">
	        WorldGenMegaPineTree(false, true
	    <#elseif data.vanillaTreeType == "Birch trees">
	        WorldGenBirchTree(false, true
	    </#if>);
	</#if>

	<#if data.spawnBiome>
	public static void init() {
	BiomeManager.addSpawnBiome(${JavaModName}Biomes.${REGISTRYNAME});
		BiomeManager.addBiome(BiomeManager.BiomeType.
		<#if (data.temperature < -0.25)>
		ICY
		<#elseif (data.temperature > -0.25) && (data.temperature <= 0.15)>
		COOL
		<#elseif (data.temperature > 0.15) && (data.temperature <= 1.0)>
		WARM
		<#elseif (data.temperature > 1.0)>
		DESERT
		</#if>, new BiomeManager.BiomeEntry(${JavaModName}Biomes.${REGISTRYNAME}, ${data.biomeWeight}));

	}
	</#if>

	public ${name}Biome() {
		super(new Biome.BiomeProperties("${name}")
			.setRainfall(${data.rainingPossibility}f)
			.setBaseHeight(${data.baseHeight}f)
			.setHeightVariation(${data.heightVariation}f)
			.setTemperature(${data.temperature}f)
            <#if (data.rainingPossibility > 0) && (data.temperature <= 0.15)>
                .setSnowEnabled()
            <#else>
                .setRainDisabled()
            </#if>
			.setWaterColor(${data.waterColor?has_content?then(data.waterColor.getRGB(), 4159204)}));

            topBlock = ${mappedBlockToBlockStateCode(data.groundBlock)};
            fillerBlock = ${mappedBlockToBlockStateCode(data.undergroundBlock)};

            decorator.flowersPerChunk = 0;
            decorator.grassPerChunk = 0;
            decorator.gravelPatchesPerChunk = 0;
            decorator.sandPatchesPerChunk = 0;
            decorator.clayPerChunk = 0;
            <#if (data.treesPerChunk > 0)>
            decorator.treesPerChunk = ${data.treesPerChunk};
            <#else>
            decorator.extraTreeChance = 0;
            </#if>

        	<#list data.defaultFeatures as defaultFeature>
        	<#assign mfeat = generator.map(defaultFeature, "defaultfeatures")>
        		<#if mfeat != "null">
                    ${mfeat}
                </#if>
            </#list>

            <#if data.spawnStronghold>
            BiomeManager.addStrongholdBiome(this);
            </#if>

            <#if data.villageType != "none">
            BiomeManager.addVillageBiome(this, true);
            </#if>

            <#if data.spawnWoodlandMansion>
            ArrayList<Biome> mansionBiomes = new ArrayList<>(WoodlandMansion.ALLOWED_BIOMES);
            mansionBiomes.add(this);
            WoodlandMansion.ALLOWED_BIOMES = mansionBiomes;
            </#if>

            <#if data.spawnJungleTemple>
            ArrayList<Biome> jungleBiomes = new ArrayList<>(MapGenScatteredFeature.BIOMELIST);
            jungleBiomes.add(this);
            MapGenScatteredFeature.BIOMELIST = jungleBiomes;
            </#if>

            spawnableMonsterList.clear();
            spawnableCreatureList.clear();
            spawnableWaterCreatureList.clear();
            spawnableCaveCreatureList.clear();

            <#list data.spawnEntries as spawnEntry>
                <#assign entity = spawnEntry.entity.getMappedValue(1)!"null">
                <#if entity != "null">
                    <#if generator.map(spawnEntry.spawnType, "mobspawntypes") == "EnumCreatureType.MONSTER">
                        this.spawnableMonsterList.add(new SpawnListEntry(${entity}.class, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
                    <#elseif generator.map(spawnEntry.spawnType, "mobspawntypes") == "EnumCreatureType.CREATURE">
                        this.spawnableCreatureList.add(new SpawnListEntry(${entity}.class, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
                    <#elseif generator.map(spawnEntry.spawnType, "mobspawntypes") == "EnumCreatureType.AMBIENT">
                        this.spawnableCaveCreatureList.add(new SpawnListEntry(${entity}.class, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
                    <#else>
                        this.spawnableWaterCreatureList.add(new SpawnListEntry(${entity}.class, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
                    </#if>
                </#if>
            </#list>
	}

	<#if (data.treesPerChunk > 0)>
	@Override public WorldGenAbstractTree getRandomTreeFeature(Random rand) {
		return <#if (isInline || data.treeType == data.TREES_CUSTOM)>TREE<#elseif data.vanillaTreeType == "Big trees">BIG_TREE_FEATURE<#else>super.getRandomTreeFeature(rand)</#if>;
	}
    </#if>

	@SideOnly(Side.CLIENT) @Override public int getGrassColorAtPos(BlockPos pos) {
		return ${data.grassColor?has_content?then(data.grassColor.getRGB(), 9470285)};
	}

	@SideOnly(Side.CLIENT) @Override public int getFoliageColorAtPos(BlockPos pos) {
		return ${data.foliageColor?has_content?then(data.foliageColor.getRGB(), 10387789)};
	}

	@SideOnly(Side.CLIENT) @Override public int getSkyColorByTemp(float currentTemperature) {
		return ${data.airColor?has_content?then(data.airColor.getRGB(), 7972607)};
	}
}
<#-- @formatter:on -->
