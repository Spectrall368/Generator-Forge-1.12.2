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
<#include "../procedures.java.ftl">
package ${package}.world.dimension;

<@javacompress>
public class ${name}WorldProvider extends WorldProvider {
	@Override public void init() {
	    this.biomeProvider = new ${name}BiomeProvider(this.world.getSeed());
	    this.nether = <#if data.worldGenType == "Nether like gen">true<#else>false</#if>;
	    <#if data.hasSkyLight>this.hasSkyLight = true;</#if>
	}

	<#if data.coordinateScale != 1>
	@Override public double getMovementFactor() {
		return ${data.coordinateScale}f;
	}
	</#if>

	<#if !data.imitateOverworldBehaviour>
	@Override public void calculateInitialWeather() {}

	@Override public void updateWeather() {}

    @Override public boolean canDoLightning(Chunk chunk) {
		return false;
	}

	@Override public boolean canDoRainSnowIce(Chunk chunk) {
		return false;
	}
	</#if>

	<#if data.ambientLight != 0>
	@Override protected void generateLightBrightnessTable() {
		float f = ${data.ambientLight}f;
		for (int i = 0; i <= 15; ++i) {
			float f1 = 1 - (float) i / 15f;
			this.lightBrightnessTable[i] = (1 - f1) / (f1 * 3 + 1) * (1 - f) + f;
		}
	}
	</#if>

	<#if data.useCustomEffects>
		@Override @SideOnly(Side.CLIENT)
		<#if !data.airColor?has_content>
			<#if data.skyType == "NONE">
				${mcc.getMethod("net.minecraft.world.WorldProviderHell", "getFogColor", "float", "float")?keep_before_last(";")}
			<#elseif data.skyType != "NORMAL">
				${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "getFogColor", "float", "float")?keep_before_last(";")}
			</#if>
		<#else>
		public Vec3d getFogColor(float celestialAngle, float partialTicks) {
			return new Vec3d(${data.airColor.getRed()/255},${data.airColor.getGreen()/255},${data.airColor.getBlue()/255})
		</#if><#if data.sunHeightAffectsFog>.mul(celestialAngle * 0.94 + 0.06, celestialAngle * 0.94 + 0.06, celestialAngle * 0.91 + 0.09)</#if>;
		}

		@SideOnly(Side.CLIENT) @Override public boolean doesXZShowFog(int x, int z) {
			return ${data.hasFog};
		}

		@Override
		<#if !data.hasFixedTime>
			<#if data.skyType == "NONE">
				${mcc.getMethod("net.minecraft.world.WorldProviderHell", "calculateCelestialAngle", "long", "float")}
			<#elseif data.skyType != "NORMAL">
				${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "calculateCelestialAngle", "long", "float")}
			</#if>
		<#else>
		public float calculateCelestialAngle(long worldTime, float partialTicks) {
			return ${data.fixedTimeValue}f;
		}
		</#if>

		<#if !data.hasClouds || data.cloudHeight != 192>
		@Override @SideOnly(Side.CLIENT) public float getCloudHeight() {
			return <#if data.hasClouds>${data.cloudHeight}f<#else>Float.NaN</#if>;
		}
		</#if>

		<#if data.skyType == "END">
		@Nullable @SideOnly(Side.CLIENT) @Override ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "calcSunriseSunsetColors", "float", "float")}

		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "isSkyColored")}
		</#if>

	<#elseif data.defaultEffects == "the_nether">
		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderHell", "getFogColor", "float", "float")}

	   	@Override ${mcc.getMethod("net.minecraft.world.WorldProviderHell", "calculateCelestialAngle", "long", "float")}

		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderHell", "doesXZShowFog", "int", "int")}
	<#elseif data.defaultEffects != "overworld">
		@Override ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "calculateCelestialAngle", "long", "float")}

		@Nullable @SideOnly(Side.CLIENT) @Override ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "calcSunriseSunsetColors", "float", "float")}

		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "getFogColor", "float", "float")}

		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "isSkyColored")}

		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "getCloudHeight")}

		@Override @SideOnly(Side.CLIENT) ${mcc.getMethod("net.minecraft.world.WorldProviderEnd", "doesXZShowFog", "int", "int")}
	</#if>

    <#if data.imitateOverworldBehaviour && data.hasSkyLight>
	@Override public boolean shouldClientCheckLighting() {
		return true;
	}
	</#if>

	@Override public IChunkGenerator createChunkGenerator() {
		return new ${name}ChunkProvider(this.world, this.world.getSeed() - ${JavaModName}Dimensions.${REGISTRYNAME}.getId());
	}

	@Override public boolean isSurfaceWorld() {
		return ${data.imitateOverworldBehaviour};
	}

	@Override public boolean canRespawnHere() {
		return ${data.canRespawnHere};
	}

	@Override public WorldSleepResult canSleepAt(EntityPlayer player, BlockPos pos) {
       	return WorldSleepResult.<#if data.bedWorks>ALLOW<#else>BED_EXPLODES</#if>;
	}

	@Override public boolean canCoordinateBeSpawn(int x, int z) {
       	return false;
	}

	@Override public boolean doesWaterVaporize() {
        return ${data.doesWaterVaporize};
   	}

	@Override public DimensionType getDimensionType() {
        return ${JavaModName}Dimensions.${REGISTRYNAME};
   	}

	<#if hasProcedure(data.onPlayerLeavesDimension)>
	@Override public void onPlayerAdded(EntityPlayerMP entity) {
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		<@procedureOBJToCode data.onPlayerEntersDimension/>
	}
	</#if>

	<#if hasProcedure(data.onPlayerEntersDimension)>
	@Override public void onPlayerRemoved(EntityPlayerMP entity) {
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		<@procedureOBJToCode data.onPlayerLeavesDimension/>
	}
	</#if>

	<#if data.worldGenType == "Normal world gen">
	        <#include "cp_normal.java.ftl">
    	<#elseif data.worldGenType == "Nether like gen">
	        <#include "cp_nether.java.ftl">
    	<#else>
	        <#include "cp_end.java.ftl">
    	</#if>

	<#include "biomegen.java.ftl">
}
</@javacompress>
<#-- @formatter:on -->