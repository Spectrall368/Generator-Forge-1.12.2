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

public static class BlockCustomPortal extends BlockPortal {

	public BlockCustomPortal() {
		setHardness(-1.0f);
		setUnlocalizedName("${registryname}_portal");
		setRegistryName("${registryname}_portal");
		setLightLevel(${(data.portalLuminance * 15)?round}f);
	}

	@Override public void updateTick(World world, BlockPos pos, IBlockState state, Random random) {
		<#if hasProcedure(data.onPortalTickUpdate)>
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			<@procedureOBJToCode data.onPortalTickUpdate/>
		</#if>
	}

	public void portalSpawn(World worldIn, BlockPos pos) {
		BlockCustomPortal.Size portalsize = new BlockCustomPortal.Size(worldIn, pos, EnumFacing.Axis.X);
		if (portalsize.isValid() && portalsize.portalBlockCount == 0) {
			portalsize.placePortalBlocks();
		} else {
			portalsize = new BlockCustomPortal.Size(worldIn, pos, EnumFacing.Axis.Z);
			if (portalsize.isValid() && portalsize.portalBlockCount == 0)
				portalsize.placePortalBlocks();
		}
	}

	@Override ${mcc.getMethod("net.minecraft.block.BlockPortal", "createPatternHelper", "World", "BlockPos")
	               .replace("BlockPortal.", "BlockCustomPortal.")}

	@Override ${mcc.getMethod("net.minecraft.block.BlockPortal", "neighborChanged", "IBlockState", "World", "BlockPos", "Block", "BlockPos")
	               .replace("BlockPortal.", "BlockCustomPortal.")}

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
			world.playSound(pos.getX() + 0.5, pos.getY() + 0.5, pos.getZ() + 0.5, (net.minecraft.util.SoundEvent) net.minecraft.util.SoundEvent.REGISTRY
				.getObject(new ResourceLocation(("${data.portalSound}"))), SoundCategory.BLOCKS, 0.5f, random.nextFloat() * 0.4F + 0.8F, false);
		</#if>
	}

	public void onEntityCollidedWithBlock(World worldIn, BlockPos pos, IBlockState state, Entity entityIn) {
		if (!worldIn.isRemote && !entity.isRiding() && !entity.isBeingRidden()
				&& entityIn instanceof EntityPlayerMP && <@procedureOBJToConditionCode data.portalUseCondition/>) {
			EntityPlayerMP thePlayer = (EntityPlayerMP) entityIn;
			if (thePlayer.timeUntilPortal > 0) {
				thePlayer.timeUntilPortal = 10;
			} else if (thePlayer.dimension != DIMID) {
				thePlayer.timeUntilPortal = 10;
				ReflectionHelper.setPrivateValue(EntityPlayerMP.class, thePlayer, true, "invulnerableDimensionChange", "field_184851_cj");
				thePlayer.mcServer.getPlayerList().transferPlayerToDimension(thePlayer, DIMID, getTeleporterForDimension(thePlayer, pos, DIMID));
			} else {
				thePlayer.timeUntilPortal = 10;
				ReflectionHelper.setPrivateValue(EntityPlayerMP.class, thePlayer, true, "invulnerableDimensionChange", "field_184851_cj");
				thePlayer.mcServer.getPlayerList().transferPlayerToDimension(thePlayer, 0, getTeleporterForDimension(thePlayer, pos, 0));
			}
		}
	}

	private TeleporterDimensionMod getTeleporterForDimension(Entity entity, BlockPos pos, int dimid) {
		BlockPattern.PatternHelper bph = portal.createPatternHelper(entity.world, new BlockPos(pos));
		double d0 = bph.getForwards().getAxis() == EnumFacing.Axis.X ? (double) bph.getFrontTopLeft().getZ() : (double) bph.getFrontTopLeft().getX();
		double d1 = bph.getForwards().getAxis() == EnumFacing.Axis.X ? entity.posZ : entity.posX;
		d1 = Math.abs(MathHelper.pct(d1 - (double) (bph.getForwards().rotateY().getAxisDirection() == EnumFacing.AxisDirection.NEGATIVE ? 1 : 0), d0, d0 - (double) bph.getWidth()));
		double d2 = MathHelper.pct(entity.posY - 1, (double) bph.getFrontTopLeft().getY(), (double) (bph.getFrontTopLeft().getY() - bph.getHeight()));
		return new TeleporterDimensionMod(entity.getServer().getWorld(dimid), new Vec3d(d1, d2, 0), bph.getForwards());
	}

	public static class Size ${mcc.getInnerClassBody("net.minecraft.block.BlockPortal", "Size")
							      .replace("Blocks.OBSIDIAN", mappedBlockToBlockStateCode(data.portalFrame) + ".getBlock()")
								  .replace("Blocks.PORTAL", "portal")
								  .replace("blockIn.blockMaterial", "blockIn.getDefaultState().getMaterial()")}

}
