<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
<#include "mcitems.ftl">
package ${package}.world.biome;

@Elements${JavaModName}.ModElement.Tag public class Biome${name} extends Elements${JavaModName}.ModElement {

	@GameRegistry.ObjectHolder("${modid}:${registryname}")
	public static final BiomeGenCustom biome = null;

	public Biome${name} (Elements${JavaModName} instance) {
		super(instance, ${data.getModElement().getSortID()});
	}

	@Override public void initElements() {
		elements.biomes.add(() -> new BiomeGenCustom());
	}

	@Override public void init(FMLInitializationEvent event) {
		<#if data.biomeDictionaryTypes?has_content>
			BiomeDictionary.addTypes(biome,
			<#list data.biomeDictionaryTypes as biomeDictionaryType>
				BiomeDictionary.Type.${generator.map(biomeDictionaryType, "biomedictionarytypes")}<#if biomeDictionaryType?has_next>,</#if>
			</#list>
			);
		</#if>
		<#if data.spawnBiome>
		BiomeManager.addSpawnBiome(biome);
		BiomeManager.addBiome(BiomeManager.BiomeType.${data.biomeType}, new BiomeManager.BiomeEntry(biome, ${data.biomeWeight}));
        </#if>
	}

	static class BiomeGenCustom extends Biome {

		public BiomeGenCustom() {
			super(new Biome.BiomeProperties("${data.name!registryname}")
			.setRainfall(${data.rainingPossibility}f)
			.setBaseHeight(${data.baseHeight}f)
			.setHeightVariation(${data.heightVariation}f)
			.setTemperature(${data.temperature}f)
			<#if (data.rainingPossibility > 0) && (data.temperature > 0.15)><#else>
			.setRainDisabled()
			.setSnowEnabled()
			</#if>
			.setWaterColor(${data.waterColor?hascontent?then(data.waterColor.getRGB(), 4159204)}));
			setRegistryName("${registryname}");
			topBlock = ${mappedBlockToBlockStateCode(data.groundBlock)};
			fillerBlock = ${mappedBlockToBlockStateCode(data.undergroundBlock)};
			decorator.treesPerChunk = ${data.treesPerChunk};
			decorator.flowersPerChunk = ${data.flowersPerChunk};
			decorator.grassPerChunk = ${data.grassPerChunk};
			decorator.mushroomsPerChunk = ${data.mushroomsPerChunk};
			decorator.bigMushroomsPerChunk = ${data.bigMushroomsChunk};
			decorator.reedsPerChunk = ${data.reedsPerChunk};
			decorator.cactiPerChunk = ${data.cactiPerChunk};
			decorator.sandPatchesPerChunk = ${data.sandPatchesPerChunk};
			decorator.gravelPatchesPerChunk = ${data.gravelPatchesPerChunk};

			this.spawnableMonsterList.clear();
			this.spawnableCreatureList.clear();
			this.spawnableWaterCreatureList.clear();
			this.spawnableCaveCreatureList.clear();

		<#list data.spawnEntries as spawnEntry>
			<#assign entity = generator.map(spawnEntry.entity.getUnmappedValue(), "entities", 1)!"null">
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

		@SideOnly(Side.CLIENT) @Override public int getGrassColorAtPos(BlockPos pos) {
			return ${data.grassColor?has_content?then(data.grassColor.getRGB(), 9470285)};
		}

	        @SideOnly(Side.CLIENT) @Override public int getFoliageColorAtPos(BlockPos pos) {
	        	return ${data.foliageColor?has_content?then(data.foliageColor.getRGB(), 10387789)};
	       	 }

		@SideOnly(Side.CLIENT) @Override public int getSkyColorByTemp(float currentTemperature) {
			return ${data.airColor?has_content?then(data.airColor.getRGB(), 7972607)};
		}

		@Override public WorldGenAbstractTree getRandomTreeFeature(Random rand) {
		<#if data.treeType == data.TREES_CUSTOM>
			return new CustomTree();
            	<#elseif data.vanillaTreeType == "Big trees">
			return BIG_TREE_FEATURE;
            	<#elseif data.vanillaTreeType == "Savanna trees">
			return new WorldGenSavannaTree(false);
            	<#elseif data.vanillaTreeType == "Mega pine trees">
			return new WorldGenMegaPineTree(false, false);
            	<#elseif data.vanillaTreeType == "Mega spruce trees">
			return new WorldGenMegaPineTree(false, true);
            	<#elseif data.vanillaTreeType == "Birch trees">
			return new WorldGenBirchTree(true, true);
            	<#else>
			return super.getRandomTreeFeature(rand);
            	</#if>
		}

	}

	<#if data.treeType == data.TREES_CUSTOM>
	static class CustomTree extends WorldGenAbstractTree {

		CustomTree() {
			super(false);
		}

		@Override public boolean generate(World world, Random rand, BlockPos position) {
			int height = rand.nextInt(5) + ${data.minHeight};
			boolean spawnTree = true;

			if (position.getY() >= 1 && position.getY() + height + 1 <= world.getHeight()) {
				for (int j = position.getY(); j <= position.getY() + 1 + height; j++) {
					int k = 1;

					if (j == position.getY())
						k = 0;

					if (j >= position.getY() + height - 1)
						k = 2;

					for (int px = position.getX() - k; px <= position.getX() + k && spawnTree; px++) {
						for (int pz = position.getZ() - k; pz <= position.getZ() + k && spawnTree; pz++) {
							if (j >= 0 && j < world.getHeight()) {
								if (!this.isReplaceable(world, new BlockPos(px, j, pz))) {
									spawnTree = false;
								}
							} else {
								spawnTree = false;
							}
						}
					}
				}
				if (!spawnTree) {
					return false;
				} else {
					Block ground = world.getBlockState(position.add(0, -1, 0)).getBlock();
					Block ground2 = world.getBlockState(position.add(0, -2, 0)).getBlock();
					if (!((ground == ${mappedBlockToBlock(data.groundBlock)}
						|| ground == ${mappedBlockToBlock(data.undergroundBlock)})
						&& (ground2 == ${mappedBlockToBlock(data.groundBlock)}
						|| ground2 == ${mappedBlockToBlock(data.undergroundBlock)})))
						return false;

					IBlockState state = world.getBlockState(position.down());
					if (position.getY() < world.getHeight() - height - 1) {
						world.setBlockState(position.down(), ${mappedBlockToBlockStateCode(data.undergroundBlock)}, 2);

						for (int genh = position.getY() - 3 + height; genh <= position.getY() + height; genh++) {
							int i4 = genh - (position.getY() + height);
							int j1 = (int) (1 - i4 * 0.5);

							for (int k1 = position.getX() - j1; k1 <= position.getX() + j1; ++k1) {
								for (int i2 = position.getZ() - j1; i2 <= position.getZ() + j1; ++i2) {
									int j2 = i2 - position.getZ();

									if (Math.abs(position.getX()) != j1 || Math.abs(j2) != j1 || rand.nextInt(2) != 0 && i4 != 0) {
										BlockPos blockpos = new BlockPos(k1, genh, i2);
										state = world.getBlockState(blockpos);

										if (state.getBlock().isAir(state, world, blockpos)
												|| state.getBlock().isLeaves(state, world, blockpos)
												|| state.getBlock() == <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlock(data.treeVines)}<#else> Blocks.AIR</#if>
												|| state.getBlock() == ${mappedBlockToBlock(data.treeBranch)}) {
											this.setBlockAndNotifyAdequately(world, blockpos, ${mappedBlockToBlockStateCode(data.treeBranch)});
										}
									}
								}
							}
						}

						for (int genh = 0; genh < height; genh++) {
							BlockPos genhPos = position.up(genh);
							state = world.getBlockState(genhPos);

							this.setBlockAndNotifyAdequately(world, position.up(genh), ${mappedBlockToBlockStateCode(data.treeStem)});

							if (state.getBlock().isAir(state, world, genhPos)
								|| state.getBlock() == <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlock(data.treeVines)}<#else> Blocks.AIR</#if>
								|| state.getBlock() == ${mappedBlockToBlock(data.treeBranch)}) {

								<#if (data.treeVines?has_content && !data.treeVines.isEmpty())>
								if (genh > 0) {
									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(-1, genh, 0)))
										this.setBlockAndNotifyAdequately(world, position.add(-1, genh, 0), ${mappedBlockToBlockStateCode(data.treeVines)});

									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(1, genh, 0)))
										this.setBlockAndNotifyAdequately(world, position.add(1, genh, 0), ${mappedBlockToBlockStateCode(data.treeVines)});

									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(0, genh, -1)))
										this.setBlockAndNotifyAdequately(world, position.add(0, genh, -1), ${mappedBlockToBlockStateCode(data.treeVines)});

									if (rand.nextInt(3) > 0 && world.isAirBlock(position.add(0, genh, 1)))
										this.setBlockAndNotifyAdequately(world, position.add(0, genh, 1), ${mappedBlockToBlockStateCode(data.treeVines)});
								}
                               					</#if>
							}
						}

						<#if (data.treeVines?has_content && !data.treeVines.isEmpty())>
							for (int genh = position.getY() - 3 + height; genh <= position.getY() + height; genh++) {
								int k4 = (int) (1 - (genh - (position.getY() + height)) * 0.5);
								for (int genx = position.getX() - k4; genx <= position.getX() + k4; genx++) {
									for (int genz = position.getZ() - k4; genz <= position.getZ() + k4; genz++) {
										BlockPos bpos = new BlockPos(genx, genh, genz);
										state = world.getBlockState(bpos);
										if (state.getBlock().isLeaves(state, world, bpos)
											|| state.getBlock() == ${mappedBlockToBlock(data.treeBranch)}) {
											BlockPos blockpos1 = bpos.south();
											BlockPos blockpos2 = bpos.west();
											BlockPos blockpos3 = bpos.east();
											BlockPos blockpos4 = bpos.north();

											if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos2))
												this.addVines(world, blockpos2);

											if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos3))
												this.addVines(world, blockpos3);

											if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos4))
												this.addVines(world, blockpos4);

											if (rand.nextInt(4) == 0 && world.isAirBlock(blockpos1))
												this.addVines(world, blockpos1);
										}
									}
								}
							}
                        </#if>

						<#if (data.treeFruits?has_content && !data.treeFruits.isEmpty())>
						if (rand.nextInt(4) == 0 && height > 5) {
							for (int hlevel = 0; hlevel < 2; hlevel++) {
								for (EnumFacing enumfacing : EnumFacing.Plane.HORIZONTAL) {
									if (rand.nextInt(4 - hlevel) == 0) {
										EnumFacing enumfacing1 = enumfacing.getOpposite();
										this.setBlockAndNotifyAdequately(world, position.add(enumfacing1.getFrontOffsetX(), height - 5 + hlevel, enumfacing1.getFrontOffsetZ()), ${mappedBlockToBlockStateCode(data.treeFruits)});
									}
								}
							}
						}
						</#if>

						return true;
					} else {
						return false;
					}
				}
			} else {
				return false;
			}
		}

		private void addVines(World world, BlockPos pos) {
			this.setBlockAndNotifyAdequately(world, pos, <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlockStateCode(data.treeVines)}<#else> Blocks.AIR.getDefaultState()</#if>);
			int i = 5;
			for (BlockPos blockpos = pos.down(); world.isAirBlock(blockpos) && i > 0; --i) {
				this.setBlockAndNotifyAdequately(world, blockpos, <#if (data.treeVines?has_content && !data.treeVines.isEmpty())> ${mappedBlockToBlockStateCode(data.treeVines)}<#else> Blocks.AIR.getDefaultState()</#if>);
				blockpos = blockpos.down();
			}
		}

		@Override protected boolean canGrowInto(Block blockType) {
        	return blockType.getDefaultState().getMaterial() == Material.AIR ||
				blockType == ${mappedBlockToBlock(data.treeStem)} ||
				blockType == ${mappedBlockToBlock(data.treeBranch)} ||
				blockType == ${mappedBlockToBlock(data.groundBlock)} ||
				blockType == ${mappedBlockToBlock(data.undergroundBlock)};
		}

		@Override protected void setDirtAt(World world, BlockPos pos) {
			if (world.getBlockState(pos).getBlock() != ${mappedBlockToBlock(data.undergroundBlock)})
            			this.setBlockAndNotifyAdequately(world, pos, ${mappedBlockToBlockStateCode(data.undergroundBlock)});
		}

		@Override public boolean isReplaceable(World world, BlockPos pos) {
			net.minecraft.block.state.IBlockState state = world.getBlockState(pos);
        		return state.getBlock().isAir(state, world, pos) || canGrowInto(state.getBlock()) || state.getBlock().isReplaceable(world, pos);
		}
	}
    </#if>
}
<#-- @formatter:on -->
