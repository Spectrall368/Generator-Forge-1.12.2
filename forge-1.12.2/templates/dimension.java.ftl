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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
package ${package}.world.dimension;

@Elements${JavaModName}.ModElement.Tag public class Dimension${name} extends Elements${JavaModName}.ModElement{

	public static int DIMID = ${generator.getStartIDFor("dimension") + data.getModElement().getID(1)};
	public static final boolean NETHER_TYPE = <#if data.worldGenType == "Nether like gen">true<#else>false</#if>;

	<#if data.enablePortal>
		@GameRegistry.ObjectHolder("${modid}:${registryname}_portal")
		public static final BlockCustomPortal portal = null;
	</#if>

	public static DimensionType dtype;

	public World${name} (Elements${JavaModName} instance) {
		super(instance, ${data.getModElement().getSortID()});
	}

	<#if data.enablePortal>
	@Override public void initElements() {
		elements.blocks.add(() -> new BlockCustomPortal());
		elements.items.add(() -> new ItemBlock(portal).setRegistryName(portal.getRegistryName()));
		elements.items.add(() -> new Item${name}().setUnlocalizedName("${registryname}").setRegistryName("${registryname}"));
	}
	</#if>

	@Override public void preInit(FMLPreInitializationEvent event) {
		if(DimensionManager.isDimensionRegistered(DIMID)) {
			DIMID = DimensionManager.getNextFreeDimId();
			System.err.println("Dimension ID for dimension ${registryname} is already registered. Falling back to ID: " + DIMID);
		}
		dtype = DimensionType.register("${registryname}","_${registryname}", DIMID, WorldProviderMod.class, true);
		DimensionManager.registerDimension(DIMID, dtype);
	}

	<#if data.enablePortal>
		@SideOnly(Side.CLIENT) @Override public void registerModels(ModelRegistryEvent event) {
			ModelLoader.setCustomModelResourceLocation(Item${name}.block, 0, new ModelResourceLocation("${modid}:${registryname}" ,"inventory"));
		}
	</#if>

	public static class WorldProviderMod extends WorldProvider {

		private BiomeProviderCustom biomeProviderCustom = null;

		@Override public void init() {
			this.biomeProvider = new BiomeProviderCustom(this.world.getSeed());
			this.nether = NETHER_TYPE;
			<#if data.hasSkyLight>
				this.hasSkyLight = true;
			</#if>
		}

		<#if !data.imitateOverworldBehaviour>
		@Override public void calculateInitialWeather() {
		}

    		@Override public void updateWeather() {
		}

		@Override public boolean canDoLightning(net.minecraft.world.chunk.Chunk chunk) {
			return false;
		}

		@Override public boolean canDoRainSnowIce(net.minecraft.world.chunk.Chunk chunk) {
			return false;
		}
        </#if>

		<#if data.dimensionMusic?? && data.dimensionMusic.toString()?has_content>
		@Override @SideOnly(Side.CLIENT) public net.minecraft.client.audio.MusicTicker.MusicType getMusicType() {
        	return EnumHelperClient.addMusicType("${data.dimensionMusic}", (net.minecraft.util.SoundEvent) net.minecraft.util.SoundEvent.REGISTRY
							.getObject(new ResourceLocation(("${data.dimensionMusic}"))), 6000, 24000);
    	}
        </#if>

		@Override public DimensionType getDimensionType() {
			return dtype;
		}

		@Override @SideOnly(Side.CLIENT) public Vec3d getFogColor(float celestialAngle, float partialTicks) {
			<#if data.airColor?has_content>
			return new Vec3d(${data.airColor.getRed()/255},${data.airColor.getGreen()/255},${data.airColor.getBlue()/255});
			<#else>
			float f = MathHelper.clamp(MathHelper.cos(celestialAngle * ((float)Math.PI * 2)) * 2 + 0.5f, 0, 1);
	      		float f1 = 0.7529412f;
	      		float f2 = 0.84705883f;
	      		float f3 = 1;
	      		f1 = f1 * (f * 0.94F + 0.06F);
	      		f2 = f2 * (f * 0.94F + 0.06F);
	      		f3 = f3 * (f * 0.91F + 0.09F);
	      		return new Vec3d(f1, f2, f3);
			</#if>
		}

		@Override public IChunkGenerator createChunkGenerator() {
			return new ChunkProviderModded(this.world, new BiomeProviderCustom(this.world));
			if(this.biomeProviderCustom == null) {
				this.biomeProviderCustom = new BiomeProviderCustom(this.world);
			}
			return new ChunkProviderModded(this.world, this.biomeProviderCustom);
		}

		@Override public boolean isSurfaceWorld() {
			return ${data.imitateOverworldBehaviour};
		}

		@Override public boolean canRespawnHere() {
			return ${data.canRespawnHere};
		}

		@SideOnly(Side.CLIENT) @Override public boolean doesXZShowFog(int par1, int par2) {
			return ${data.hasFog};
		}

		@Override public WorldSleepResult canSleepAt(EntityPlayer player, BlockPos pos){
        	return WorldSleepResult.${data.sleepResult};
		}

		<#if !data.isDark>
		@Override protected void generateLightBrightnessTable() {
			float f = 0.5f;
			for (int i = 0; i <= 15; ++i) {
				float f1 = 1 - (float) i / 15f;
				this.lightBrightnessTable[i] = (1 - f1) / (f1 * 3 + 1) * (1 - f) + f;
			}
		}
        	</#if>

		@Override public boolean doesWaterVaporize() {
      		return ${data.doesWaterVaporize};
   		}

        	<#if hasProcedure(data.onPlayerEntersDimension)>
		@Override public void onPlayerAdded(EntityPlayerMP entity) {
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			<@procedureOBJToCode data.onPlayerEntersDimension/>
		}
        	</#if>

        	<#if hasProcedure(data.onPlayerLeavesDimension)>
		@Override public void onPlayerRemoved(EntityPlayerMP entity) {
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			<@procedureOBJToCode data.onPlayerLeavesDimension/>
		}
        	</#if>
	}

	<#if data.enablePortal>
		<#include "dimension/teleporter.java.ftl">
		<#include "dimension/blockportal.java.ftl">
	</#if>

	<#if data.worldGenType == "Normal world gen">
        	<#include "dimension/cp_normal.java.ftl">
    	<#elseif data.worldGenType == "Nether like gen">
        	<#include "dimension/cp_nether.java.ftl">
    	<#elseif data.worldGenType == "End like gen">
        	<#include "dimension/cp_end.java.ftl">
    	</#if>

	<#include "dimension/biomegen.java.ftl">
}
<#-- @formatter:on -->
