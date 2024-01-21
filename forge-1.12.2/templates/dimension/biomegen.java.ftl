<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2020 Pylo and contributors
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
public static class GenLayerBiomesCustom extends GenLayer {

	private Biome[] allowedBiomes = {
    	<#list data.biomesInDimension as biome>
		Biome.REGISTRY.getObject(new ResourceLocation("${biome}")),
	</#list>
	};

	public GenLayerBiomesCustom(long seed) {
		super(seed);
	}

	@Override public int[] getInts(int x, int z, int width, int depth) {
		int[] dest = IntCache.getIntCache(width * depth);
		for (int dz = 0; dz < depth; dz++) {
			for (int dx = 0; dx < width; dx++) {
				this.initChunkSeed(dx + x, dz + z);
				dest[(dx + dz * width)] = Biome.getIdForBiome(this.allowedBiomes[nextInt(this.allowedBiomes.length)]);
			}
		}
		return dest;
	}
}

public static class BiomeProviderCustom extends BiomeProvider {

	private GenLayer genBiomes;
	private GenLayer biomeIndexLayer;
	private BiomeCache biomeCache;

	public BiomeProviderCustom() {
		this.biomeCache = new BiomeCache(this);
	}

	public BiomeProviderCustom(long seed) {
		this.biomeCache = new BiomeCache(this);
		GenLayer[] agenlayer = makeTheWorld(seed);
		this.genBiomes = agenlayer[0];
		this.biomeIndexLayer = agenlayer[1];
	}

	private GenLayer[] makeTheWorld(long seed) {
		GenLayer biomes = new GenLayerBiomesCustom(1);
		biomes = new GenLayerZoom(1000, biomes);
		biomes = new GenLayerZoom(1001, biomes);
		biomes = new GenLayerZoom(1002, biomes);
		biomes = new GenLayerZoom(1003, biomes);
		biomes = new GenLayerZoom(1004, biomes);
		biomes = new GenLayerZoom(1005, biomes);
		GenLayer genlayervoronoizoom = new GenLayerVoronoiZoom(10, biomes);
		biomes.initWorldGenSeed(seed);
		genlayervoronoizoom.initWorldGenSeed(seed);
		return new GenLayer[] { biomes, genlayervoronoizoom };
	}

	public BiomeProviderCustom(World world) {
		this(world.getSeed() - DIMID);
	}

	@Override public void cleanupCache() {
		this.biomeCache.cleanupCache();
	}

	@Override public Biome getBiome(BlockPos pos) {
		return this.getBiome(pos, null);
	}

	@Override public Biome getBiome(BlockPos pos, Biome defaultBiome) {
		return this.biomeCache.getBiome(pos.getX(), pos.getZ(), defaultBiome);
	}

	@Override public Biome[] getBiomes(Biome[] oldBiomeList, int x, int z, int width, int depth) {
		return this.getBiomes(oldBiomeList, x, z, width, depth, true);
	}

	@Override ${mcc.getMethod("net.minecraft.world.biome.BiomeProvider", "getBiomesForGeneration", "Biome[]", "int", "int", "int", "int")}

	@Override ${mcc.getMethod("net.minecraft.world.biome.BiomeProvider", "getBiomes", "Biome[]", "int", "int", "int", "int", "boolean")}

	@Override ${mcc.getMethod("net.minecraft.world.biome.BiomeProvider", "areBiomesViable", "int", "int", "int", "List")}

	@Override ${mcc.getMethod("net.minecraft.world.biome.BiomeProvider", "findBiomePosition", "int", "int", "int", "List", "Random")}
}
<#-- @formatter:on -->
