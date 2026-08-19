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
<#include "../mcitems.ftl">
package ${package}.block;

public class ${name}PortalBlock extends BlockPortal {

	public ${name}PortalBlock() {
	    setHardness(-1.0F);
		setSoundType(SoundType.GLASS);
		setLightLevel(${data.portalLuminance});

		setUnlocalizedName("${modid}.${registryname}_portal");
	}

	@Override public void randomTick(World world, BlockPos pos, IBlockState blockstate, Random random) {
		<#-- Do not call super to prevent ZOMBIFIED_PIGLINs from spawning -->
		<#if hasProcedure(data.onPortalTickUpdate)>
			<@procedureCode data.onPortalTickUpdate, {
				"x": "pos.getX()",
				"y": "pos.getY()",
				"z": "pos.getZ()",
				"world": "world",
				"blockstate": "blockstate"
			}/>
		</#if>
	}

	public void portalSpawn(World world, BlockPos pos) {
		${name}PortalBlock.Size portalsize = new ${name}PortalBlock.Size(world, pos, EnumFacing.Axis.X);

		if (portalsize.isValid() && portalsize.portalBlockCount == 0) {
			portalsize.placePortalBlocks();
		} else {
			portalsize = new ${name}PortalBlock.Size(world, pos, EnumFacing.Axis.Z);
			if (portalsize.isValid() && portalsize.portalBlockCount == 0)
				portalsize.placePortalBlocks();
		}
	}

	@Override ${mcc.getMethod("net.minecraft.block.BlockPortal", "createPatternHelper", "World", "BlockPos")
	               .replace("BlockPortal.", name + "PortalBlock.")}

	@Override ${mcc.getMethod("net.minecraft.block.BlockPortal", "neighborChanged", "IBlockState", "World", "BlockPos", "Block", "BlockPos")
				   .replace("BlockPortal.", name + "PortalBlock.")}

	@SideOnly(Side.CLIENT) @Override public void randomDisplayTick(IBlockState state, World world, BlockPos pos, Random random) {
		for (int i = 0; i < 4; i++) {
			double px = pos.getX() + random.nextFloat();
			double py = pos.getY() + random.nextFloat();
			double pz = pos.getZ() + random.nextFloat();
			double vx = (random.nextFloat() - 0.5) / 2f;
			double vy = (random.nextFloat() - 0.5) / 2f;
			double vz = (random.nextFloat() - 0.5) / 2f;
			int j = random.nextInt(4) - 1;
			if (world.getBlockState(pos.west()).getBlock() != this
					&& world.getBlockState(pos.east()).getBlock() != this) {
				px = pos.getX() + 0.5 + 0.25 * j;
				vx = random.nextFloat() * 2 * j;
			} else {
				pz = pos.getZ() + 0.5 + 0.25 * j;
				vz = random.nextFloat() * 2 * j;
			}
			world.spawnParticle(${data.portalParticles}, px, py, pz, vx, vy, vz);
		}

		<#if data.portalSound.toString()?has_content>
		if (random.nextInt(110) == 0)
			world.playSound(pos.getX() + 0.5, pos.getY() + 0.5, pos.getZ() + 0.5, ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.portalSound}")), SoundCategory.BLOCKS, 0.5f, random.nextFloat() * 0.4f + 0.8f, false);
        	</#if>
	}

	@Override public void onEntityCollidedWithBlock(World world, BlockPos pos, IBlockState state, Entity entity) {
		if (!world.isRemote && <#if hasProcedure(data.portalUseCondition)><@procedureCode data.portalUseCondition, {
        		"x": "pos.getX()",
        		"y": "pos.getY()",
        		"z": "pos.getZ()",
        		"entity": "entity",
        		"world": "world"
        		}, false/> && </#if>!entity.isRiding() && !entity.isBeingRidden() && entity.isNonBoss()) {

			if (entity.timeUntilPortal > 0) {
				entity.timeUntilPortal = entity.getPortalCooldown();
			} else if (entity.dimension != ${JavaModName}Dimensions.${REGISTRYNAME}.getId()) {
				entity.timeUntilPortal = entity.getPortalCooldown();
				teleportToDimension(entity, ${JavaModName}Dimensions.${REGISTRYNAME}.getId());
			} else {
				entity.timeUntilPortal = entity.getPortalCooldown();
				teleportToDimension(entity, 0);
			}
		}
	}

	private void teleportToDimension(Entity entity, int destinationType) {
		if (entity instanceof EntityPlayerMP) {
            EntityPlayerMP player = (EntityPlayerMP) entity;

            ObfuscationReflectionHelper.setPrivateValue(EntityPlayerMP.class, player, true, "field_184851_cj");
            WorldServer nextWorld = player.getServer().getWorld(destinationType);
            player.mcServer.getPlayerList().transferPlayerToDimension(player, destinationType, getTeleporterForDimension(player, player.getPosition(), player.getServer().getWorld(destinationType)));
            player.connection.sendPacket(new SPacketEffect(1032, BlockPos.ORIGIN, 0, false));
		} else {
            MinecraftServer server = entity.world.getMinecraftServer();
            WorldServer fromWorld = server.getWorld(entity.dimension);
            WorldServer toWorld = server.getWorld(destinationType);
            server.getPlayerList().transferEntityToWorld(entity, entity.dimension, fromWorld, toWorld, getTeleporterForDimension(entity, entity.getPosition(), toWorld));
		}
	}

	private ${name}Teleporter getTeleporterForDimension(Entity entity, BlockPos pos, WorldServer nextWorld) {
		BlockPattern.PatternHelper bph = ${JavaModName}Blocks.${REGISTRYNAME}_PORTAL.createPatternHelper(entity.world, pos);
		double d0 = bph.getForwards().getAxis() == EnumFacing.Axis.X ? (double) bph.getFrontTopLeft().getZ() : (double) bph.getFrontTopLeft().getX();
		double d1 = bph.getForwards().getAxis() == EnumFacing.Axis.X ? entity.posZ : entity.posX;
		d1 = Math.abs(MathHelper.pct(d1 - (double) (bph.getForwards().rotateY().getAxisDirection() == EnumFacing.AxisDirection.NEGATIVE ? 1 : 0), d0, d0 - (double) bph.getWidth()));
		double d2 = MathHelper.pct(entity.posY - 1, (double) bph.getFrontTopLeft().getY(), (double) (bph.getFrontTopLeft().getY() - bph.getHeight()));
		return new ${name}Teleporter(nextWorld, new Vec3d(d1, d2, 0), bph.getForwards());
	}

	public static class Size ${mcc.getInnerClassBody("net.minecraft.block.BlockPortal", "Size")
					.replace("Blocks.OBSIDIAN", mappedBlockToBlock(data.portalFrame)?string)
					.replace("Blocks.PORTAL", JavaModName + "Blocks." + REGISTRYNAME + "_PORTAL")
					.replace("blockIn.blockMaterial", "blockIn.getDefaultState().getMaterial()")}
}
<#-- @formatter:on -->